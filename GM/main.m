% Parameters
N = 4; % Number of nodes
nsamples = 10000; % Number of samples to use for MLE and EM.
max_iter = 50; % Maximum number of iterations for EM.
hide_prop = 0.5 % proportion of data to hide.
% Constant added to computed probabilities to avoid division by zero 
% in computing KL
eps = 0.0000001;

% Construct DAG
dag = zeros(N,N);
C = 1; S = 2; R = 3; W = 4;
dag(C,[R S W]) = 1;
dag(R,W) = 1;
dag(S,W)=1;

% Nodes are labelled 1 to N.
discrete_nodes = 1:N;
% All variables are binary
node_sizes = 2*ones(1,N); 

% Construct Bayesian Net from from DAG for sampling.
bnet = mk_bnet(dag, node_sizes, 'discrete', discrete_nodes);
bnet.CPD{C} = tabular_CPD(bnet, C, [0.2 0.8]);
bnet.CPD{R} = tabular_CPD(bnet, R, [0.5 0.6 0.5 0.4]);
bnet.CPD{S} = tabular_CPD(bnet, S, [0.9 0.2 0.1 0.8]);
bnet.CPD{W} = tabular_CPD(bnet, W, [0.9 0.1 0.5 0.5 0.5 0.5 0.5 0.5 0.1 0.9 0.5 0.5 0.5 0.5 0.5 0.5]);

CPT = getCPT(bnet, N);
dispcpt(CPT{4})

evidence = cell(1,N);
engine1a = jtree_inf_engine(bnet);
[engine1b, ~] = enter_evidence(engine1a, evidence);
m = marginal_nodes(engine1b, [C R S W]);
net_prob = reshape(m.T, 1, 2^N) + eps

% Generate samples from bnet.
samples = cell(N, nsamples);
for i=1:nsamples
  samples(:,i) = sample_bnet(bnet);
end

% Initialize bnet with random parameters.
bnet2 = mk_bnet(dag, node_sizes);
seed = 0;
rand('state', seed);
bnet2.CPD{C} = tabular_CPD(bnet2, C);
bnet2.CPD{R} = tabular_CPD(bnet2, R);
bnet2.CPD{S} = tabular_CPD(bnet2, S);
bnet2.CPD{W} = tabular_CPD(bnet2, W);
engine2 = jtree_inf_engine(bnet2);

% Learn MLE from all the data.
bnet3 = learn_params(bnet2, samples);
engine3a = jtree_inf_engine(bnet3);
CPT3 = getCPT(bnet3, N);
dispcpt(CPT3{4})
% Compute joint distribution from full data.
evidence = cell(1,N);
[engine3b, ~] = enter_evidence(engine3a, evidence);
m = marginal_nodes(engine3b, [C R S W]);
mle_prob = reshape(m.T, 1, 2^N) + eps

% Hide values.
samples2 = samples;
% hide = rand(N, nsamples) > hide_prop;
% [I,J]=find(hide);
% for k=1:length(I)
%   samples2{I(k), J(k)} = [];
% end
for k=1:nsamples
    % Hide the sample if generated random number is withing hide_proportion
    if rand() < hide_prop
        samples2{N, k} = [];
    end
end

% Learn bnet from partial data using EM
[bnet4, LLtrace, engine4a] = learn_params_em(engine2, samples2, max_iter);
CPT4 = getCPT(bnet4, N);
dispcpt(CPT4{4})
% CPT4{4}
% Compute joint distribution for original data.
evidence = cell(1,N);
[engine4b, ll] = enter_evidence(engine4a, evidence);
m = marginal_nodes(engine4b, [C R S W]);
em_prob = reshape(m.T, 1, 2^N) + eps

% Compute KL divergence
event_set = [1:2^N]';
mle_kl = kldiv(event_set, mle_prob', net_prob')
em_kl = kldiv(event_set, em_prob', net_prob') 

plot(LLtrace / nsamples, 'x-')
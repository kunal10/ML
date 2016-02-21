% load data
load icaTest.mat;
load sounds.mat;

% Parameters
NUM_SAMPLES = 3;
NUM_SIGNALS = 3;
NUM_ITERS = 100;
LEARNING_RATE = 0.01;

%Indices = datasample(1:size(U,1), NUM_SIGNALS, 'Replace', false);
Indices = [1, 3, 4];
fprintf('Using signals\n');
Indices
U = sounds(Indices, :);

% Perform mixing of the signals to generate observed data.
%whos;
X = combineSignals(U, NUM_SAMPLES, NUM_SIGNALS);

% Perform independent component analysis.
[Y] = findIndependentComponents(NUM_ITERS, LEARNING_RATE, NUM_SIGNALS, X);

% Plot results
plotResults(X, Y, U);
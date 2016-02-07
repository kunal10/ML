% Load data.
load digits.mat;

% Reshape images to column vectors.
trainImages = reshapeImages(trainImages);
testImages = reshapeImages(testImages);
hardImages = testImages(:, 1:5000);
hardLabels = testLabels(:, 1:5000);
easyImages = testImages(:, 5001:end);
easyLabels = testLabels(:, 5001:end);

% Find eigen basis.
% k = 100;    

easyAccuracy = zeros(50, 1);
hardAccuracy = zeros(50, 1);

% Uncomment below statements when you want to use both euclidean and cosine
% distance based models.
% easyAccuracy2 = zeros(50, 1);
% hardAccuracy2 = zeros(50, 1);

SampleSizes = [10:10:500];
i = 0;
for k = SampleSizes
    i = i+1;
[A, Indices] = datasample(trainImages, k, 2, 'Replace', false);
trainingLabels = trainLabels(Indices);
[ANorm, AMu, V, D] = hw1FindEigendigits(A);

% Uncomment below statement when iterating over numComponents and change 
% 1. size of Accuracy vectors defined above.
% 2. for loop variable to numComponents.
% Y = V; E = D; Components = [10:10:500]

% Uncomment below statements when you want to iterate over neighbors and 
% change the following:
% 1. size of Accuracy vectors defined above.
% 2. for loop variable to numNeighbors.
% Neighbors = [1:20];

% i = 0;
% for numComponents = Components
%     i = i+1;
    % Select Principal Components.
    % [V, D] = findPrincipalComponents(Y, E, numComponents);

    % Train models
    distance = 'cosine';
    model = training(trainingLabels, ANorm, V, numNeighbors, distance);
    % distance = 'euclidean';
    % model2 = training(trainingLabels, ANorm, V, numNeighbors, distance);

    % Test
    testSamples = 100;
    [easyTests, Indices] = ... 
        datasample(easyImages, testSamples, 2, 'Replace', false);
    easyAccuracy(i) = test(easyTests, easyLabels(Indices), model, AMu, V);
    % easyAccuracy2(i) = test(easyTests, easyLabels(Indices), model2, AMu, V);

    [hardTests, Indices] = ...
        datasample(hardImages, testSamples, 2, 'Replace', false);
    hardAccuracy(i) = test(hardTests, hardLabels(Indices), model, AMu, V); 
    % hardAccuracy2(i) = test(hardTests, hardLabels(Indices), model2, AMu, V); 
end

figure('name', 'Accuracy Vs Sample Size');

% subplot(2,2,1)
plot(SampleSizes, easyAccuracy, '-ro', SampleSizes, hardAccuracy, '-.b'),
xlabel('Number of Samples'), ylabel('Accuray (%)'), 
legend('Easy', 'Hard'), grid on

% subplot(2,2,2)
% plot(SampleSizes, easyAccuracy2, '-ro', SampleSizes, hardAccuracy2, '-.b'),
% xlabel('# Number of Samples'), ylabel('Accuray (%)'), 
% legend('Easy', 'Hard'), grid on


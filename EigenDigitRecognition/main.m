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
% k = 500;

easyAccuracy = zeros(50, 1);
hardAccuracy = zeros(50, 1);
numSamples = [10:10:500];
i = 0;
for k = numSamples
    i = i+1;
    [A, Indices] = datasample(trainImages, k, 2, 'Replace', false);
    [ANorm, AMu, V, D] = hw1FindEigendigits(A);

    % Select Principal Components.
    % [V, D] = findPrincipalComponents(V, D, 0.99);

    % Train model
    distance = 'cosine';
    numNeighbors = 1;
    model = training(trainLabels(Indices), ANorm, V, numNeighbors, distance);

    % Test
    samples = 1000;
    [easyTests, Indices] = ... 
        datasample(easyImages, samples, 2, 'Replace', false);
    easyAccuracy(i) = test(easyTests, easyLabels(Indices), model, AMu, V);

    [hardTests, Indices] = ...
        datasample(hardImages, samples, 2, 'Replace', false);
    hardAccuracy(i) = test(hardTests, hardLabels(Indices), model, AMu, V); 
end

figure('name', 'Accuracy vs Traning Data Size');
plot(numSamples, easyAccuracy, '-ro', numSamples, hardAccuracy, '-.b'),
legend('Easy', 'Hard'), grid on


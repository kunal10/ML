% Load data.
load digits.mat;

% Reshape images to column vectors.
trainImages = reshapeImages(trainImages);
testImages = reshapeImages(testImages);
hardImages = testImages(:, 1:5000);
hardLabels = testLabels(:, 1:5000);
easyImages = testImages(:, 5001:end);
easyLabels = testLabels(:, 5001:end);

k = 350;
[A, ~] = datasample(trainImages, k, 2, 'Replace', false);
[ANorm, AMu, V, D] = hw1FindEigendigits(A);

easyAccuracy = zeros(10,1);
hardAccuracy = zeros(10,1);

% i = 0;
% for trainingSetSize = [100 500 1000 1500 2000 3000 4000 5000 10000 20000]
% fprintf('Training Set Size: %d', trainingSetSize)
% i = i + 1;
% trainingSetSize = 100;
trainingSetSize = 3000;
[trainingData, trainingIndices] = ...
    datasample(trainImages, trainingSetSize, 2, 'Replace', false);
trainingLabels = trainLabels(trainingIndices);

pcaTrainingData = bsxfun(@minus, double(trainingData), AMu);
pcaTrainingData = double(pcaTrainingData') * V;

i = 0
for j = [-3 -2 -1 0 1 2 3]
i = i + 1
boxConstraint = 10 ^ j
params = templateSVM('KernelFunction', 'linear', 'KernelScale', 'auto', 'BoxConstraint', boxConstraint);
pcaModel = fitcecoc(pcaTrainingData, trainingLabels', 'Learners', params, 'Coding', 'onevsall');

% Test
testSamples = 500;
[easyTests, Indices] = ... 
    datasample(easyImages, testSamples, 2, 'Replace', false);
[pcaEasyAccuracy, pcaEasyPredictedLabels] = pcaTest(easyTests, easyLabels(Indices), pcaModel, AMu, V);
% pcaEasyConfMat = confusionmat(easyLabels(Indices), pcaEasyPredictedLabels);
easyAccuracy(i) = pcaEasyAccuracy;

[hardTests, Indices] = ...
    datasample(hardImages, testSamples, 2, 'Replace', false);
[pcaHardAccuracy, pcaHardPredictedLabels] = pcaTest(hardTests, hardLabels(Indices), pcaModel, AMu, V); 
% pcaHardConfMat = confusionmat(hardLabels(Indices), pcaHardPredictedLabels);
hardAccuracy(i) = pcaHardAccuracy;
end

easyAccuracy
hardAccuracy

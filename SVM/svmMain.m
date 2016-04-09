% Load data.
load digits.mat;

% Reshape images to column vectors.
trainImages = reshapeImages(trainImages);
testImages = reshapeImages(testImages);
hardImages = testImages(:, 1:5000);
hardLabels = testLabels(:, 1:5000);
easyImages = testImages(:, 5001:end);
easyLabels = testLabels(:, 5001:end);

easyAccuracy = zeros(10, 1);
hardAccuracy = zeros(10, 1);
% i = 0;
% for trainingSetSize = [100 200 500 1000 1500 2000 3000 4000 5000]
% fprintf('Training Set Size: %d', trainingSetSize)
% i = i + 1;
trainingSetSize = 3000;
[trainingData, trainingIndices] = ...
    datasample(trainImages, trainingSetSize, 2, 'Replace', false);
trainingData = double(trainingData);
trainingLabels = trainLabels(trainingIndices);

i = 0
for j = [-3 -2 -1 0 1 2 3]
i = i + 1
boxConstraint = 10 ^ j
params = templateSVM('KernelFunction', 'linear', 'KernelScale', 'auto', 'BoxConstraint', boxConstraint);
model = fitcecoc(trainingData', trainingLabels', 'Learners', params, 'Coding', 'onevsall');

% Test
testSamples = 500;
[easyTests, Indices] = ... 
    datasample(easyImages, testSamples, 2, 'Replace', false);
[svmEasyAccuracy, svmEasyPredictedLabels] = test(easyTests, easyLabels(Indices), model);
svmEasyConfMat = confusionmat(easyLabels(Indices), svmEasyPredictedLabels);
easyAccuracy(i) = svmEasyAccuracy;

[hardTests, Indices] = ...
    datasample(hardImages, testSamples, 2, 'Replace', false);
[svmHardAccuracy, svmHardPredictedLabels] = test(hardTests, hardLabels(Indices), model); 
svmHardConfMat = confusionmat(hardLabels(Indices), svmHardPredictedLabels);
hardAccuracy(i) = svmHardAccuracy;
end

easyAccuracy
hardAccuracy
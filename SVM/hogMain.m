% Load data.
load digits.mat;

% Reshape images to column vectors.
trainImages = reshapeImages(trainImages);
testImages = reshapeImages(testImages);
hardImages = testImages(:, 1:5000);
hardLabels = testLabels(:, 1:5000);
easyImages = testImages(:, 5001:end);
easyLabels = testLabels(:, 5001:end);

easyAccuracy = zeros(9, 1);
hardAccuracy = zeros(9, 1);

% Extract HOG features and HOG visualization
img = reshape(trainImages(:, 1), [28,28]);
% img = rgb2gray(img);
% img = imbinarize(img);
[hog_2x2, vis2x2] = extractHOGFeatures(img,'CellSize',[2 2]);
[hog_4x4, vis4x4] = extractHOGFeatures(img,'CellSize',[4 4]);
[hog_8x8, vis8x8] = extractHOGFeatures(img,'CellSize',[8 8]);

cellSize = [2 2];
hogFeatureSize = length(hog_2x2);

% i = 0;
% for trainingSetSize = [100 200 500 1000 1500 2000 3000 4000 5000]
% i = i + 1;
trainingSetSize = 3000;
fprintf('Training Set Size: %d', trainingSetSize)

[trainingData, trainingIndices] = ...
    datasample(trainImages, trainingSetSize, 2, 'Replace', false);
   
trainFeatures = getHogFeatures(trainingData, trainingSetSize, cellSize, hogFeatureSize);

% trainingFeatures = [trainingFeatures; features];  
trainingLabels = trainLabels(trainingIndices);

i = 0
for j = [-3 -2 -1 0 1 2 3]
i = i + 1
boxConstraint = 10 ^ j

params = templateSVM('KernelFunction', 'linear', 'KernelScale', 'auto', 'BoxConstraint', boxConstraint);
model = fitcecoc(trainFeatures, trainingLabels', 'Learners', params, 'Coding', 'onevsall');



% Test
testSamples = 500;
[easyTests, Indices] = ... 
    datasample(easyImages, testSamples, 2, 'Replace', false);
easyTestFeatures = getHogFeatures(easyTests, testSamples, cellSize, hogFeatureSize);
[svmEasyAccuracy, svmEasyPredictedLabels] = test(easyTestFeatures', easyLabels(Indices), model);
svmEasyConfMat = confusionmat(easyLabels(Indices), svmEasyPredictedLabels);
easyAccuracy(i) = svmEasyAccuracy;

[hardTests, Indices] = ...
    datasample(hardImages, testSamples, 2, 'Replace', false);
hardTestFeatures = getHogFeatures(hardTests, testSamples, cellSize, hogFeatureSize);
[svmHardAccuracy, svmHardPredictedLabels] = test(hardTestFeatures', hardLabels(Indices), model); 
svmHardConfMat = confusionmat(hardLabels(Indices), svmHardPredictedLabels);
hardAccuracy(i) = svmHardAccuracy;

end

easyAccuracy
hardAccuracy
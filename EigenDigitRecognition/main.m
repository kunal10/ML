load digits.mat;
[model ANorm AMu V] = training(trainImages, trainLabels, 600, 1);
accuracy = test(testImages, testLabels, model, AMu, V, 5000);
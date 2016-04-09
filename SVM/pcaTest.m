function [accuracy, predictions] = pcaTest(testFeatures, testLabels, model, AMu, V)

% Display n orignal images.
% n = 10;
% figure('name','Orignal Image');
% Image = constructImage(testFeatures, eye(784), n);
% imshow(Image(:, 1 : 28 * n));

T = bsxfun(@minus, double(testFeatures), AMu);

% Display 10 reconstructed images.
% figure('name','Reconstructed Image');
% Image = constructImage(T, V, n);
% imshow(Image(:, 1:28 * n));

% Project test data into eigen space
TS =  T' * V;

% Predict labels and find accuracy
accuracy = 0;
predictions = predict(model, TS);
for i = 1:size(TS, 1)    
    if(predictions(i) == testLabels(i))
        accuracy = accuracy + 1;
    end
end
accuracy = (accuracy * 100) / size(TS, 1)
end
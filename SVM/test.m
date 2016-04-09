function [accuracy, predictions] = pcaTest(testFeatures, testLabels, model)

% Predict labels and find accuracy
accuracy = 0;
testFeatures = double(testFeatures);
predictions = predict(model, testFeatures');
for i = 1:size(testFeatures', 1)    
    if(predictions(i) == testLabels(i))
        accuracy = accuracy + 1;
    end
end
accuracy = (accuracy * 100) / size(testFeatures', 1)
end
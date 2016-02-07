function [accuracy] = test(testImages, testLabels, model, AMu, V)

% Display n orignal images.
% n = 10;
% figure('name','Orignal Image');
% Image = constructImage(testImages, eye(784), n);
% imshow(Image(:, 1 : 28 * n));

T = bsxfun(@minus, double(testImages), AMu);

% Display 10 reconstructed images.
% figure('name','Reconstructed Image');
% Image = constructImage(T, V, n);
% imshow(Image(:, 1:28 * n));

% Project test data into eigen space
TS =  T' * V;

% Predict labels and find accuracy
accuracy = 0;
for i = 1:size(TS, 1)
    digit = predict(model, TS(i, :));
    if(digit == testLabels(i))
        accuracy = accuracy + 1;
    end
end
accuracy = (accuracy * 100) / size(TS, 1)
end
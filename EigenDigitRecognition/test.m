function [accuracy] = test(testImages, testLabels, model, AMu, V, k)
[T Indices] = reverseSampleAndReshape(testImages, k);
L = testLabels(Indices);
size(T)
T = bsxfun(@minus, double(T), AMu);
Image = constructImage(T, V);
imshow(Image(:,1:280));

% Project test data into eigen space
TS =  T' * V;
size(TS)
accuracy = 0;
for i = 1:size(TS, 1)
    digit = predict(model, TS(i, :));
    if(digit == L(i))
        accuracy = accuracy + 1;
    end
end
accuracy = accuracy / k
end

function [S, Indices] = reverseSampleAndReshape(Images, k)
[s1 s2 s3 s4] = size(Images);
Indices = [5001:5000+k];
S = reshape(Images(:, :, :, Indices), s1 * s2 * s3, k);
end
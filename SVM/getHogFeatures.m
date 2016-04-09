function [features] = getHogFeatures(imageFeatures, setSize, cellSize, hogFeatureSize)
features  = zeros(setSize, hogFeatureSize, 'single');
for i = 1:setSize
    img = reshape(imageFeatures(:, i), [28,28]);
%     img = rgb2gray(img);

%     Apply pre-processing steps
%     img = imbinarize(img);

    features(i, :) = extractHOGFeatures(img, 'CellSize', cellSize);
end
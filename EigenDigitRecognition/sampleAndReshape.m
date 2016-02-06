function [S K] = sampleAndReshape(Images, k)
[s1 s2 s3 s4] = size(Images);
K = [1:k];
S = reshape(Images(:, :, :, K), s1 * s2 * s3, k);
end
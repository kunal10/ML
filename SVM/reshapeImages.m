function reshapedImages = reshapeImages(Images)
% Reshape every image as a column vector.
    [s1 s2 s3 s4] = size(Images);
    reshapedImages = reshape(Images, s1 * s2 * s3, s4);
end
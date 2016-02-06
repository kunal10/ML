function [Image] = constructImage(Images, V)
    % Reconstructs a 2D image for each image in Images by projecting on 
    % Eigen Space and concatenating all of them.
    Images = double(Images);    
    Image = V * V' * Images;
    [~, n] = size(Images);
    Image = reshape(Image, 28, 28 * n);
end
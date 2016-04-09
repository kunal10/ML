function [Image] = constructImage(Images, V, k)
    % Reconstructs a 2D image from projections of 1st k images in Images on 
    % Column Space of V and concatenating all of them.
    Images = Images(:,1:k);
    Images = double(Images);    
    Image = V * V' * Images;
    Image = reshape(Image, 28, 28 * k);
end
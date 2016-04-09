function [ANorm, AMu, V, D] = hw1FindEigendigits(A)
[r c] = size(A);
A = double(A);
AMu = mean(A,2);
ANorm = bsxfun(@minus, A, AMu);
Cov = (ANorm' * ANorm) .* (1/c);
[V D] = eig(Cov);

% Transform eigen basis for ANorm' * ANorm to find top k eigen vectors for 
% its transpose
V = ANorm * V;
[D, Indices] = sort(diag(D), 'descend');
V = V(:, Indices);

% Display top n eigen vectors.
% n = 20;
% figure('name','Top 20 Eigen Vectors');
% Image = constructImage(V, V, n);
% imshow(Image(:, 1:28 * n));

V = normc(V);
end
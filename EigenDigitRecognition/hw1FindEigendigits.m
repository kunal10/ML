function [ANorm, AMu, V] = hw1FindEigendigits(A)
[r c] = size(A);
A = double(A);
AMu = mean(A,2);
ANorm = bsxfun(@minus, A, AMu);
Cov = (ANorm' * ANorm) .* (1/c);
size(Cov)
[V D] = eig(Cov);
% Transform eigen basis for ANorm' * ANorm to find top k eigen vectors for 
% its transpose
size(V)
V = ANorm * V;
[D, Indices] = sort(diag(D), 'descend');
size(V)
V = V(:, Indices);
%EigenDigits = constructImage(V, V);
% imshow(EigenDigits);
V = normc(V);
size(V)
end
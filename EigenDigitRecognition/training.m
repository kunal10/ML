function [model, A, AMu, V] = training(trainImages, trainLabels, k, numNeighbors)
[A, K] = sampleAndReshape(trainImages, k);
[ANorm, AMu, V] = hw1FindEigendigits(A);
model = fitcknn(double(ANorm') * double(V), trainLabels(K)', 'NumNeighbors', numNeighbors, 'Distance', 'cosine');
% model.NumNeighbors = numNeighbors;
end
function [model] = training(trainLabels, ANorm, V, ...
    numNeighbors, distance)
    % This function projects data used for finding top eigen vectors onto 
    % eigen space and uses it to train a kNN model.
    trainData = double(ANorm') * double(V);
    model = fitcknn(trainData, trainLabels, 'NumNeighbors', ...
        numNeighbors, 'Distance', distance);
end


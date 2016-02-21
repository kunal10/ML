function [Y] = findIndependentComponents(numIters, learningRate, n, X)
% Finds independent components in observed data (assuming that is generated
% from linear combination of non-gaussian variables.

    [m, t] = size(X);
    
    % Generate random matrix with small values.
    W = 0.1 * rand(n, m);
    
    % TODO : Add convergence criteria to break early.
    % gradientHistory = zeros(numIters);
    for (iter = 1:numIters)
        Y = W * X;
        Z = sigmoid(Y);
        deltaW = findDeltaW(learningRate, Z, Y, W);
        W = W + deltaW;
        % gradientHistory(iter) = deltaW; 
    end
end

function [deltaW] = findDeltaW(learningRate, Z, Y, W)
    [n t] = size(Z);
    Ones = ones(n, t);
    deltaW = learningRate * ((eye(n) + (Ones - 2 * Z) * Y') * W);
end

function [Z] = sigmoid(Y)    
    [numRows numCols] = size(Y);
    Z = zeros(numRows, numCols);
    for (row = 1:numRows)
        for(col = 1:numCols)
            Z(row, col) = 1 / (1 + exp(-1 * Y(row, col)));
        end
    end           
end



function [X] = combineSignals(U, numSamples, numSignals)
    %[r c] = size(U);
    
    A = rand(numSamples, numSignals);
    A = normr(A);
    X = A * U;
end


function [] = plotResults(X, Y, U)
    figure('name', 'Original Signals');
    plotSignals(U);
    
    figure('name', 'Observed Signals');
    plotSignals(X);
    
    figure('name', 'Signals from ICA');
    plotSignals(Y);
end

function [] = plotSignals(M)
    M = rescaleMatrix(M, -1, 1);
    numSignals = size(M,1);
    for (i = 1:numSignals)
        subplot(numSignals, 1, i)
        plot(M(i,:)),
        xlabel(sprintf('Signal %d\n', i)), ylabel('Amplitude');        
    end
end


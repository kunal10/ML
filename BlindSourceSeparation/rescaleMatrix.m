function [rescaledM] = rescaleMatrix(M, s, e)
    [rows, cols] = size(M);
    rescaledM = zeros(rows, cols);
    for (row = 1:rows)
        rescaledM(row, :) = rescaleRow(M(row, :), s, e);
    end
end

function y = rescaleRow(x, s, e)
    eps = 0.01;
    minVal = min(x(:));
    maxVal = max(x(:));
    if (maxVal - minVal < eps) 
        y = x;
    else
        y = (e - s) * (x - minVal)/(maxVal - minVal) + s;
    end
end


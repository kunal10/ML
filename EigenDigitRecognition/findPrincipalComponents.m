function [V, D] = findPrincipalComponents(V, D, numComponents)
% Finds top numComponents eigen vectors. 
%     size(V)
%     size(D)
%     numComponents
    V = V(:, 1:numComponents);
    D = D(1:numComponents, 1);
end

% function [V, D] = findPrincipalComponents(V, D, energyRatio)
% % Finds top k eigen vectors which comprise of about 99% of energy.
%     total = sum(D);
%     energySum = 0;
%     numVectors = size(D,1);
%     for i = 1:size(D,1)
%         energySum = energySum + D(i,1);
%         if (energySum >= energyRatio * total)
%             numVectors = i;
%             break;
%         end
%     end
%     % fprintf('Using top %d eigen vectors\n',numVectors);
%     V = V(:, 1:numVectors);
%     D 
% end

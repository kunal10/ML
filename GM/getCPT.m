function [CPT] = getCPT(net, num_nodes)
    CPT = cell(1,num_nodes);
    for i=1:num_nodes
      s=struct(net.CPD{i});
      CPT{i}=s.CPT;
    end
end


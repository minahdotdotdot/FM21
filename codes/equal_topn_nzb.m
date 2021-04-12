function simObj =equal_topn_nzb(simObj, winners)
    % Pick best-performing stocks each period
    a = (1+(winners)/simObj.d)/2;
    b = 1-a;
    if nargin<2
        lambda = 0.5;
    end
    simObj.reset(); % reset simulation environment   
    for x=1:simObj.T
        if x==1
            w_const = ones(simObj.d,1)/simObj.d;
            simObj.step(w_const);
        end
        if x>1
            w = zeros(simObj.d,1);
            [~, sortedInds] = sort(simObj.s_cur(:),'descend');
            w(sortedInds(1:winners))=a/winners;
            w(sortedInds(winners+1:end))=b/(simObj.d-winners);
            w = w / sum(w);
            simObj.step(w);
        end          
    end
end
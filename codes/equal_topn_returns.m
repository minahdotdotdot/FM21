function simObj =equal_topn_returns(simObj, winners)
    % Pick best-performing stocks each period
    
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
            r = (simbObj.s_hist(:,x)-simObj.s_hist(:,x-1)) ./ simObj.s_hist(:,x-1);
            [~, sortedInds] = sort(r(:),'descend');
            w(sortedInds(1:winners))=1/winners;
            simObj.step(w);
        end          
    end
end
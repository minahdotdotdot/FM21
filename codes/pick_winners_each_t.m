function simObj =pick_winners_each_t(simObj, lambda,lambda_max)
    % Pick best-performing stocks each period
    
    if nargin<2
        lambda = 0.5;
    end
    simObj.reset(); % reset simulation environment
    ilambda = 1/lambda;
    
    %calculate number of stocks to pick based on lambda
    winners = floor((lambda*simObj.d)/lambda_max);
        if winners <0
            winners=1;
        end
        if winners > simObj.d
            winners= simObj.d;
        end
    %winners=min(round(lambda)+1,simObj.d);
    
     
    
for x=1:simObj.T
        if x==1
            w_const = ones(simObj.d,1)/simObj.d;
            simObj.step(w_const);
        end
        if x>1
            [~, sortedInds] = sort(simObj.s_cur(:),'descend');
            temp = sortedInds(1:winners);
            temp2 = zeros(simObj.d,1);
            temp2(temp)=1;
            %w_const=simObj.s_cur(:).*temp2; %only assign postive weights to best-performing stocks
            w_const=(simObj.s_cur(:).^ilambda).*temp2; %assign weights based on prices
            w_const = w_const./sum(w_const); % new weight vector
            simObj.step(w_const);
        end          
end
end
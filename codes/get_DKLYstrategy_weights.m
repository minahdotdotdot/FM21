function w =get_DKLYstrategy_weights(simObj, lambda)
    k = .25;
    lambda_0=25;
    % Compute alpha and n.
    [a,n] = mapl2a(lambda, simObj.d, k, lambda_0);

    w = zeros(simObj.d,1);
    % Order stocks by stock prices in descending order.
    [~, sortedInds] = sort(simObj.s_cur(:),'descend');

    % Set winners to alpha/n.
    w(sortedInds(1:n))=a/n;

    % Set losers to (1-alpha)/(d-n)
    w(sortedInds(n+1:end))=(1-a)/(simObj.d-n);

    % Make sure weights add up to 1. 
    w = w / sum(w);
end
function [a,n] = mapl2a(lambda, d, k, lambda_0)
    n = mapl2n(lambda,d, k, lambda_0);
    if lambda < lambda_0
        a = 1+((-1+n/d)/(lambda_0))*lambda;
    else
        a=n/d;
    end
end

function n = mapl2n(lambda, d, k,lambda_0)
    n = round(1+((d-1)/(1+exp(-k*(lambda-lambda_0)))));
end
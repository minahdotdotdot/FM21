function [a,n] = mapl2a(lambda, d, k, lambda_0)
    n = mapl2n(lambda,d, k, lambda_0);
    %lambda_0=(3/4)*d;
    if lambda < lambda_0
        a = 1+((-1+n/d)/(lambda_0))*lambda;
    else
        a=n/d;
    end
end

function n = mapl2n(lambda, d, k,lambda_0)
    %k=0.5;
    n = round(1+((d-1)/(1+exp(-k*(lambda-lambda_0)))));
end
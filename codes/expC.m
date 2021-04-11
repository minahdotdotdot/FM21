%% Experiment A
% We will try equal weights for the top n (by price) stocks.
addpath('../../MathWorks');
T = 500;
rng(123);

%d = 50; 
ds = (5:5:100);
lambdas = linspace(0.2,10,100);

for jj = 1 : length(ds)
    d = ds(jj);
    %% Initialize Simobj.
    initialize_sim

    %% Run experiment
    ns = linspace(1,d,d); % n is winners.
    trials = 200; %number of trials

    results = zeros(length(ns), trials);
    for ii = 1 : length(ns)
        n = round(ns(ii));
        for t = 1 : trials
            if rem(t,10)==0
                [d,n,t]
            end
            simObj = equal_topn_returns(simObj,n);
            results(ii,t) = simObj.R_hist(end);
        end
    end

    means = mean(results,2);
    vars = var(results,0,2);
    maxn = zeros(size(lambdas));
    happinesses = zeros(size(lambdas));
    for ll = 1 : length(lambdas)
        lambda=lambdas(ll)
        [val,ind]=max(means-lambda*vars);
        maxn(ll)= ind;
        happinesses(ll)=val;
    end
    save(sprintf('../data/%03d-portfolioC.mat',d),'means','vars','maxn','happinesses')
end

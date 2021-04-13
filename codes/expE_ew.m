clear all; close all; clf;
%% Experiment E with equal weights
% We will try our cool strategy.
addpath('../../MathWorks');
T = 500;
rng(123);

d = 50; 
%ds = (5:5:100);
nL=1000;
lambdas = linspace(0.01,50,nL);
trials = 500;
initialize_sim
results = zeros(nL,trials);
for jj = 1 : length(lambdas)
    lambda = lambdas(jj)
    %% Run experiment
    for t = 1 : trials
        % if rem(t,50)==0
        %     [jj,t]
        % end
        simObj = equal_weights(simObj,lambda);
        results(jj,t) = simObj.R_hist(end);
    end
end

means = mean(results,2);
vars = var(results,0,2);
maxn = zeros(size(lambdas));
happinesses = zeros(size(lambdas));
for ll = 1 : length(lambdas)
    lambda=lambdas(ll);
    [val,ind]=max(means-lambda*vars);
    maxn(ll)= ind;
    happinesses(ll)=val;
end
save('../data/equal_weights.mat','means','vars','maxn','happinesses','results')
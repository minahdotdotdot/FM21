%% Experiment A
% We will try equal weights for the top n (by price) stocks.
addpath('../../MathWorks');

d = 50; 
T = 500;

%% Initialize Simobj.
initialize_sim

%% Run experiment
ns = linspace(1,50,50); % n is winners.
trials = 10; %number of trials

results = zeros(length(ns), trials);
for ii = 1 : length(ns)
    n = round(ns(ii))
    for t = 1 : trials
        simObj = equal_topn(simObj,n);
        results(ii,t) = simObj.R_hist(end);
    end
end

means = mean(results,2);
vars = var(results,2);

clf();
figure(1);
plot(ns,means); hold on;
plot(ns, means-vars/sqrt(trials)); hold on;
saveas(gcf,"../figs/ex.png")



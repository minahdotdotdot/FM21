%parpool(10);
addpath("/projects/luya7574/MathWorks/");
cd ('/projects/luya7574/FM21/codes/')
%% Model and Simulator Initialization 
% rng(0)
% Initialize Model Parameters
T = 500;
d = 20;
eta = 0.0002;

Mrank = floor(0.25*d);
[U,S,V] = svd( randn(d,d) );
diagM = diag( [ normrnd(0,1,Mrank,1) ; zeros(d-Mrank,1) ] );
M = 5e-3 * U * diagM * V'; % Randomly generated matrix of rank Mrank

mu = 2e-5 * normrnd(0,1,d,1).^2;
c = 1e-8 * normrnd(0,1,d,1).^2;
s0 = 100*ones(d,1);

% Initialize Simulation Environment
model_params = struct('mu',mu,'M',M,'c',c,'eta',eta);
simObj = MarketSimulator(T,s0,model_params);

%simObj1 = do_nothing(simObj,lambda);
%lambda=10;
%tic;test_strategy(simObj,lambda);toc;

%[simObj2,efp,serr] = test_strategy(simObj,lambda);


% dprime = 12;
% plot(serr(dprime,end-40:end));hold on;
% plot(simObj2.s_hist(dprime,end-40:end));
% legend(["predicted","actual"])
% saveas(gcf,'viewerr.png');clf();


%% Computing the Target Objective for a Strategy
nsims = 100;
%lambda = 0.25;

% lambdas = linspace(1,nl/2,nl)/nl;
% means = zeros(nl,3);
% vars = zeros(nl,3);
% losses = zeros(nl,3);
nl = 10;
lambdas = linspace(0.2,10,nl);
cumret_array = zeros(nl,nsims,3);
%parpool
parfor jj =1 : nl
    lambda = lambdas(jj);
    ca = zeros(nsims,3)
    for kk=1:nsims
        simObj = MarketSimulator(T,s0,model_params);
        disp("lambda = "+lambda+", sim: "+kk)
        % Store each simulation's result in array
        simObj = do_nothing(simObj,lambda);
        ca(kk,1) = simObj.R_hist(end);
        simObj = example_strategy_2(simObj,lambda);
        ca(kk,2) = simObj.R_hist(end);
        [simObj,efp,serr] = test_strategy(simObj,lambda);
        ca(kk,3) = simObj.R_hist(end);
    end
    cumret_array(jj,:,:) = ca;
    means(jj,:) = mean(ca,1);
    vars(jj,:) = var(ca,1);
    losses(jj,:) = means(jj,:) - 0.5 * lambda*vars(jj,:);
    %save('../data/test2_0328.mat','cumret_array','means','vars','losses','lambdas')
end
save('../data/test3_0328.mat','cumret_array','means','vars','losses','lambdas')
% means = squeeze(mean(cumret_array,2));
% vars = squeeze(var(cumret_array,2));
% losses = means - .5*lambdas.*vars;

for jj = 1 : 3
    m = mean(losses(:,jj));
    scatter(vars(:,jj),means(:,jj),'filled','DisplayName',"strategy "+num2str(jj)+", maxobj:"+num2str(m))
    hold on
end
legend
xlabel('Variance')
ylabel('Expected Value')
title("Compare Strategies")
saveas(gcf,"../figs/test2_0328.png")
clf();

save('../data/test2_0328.mat','cumret_array','means','vars','losses','lambdas')

plot(lambdas(:), losses(:,1)); hold on;
plot(lambdas(:), losses(:,2)); hold on;
plot(lambdas(:), losses(:,3)); hold on;
legend(["do nothing","strat2","my strat"])
saveas(gcf,"../figs/losses.png")
clf();
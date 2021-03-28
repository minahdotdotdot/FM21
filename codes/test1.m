addpath("/projects/luya7574/MathWorks/");
cd ('/projects/luya7574/FM21/codes/')
%% Model and Simulator Initialization 
% rng(0)
% Initialize Model Parameters
T = 45;
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

% simObj1 = do_nothing(simObj,lambda);
lambda=1;
[simObj2,efp] = test_strategy(simObj,lambda);

%% Computing the Target Objective for a Strategy

nsims = 100;
%lambda = 0.25;
cumret_array = zeros(nsims,3);
nl = 8
lambdas = linspace(1,nl/2,nl)/nl;
means = zeros(nl,3);
vars = zeros(nl,3);
losses = zeros(nl,3);
for j =1 : nl
    lambda = lambdas(j)
    for k=1:nsims
        % Store each simulation's result in array
        simObj = do_nothing(simObj,lambda);
        cumret_array(k,1) = simObj.R_hist(end);
        simObj = example_strategy_2(simObj,lambda);
        cumret_array(k,2) = simObj.R_hist(end);
        simObj = test_strategy(simObj,lambda);
        cumret_array(k,3) = simObj.R_hist(end);
    end
    means(j,:) = mean(cumret_array,1);
    vars(j,:) = var(cumret_array,1);
    losses(j,:) = means(j,:) - 0.5 * lambda*vars(j,:);
end
for j = 1 : 3
    m = max(losses(j,:));
    plot(vars(:,j),means(:,j),'DisplayName',"strategy "+num2str(j)+", maxobj:"+num2str(m))
    hold on
end
legend
xlabel('Variance')
ylabel('Expected Value')
title("Compare Strategies")
saveas(gcf,"../figs/test1_0328.png")
clf();

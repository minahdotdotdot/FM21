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
%simObj = MarketSimulator(T,s0,model_params);

%simObj1 = do_nothing(simObj,lambda);
%lambda=1;
%[simObj2,efp,serr] = test_strategy(simObj,lambda);

%% Computing the Target Objective for a Strategy
nsims = 100;
%lambda = 0.25;

nl = 8;
% lambdas = linspace(1,nl/2,nl)/nl;
% means = zeros(nl,3);
% vars = zeros(nl,3);
% losses = zeros(nl,3);
nl = 300;
lambdas = linspace(0.2,10,nl);
cumret_array = zeros(nl,nsims,3);
parfor j =1 : nl
    lambda = lambdas(j);
    ca = zeros(nsims,3)
    for k=1:10%nsims
        simObj = MarketSimulator(T,s0,model_params);
        disp("lambda = "+lambda+", sim: "+k)
        % Store each simulation's result in array
        simObj = do_nothing(simObj,lambda);
        ca(k,1) = simObj.R_hist(end);
        simObj = MarketSimulator(T,s0,model_params);
        ca(k,2) = simObj.R_hist(end);
        [simObj,efp,serr] = test_strategy(simObj,lambda);
        ca(k,3) = simObj.R_hist(end);
    end
    cumret_array(j,:,:) = ca;
    means(j,:) = mean(ca,1);
    vars(j,:) = var(ca,1);
    losses(j,:) = means(j,:) - 0.5 * lambda*vars(j,:);
end
% means = squeeze(mean(cumret_array,2));
% vars = squeeze(var(cumret_array,2));
% losses = means - .5*lambdas.*vars;

for j = 1 : 3
    m = max(losses(j,:));
    scatter(vars(:,j),means(:,j),'filled','DisplayName',"strategy "+num2str(j)+", maxobj:"+num2str(m))
    hold on
end
legend
xlabel('Variance')
ylabel('Expected Value')
title("Compare Strategies")
saveas(gcf,"../figs/test2_0328.png")
clf();

save('../data/test2_0328.mat','cumret_arra y','means','vars','losses','lambdas')
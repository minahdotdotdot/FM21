% Example: Equal Weighted Portfolio Strategy

% Initialize Model Parameters
T = 500;
d = 30;
eta = 0.0002;
%eta =0.2;
%rng(12345);
rng(123);
%lambda=2;

Mrank = floor(0.25*d);
[U,S,V] = svd( randn(d,d) );
diagM = diag( [ normrnd(0,1,Mrank,1) ; zeros(d-Mrank,1) ] );
M = 5e-3 * U * diagM * V'; % Randomly generated matrix of rank Mrank

mu = 2e-5 * normrnd(0,1,d,1).^2;
c = 1e-8 * normrnd(0,1,d,1).^2;
%c = 1e-6 * normrnd(0,1,d,1).^2;
s0 = 100*ones(d,1);

% Initialize Simulation Environment
model_params = struct('mu',mu,'M',M,'c',c,'eta',eta);
%T=3;
simObj = MarketSimulator(T,s0,model_params);
%sim_obj=example_strategy_1(sim_obj)
%sim_obj=do_nothing(sim_obj);

lambda_trials=20;
lambda_max=5;
%lambda_step = lambda_max/lambda_trials;
lambdas = linspace(0.2,lambda_max,lambda_trials);
strategies=4;
mean_variance_matrix=zeros(lambda_trials,4,strategies);
%lambda=0.1; %starting value
lambda =1;

%%
for winners = 1:d

trials =200;
returns=zeros(trials,1);
for t=1:trials
    if rem(t,10)==0
        t
    end
    % Run strategy on environment
        simObj = pick_winners_each_t_0409(simObj,lambda,winners); % pick winners 
    
    
    returns(t)= simObj.R_hist(end);
end

mean_variance_matrix(winners,1)=mean(returns);
mean_variance_matrix(winners,2)=var(returns);
mean_variance_matrix(winners,3)=mean(returns)-0.5*lambda*var(returns);
mean_variance_matrix(winners,4)=winners;
end




%%
clf();
avg_happiness=mean(mean_variance_matrix(:,3,1));
scatter(mean_variance_matrix(:,4,1),mean_variance_matrix(:,1,1),'filled','k');

%%
means = mean_variance_matrix(:,1,1);
vars = mean_variance_matrix(:,2,1);
lambdas = linspace(0.2,10,100);
maxn = zeros(size(lambdas));
happinesses = zeros(size(lambdas));
for ll = 1 : length(lambdas)
    lambda=lambdas(ll)
    [val,ind]=max(means-lambda*vars);
    maxn(ll)= ind;
    happinesses(ll)=val;
end
yyaxis left
scatter(lambdas,maxn)
ylim([0,winners])
ylabel('maximizing number of winners')
yyaxis right
semilogy(lambdas,happinesses-1)

xlabel('lambdas')
ylabel('maximum happiness')
title(sprintf('%d sized portfolio',winners))
saveas(gcf,sprintf('lambda_relation_%03d.png',winners))
save(sprintf('lambda_maxn_%03d.mat',winners),'lambdas','winners','happinesses')    
    
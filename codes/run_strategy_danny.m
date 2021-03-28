% Example: Equal Weighted Portfolio Strategy

% Initialize Model Parameters
T = 250;
d = 50;
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

lambda_trials=300;
lambda_max=10;
%lambda_step = lambda_max/lambda_trials;
lambdas = linspace(0.2,lambda_max,lambda_trials);
mean_variance_matrix=zeros(lambda_trials,4,3);
%lambda=0.1; %starting value

for j=2:2
    
for i=1:lambda_trials
disp(i);
%lambda=lambda+lambda_step;
lambda = lambdas(i)
trials =500;
returns=zeros(trials,1);
for t=1:trials
    % Run strategy on environment
    if j==1
        simObj = pick_winners_each_t(simObj,lambda,lambda_max); % pick winners and weight by price
        w_hist_old= simObj.w_hist;
    end
    if j==2
        simObj = example_strategy_1(simObj,lambda); % equal weight strategy
        w_hist_old= simObj.w_hist;
    end
    if j==3
        simObj = do_nothing(simObj,lambda); % do nothing strategy
    end
    
    returns(t)= sum(simObj.R_hist(end));
end

mean_variance_matrix(i,1,j)=mean(returns);
mean_variance_matrix(i,2,j)=var(returns);
mean_variance_matrix(i,3,j)=mean(returns)-lambda*var(returns);
mean_variance_matrix(i,4,j)=lambda;
end
end

%%
clf();
avg_happiness1=mean(mean_variance_matrix(:,3,1));
scatter(mean_variance_matrix(:,2,1),mean_variance_matrix(:,1,1),'filled','k');
hold on
avg_happiness2=mean(mean_variance_matrix(:,3,2));
scatter(mean_variance_matrix(:,2,2),mean_variance_matrix(:,1,2),'filled','magenta');
hold on
avg_happiness3=mean(mean_variance_matrix(:,3,3));
scatter(mean_variance_matrix(:,2,3),mean_variance_matrix(:,1,3),'filled');
%set(gca,'xscale','log')
legend(["Pick winners (Avg happiness ="+num2str(avg_happiness1)+", eta="+num2str(eta)+")", ...
    "Price weighted (Avg happiness ="+num2str(avg_happiness2)+", eta="+ num2str(eta)+ ")",...
    "Do nothing (Avg happiness ="+num2str(avg_happiness3)+", eta="+ num2str(eta)+ ")"])
set(gcf,'Position',[100 100 500 500])
saveas(gcf,'4.png')


%%
clf();
avg_happiness=mean(mean_variance_matrix(:,3,1));
scatter(mean_variance_matrix(:,2,1),mean_variance_matrix(:,1,1),'filled','k');
%%
% Plot simulated price history
figure(1);
clf();
plot(1:(T+1),simObj.s_hist);
title('Stock Price Evolution')
%%
% Plot portfolio weights
figure(2);
clf();
plot(1:T,simObj.w_hist);
title('Portfolio Weight Evolution')


% Plot portfolio 1-period returns + mean
figure(3);
clf();
hold on;
plot(1:T,simObj.r_hist);
plot(1:T,ones(1,T) * mean(simObj.r_hist))
hold off;
title('Portfolio 1-Period-Return Evolution')

% Plot portfolio cumulative growth
figure(4);
clf();
plot(1:T,simObj.R_hist-1);
title('Portfolio Cumulative Growth')



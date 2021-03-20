%% In this file, we will generate data using the constant weight strategy.
% We chose this so that the portfolio has no impact on the market.
% We vary the amplitudes of mu c, and M, and the rank of M. 
addpath('/projects/luya7574/FM21/MathWorks')
T = 1000;
d = 100;
eta = 0.002;

M_amp=5e-3;
mu_amp=2-5;
c_amp=1e-8;

Mrank = floor(0.25*d);
[U,S,V] = svd( randn(d,d) );
diagM = diag( [ normrnd(0,1,Mrank,1) ; zeros(d-Mrank,1) ] );
M = M_amp* U * diagM * V'; % Randomly generated matrix of rank Mrank

mu = mu_amp * normrnd(0,1,d,1).^2;
c = c_amp * normrnd(0,1,d,1).^2;
s0 = 100*ones(d,1);

% Initialize Simulation Environment
model_params = struct('mu',mu,'M',M,'c',c,'eta',eta);
sim_obj = MarketSimulator(T,s0,model_params);

%% Visualization of a Single Simulation for a Strategy

% Run strategy on environment
sim_obj = example_strategy_1(sim_obj);
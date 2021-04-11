Mrank = floor(0.25*d);
[U,S,V] = svd( randn(d,d) );
diagM = diag( [ normrnd(0,1,Mrank,1) ; zeros(d-Mrank,1) ] );
M = 5e-3 * U * diagM * V'; % Randomly generated matrix of rank Mrank

mu = 2e-5 * normrnd(0,1,d,1).^2;
c = 1e-8 * normrnd(0,1,d,1).^2;
%c = 1e-6 * normrnd(0,1,d,1).^2;
s0 = 100*ones(d,1);
eta = 0.0002;

% Initialize Simulation Environment
model_params = struct('mu',mu,'M',M,'c',c,'eta',eta);
%T=3;
simObj = MarketSimulator(T,s0,model_params);
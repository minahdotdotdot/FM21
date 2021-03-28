clear all

%% In this file, we will generate data using the constant weight strategy.
% We chose this so that the portfolio has no impact on the market.
% We vary the amplitudes of mu c, and M, and the rank of M. 
addpath('/projects/luya7574/MathWorks')
addpath('/projects/luya7574/FM21/codes')
%% Model and Simulator Initialization 

% Initialize Model Parameters
T = 500;
d = 50;
eta = 0.0002;
trials = 1;
eta = 0.0002;

Mrank = floor(0.25*d);

s0 = 100*ones(d,1);
data = zeros(trials,d,T);
for t = 1 : trials
    [U,S,V] = svd( randn(d,d) );
    diagM = diag( [ normrnd(0,1,Mrank,1) ; zeros(d-Mrank,1) ] );
    M = 5e-3 * U * diagM * V'; % Randomly generated matrix of rank Mrank

    mu = 2e-5 * normrnd(0,1,d,1).^2;
    c = 1e-8 * normrnd(0,1,d,1).^2;
    % Initialize Simulation Environment
    model_params = struct('mu',mu,'M',M,'c',c,'eta',eta);
    sim_obj = MarketSimulator(T,s0,model_params);

    %% Visualization of a Single Simulation for a Strategy

    % Run strategy on environment
    sim_obj = do_nothing(sim_obj);
    data(t,:,:)=sim_obj.s_hist(:,1:end-1);
end

save('../data/DATA.mat','data')
numSteps = 4;
n.TRAIN = floor(0.75*T);
n.TEST = T-n.TRAIN;

%for t = 1 : trials
t=1;
X = zeros(d,n.TRAIN+n.TEST-numSteps-1,numSteps);
Y = zeros(d,n.TRAIN+n.TEST-numSteps-1);
for i = 1 : size(X,2)
    X(:,i,:) = data(t,:,i:i+numSteps-1);
    Y(:,i) = data(t,:,i+numSteps);
end
X = reshape(X, d*size(X,2),[]);
Y = reshape(Y, d*size(Y,2),[]);

Xt = X;
Yt = Y;

for t = 2 : trials
    X = zeros(d,n.TRAIN+n.TEST-numSteps-1,numSteps);
    Y = zeros(d,n.TRAIN+n.TEST-numSteps-1);
    for i = 1 : size(X,2)
        X(:,i,:) = data(t,:,i:i+numSteps-1);
        Y(:,i) = data(t,:,i+numSteps);
    end
    X = reshape(X, d*size(X,2),[]);
    Y = reshape(Y, d*size(Y,2),[]);
    Xt = cat(1,Xt,X);
    Yt = cat(1,Yt,Y);
end
clear data X Y
numSamples = size(Xt,1);
shuf = randperm(numSamples); Xt = Xt(shuf,:); Yt = Yt(shuf,:);
n.TRAIN = floor(0.75*numSamples);
n.TEST = T-n.TRAIN;
Xv = Xt(n.TRAIN+1:end,:); Yv = Yt(n.TRAIN+1:end);
Xt = Xt(1:n.TRAIN,:); Yt = Yt(1:n.TRAIN);
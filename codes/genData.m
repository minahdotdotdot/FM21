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



M_amp= [5e-5; 5e-4; 5e-3];
mu_amp = [2e-7; 2e-6; 2e-5; 2e-4];
M_ranks = [5;12;15;18;25];
%c_amp = [1e-10; 1e-9; 1e-8; 1e-7; 1e-6];
data = zeros(length(M_amp)*length(mu_amp)*length(c_amp),d,T);
counter = 0;
for ii = 1 : length(M_amp)
    for jj = 1 : length(mu_amp)
        for kk = 1 : length(M_ranks)
            counter = counter + 1
            s0 = 100*ones(d,1) + 5*randn(d,1);
            [U,S,V] = svd( randn(d,d) );
            diagM = diag( [ normrnd(0,1,M_ranks(kk),1) ; zeros(d-M_ranks(kk),1) ] );
            M = M_amp(ii) * U * diagM * V'; % Randomly generated matrix of rank Mrank

            mu = mu_amp(jj) * normrnd(0,1,d,1).^2;
            c = zeros(d,1).^2;%1e-8 * normrnd(0,1,d,1).^2;
            % Initialize Simulation Environment
            model_params = struct('mu',mu,'M',M,'c',c,'eta',eta);
            sim_obj = MarketSimulator(T,s0,model_params);

            %% Visualization of a Single Simulation for a Strategy

            % Run strategy on environment
            sim_obj = do_nothing(sim_obj);
            data(counter,:,:)=sim_obj.s_hist(:,2:end);
        end
    end
end

save('../data/DATA.mat','data')
% numSteps = 4;
% n.TRAIN = floor(0.75*T);
% n.TEST = T-n.TRAIN;

% %for t = 1 : trials
% t=1;
% Xtrn = zeros(d,n.TRAIN-numSteps-1,numSteps);
% Ytrn = zeros(d,n.TRAIN-numSteps-1);
% for i = 1 : size(Xtrn,2)
%     Xtrn(:,i,:) = data(t,:,i:i+numSteps-1);
%     Ytrn(:,i) = data(t,:,i+numSteps);
% end
% Xval = zeros(d,n.TEST-numSteps-1,numSteps);
% Yval = zeros(d,n.TEST-numSteps-1);
% for i = 1 : size(Xval,2)
%     Xval(:,i,:) = data(t,:,n.TRAIN+i:n.TRAIN+i+numSteps-1);
%     Yval(:,i) = data(t,:,n.TRAIN+i+numSteps);
% end
% Xtrn = reshape(Xtrn, d*size(Xtrn,2),[]);
% Xval = reshape(Xval, d*size(Xval,2),[]);
% Ytrn = reshape(Ytrn, d*size(Ytrn,2),[]);
% Yval = reshape(Yval, d*size(Yval,2),[]);

% Xt = Xtrn;
% Yt = Ytrn;
% Xv = Xval;
% Yv = Yval;

% for t = 2 : trials
%     Xtrn = zeros(d,n.TRAIN-numSteps-1,numSteps);
%     Ytrn = zeros(d,n.TRAIN-numSteps-1);
%     for i = 1 : size(Xtrn,2)
%         Xtrn(:,i,:) = data(t,:,i:i+numSteps-1);
%         Ytrn(:,i) = data(t,:,i+numSteps);
%     end
%     Xval = zeros(d,n.TEST-numSteps-1,numSteps);
%     Yval = zeros(d,n.TEST-numSteps-1);
%     for i = 1 : size(Xval,2)
%         Xval(:,i,:) = data(t,:,n.TRAIN+i:n.TRAIN+i+numSteps-1);
%         Yval(:,i) = data(t,:,n.TRAIN+i+numSteps);
%     end
%     Xtrn = reshape(Xtrn, d*size(Xtrn,2),[]);
%     Xval = reshape(Xval, d*size(Xval,2),[]);
%     Ytrn = reshape(Ytrn, d*size(Ytrn,2),[]);
%     Yval = reshape(Yval, d*size(Yval,2),[]);
%     Xt = cat(1,Xt,Xtrn);
%     Yt = cat(1,Yt,Ytrn);
%     Xv = cat(1,Xv,Xval);
%     Yv = cat(1,Yv,Yval);
% end
% clear data Xval Yval Xtrn Ytrn
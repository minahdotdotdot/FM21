%% Autocorrelation
addpath('/projects/luya7574/FM21/MathWorks')

M_amp=5e-3;
mu_amp=2e-5;
c_amp=1e-8;
T = 250;
d = 100;
eta = 0.002;

Mrank = floor(0.25*d);
[U,S,V] = svd( randn(d,d) );
diagM = diag( [ normrnd(0,1,Mrank,1) ; zeros(d-Mrank,1) ] );
M =M_amp * U * diagM * V'; % Randomly generated matrix of rank Mrank

mu = mu_amp * normrnd(0,1,d,1).^2;
c = c_amp * normrnd(0,1,d,1).^2;
s0 = 100*ones(d,1);

% Initialize Simulation Environment
model_params = struct('mu',mu,'M',M,'c',c,'eta',eta);
sim_obj = MarketSimulator(T,s0,model_params);
sim_obj = example_strategy_1(sim_obj); 
numLags=200
acfs = zeros(numLags+1,d);
boundss = zeros(2,d)
for j = 1 : size(sim_obj.s_hist,1)
    [acf,lags,bounds,h] = autocorr(sim_obj.s_hist(j,:),'NumLags',numLags);
    hold on
    acfs(:,j)= acf(:);
    boundss(:,j)=bounds(:);
end
clf();
mbounds = mean(boundss,2);
macfs=mean(acfs,2);
sacfs = sqrt(mean((acfs-macfs).^2,2))
x = 1:numLags+1;
yline(mbounds(1),'r'); hold onxacfs
yline(mbounds(2),'r'); hold on
% x2 = [x, fliplr(x)];
% inBetween = [macfs-sacfs fliplr(macfs+sacfs)];
% fill(x2(:), inBetween(:), 'g');
plot(x,macfs);hold on
plot(x,macfs-sacfs);hold on
plot(x,macfs+sacfs);hold on
saveas(gcf,'../figs/acf.png')
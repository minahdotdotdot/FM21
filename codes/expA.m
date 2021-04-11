%% Experiment A
% We will try equal weights for the top n (by price) stocks.
addpath('../../MathWorks');

d = 50; 
T = 500;
rng(123);

%% Initialize Simobj.
initialize_sim

%% Run experiment
ns = linspace(1,50,50); % n is winners.
trials = 10; %number of trials

results = zeros(length(ns), trials);
for ii = 1 : length(ns)
    n = round(ns(ii));
    for t = 1 : trials
        [n,t]
        simObj = equal_topn(simObj,n);
        results(ii,t) = simObj.R_hist(end);
    end
end

means = mean(results,2);
vars = var(results,0,2);
binsize = 10;
sorted_mv = sortrows([means vars]);
ef_length = 10;%ceil(length(ns)/binsize);
windowsize = 3;
EF = zeros(size(results,1)-windowsize,2);%zeros(ef_length,2);
meanrange = max(means)-min(means);

for b = 1 : size(results,1)-windowsize
    [val,ind] = min(sorted_mv(b:b+windowsize,2));
    EF(b,:) = sorted_mv(b-1+ind,:)

    % if b < ef_length
    %     [val,ind] = min(sorted_mv((b-1)*binsize+1:b*binsize,2));
    %     EF(b,:) = sorted_mv((b-1)*binsize+ind,:);
    % else b == ef_length
    %     [val,ind] = min(sorted_mv((b-1)*binsize+1:end,2));
    %     EF(b,:) = sorted_mv((b-1)*binsize+ind,:);
    % end
end


clf();
figure(1);
subplot(131)
scatter(ns,means,'filled','k'); hold on;
plot(ns, means-1.96*vars/sqrt(trials)); hold on;
plot(ns, means+1.96*vars/sqrt(trials)); 
xlabel('Number of winners')
ylabel('Sample Mean with 95% C.I.')
title(sprintf('%d trials of equal weights for n winners',trials))

subplot(132)
plot(ns,vars/sqrt(trials));
xlabel('Number of winners')
ylabel('Standard Error')

subplot(133)
scatter(vars.^2, means, 'filled','r');
set(gca,'xscale','log')
xlabel('Vars')
ylabel('Means')
title('Efficient Frontier')
set(gcf, 'Position',  [100, 100, 1000, 400])
saveas(gcf,sprintf('../figs/expA_%03d.png',trials))




n = 10;
simObj = equal_topn(simObj,n);
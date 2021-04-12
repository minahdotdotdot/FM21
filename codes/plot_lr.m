addpath('../../MathWorks');
k = 3;
ds = (5:5:100);
EFmeans = zeros(length(ds),1);
EFvars = zeros(length(ds),1)
for jj = 1 : 17
    winners = ds(jj);
    load(sprintf('../data/%03d-portfolio.mat',winners),'means','vars','maxn','happinesses');
    lambdas = linspace(0.2,30,5000);
    maxn = zeros(size(lambdas,2),k);
    happinesses = zeros(size(lambdas,2),k);
    for ll = 1 : length(lambdas)
        lambda=lambdas(ll)
        [val,ind]=maxk(means-lambda*vars,k);
        maxn(ll,:)= ind(:);
        happinesses(ll,:)=val(:);
    end
    subplot(1,3,1:2)
    yyaxis left
    avg = 1./mean(1./maxn,2);
    scatter(lambdas,maxn(:,1),'k','MarkerFaceAlpha',.1);hold on;
    scatter(lambdas,maxn(:,2),'green','MarkerFaceAlpha',.1);hold on;
    scatter(lambdas,maxn(:,3),'b','MarkerFaceAlpha',.1);hold on;
    plot(lambdas,avg,'r-','LineWidth',4); hold on
    %plot(lambdas,mean(maxn,2),'LineWidth',8); hold on
    legend(["1","2","3","harmonic mean"],'Location','eastoutside')
    ylim([0,winners])
    ylabel('maximizing number of winners')
    yyaxis right
    plot(lambdas,happinesses-1)
    ylim([-0.001,0.05])
    xlabel('lambdas')
    ylabel('maximum happiness')
    title(sprintf('%d sized portfolio',winners))
    %title(sprintf('%d sized portfolio, min happiness=%.4f',winners,min(happinesses-1)))

    subplot(1,3,3)
    scatter(vars, means, 'filled','r');
    set(gca,'xscale','log')
    xlabel('Vars')
    ylabel('Means')
    EFmeans(jj)=mean(means);
    EFvars(jj)=mean(vars);
    title(sprintf('Efficient Frontier: [mean,var]=[%.3f,%1.1e]',EFmeans(jj),EFvars(jj)))


    set(gcf, 'Position',  [100, 100, 800, 300])
    saveas(gcf,sprintf('../figs/lr000_%03d.png',winners)) 
    clf;
end
save('../data/000-EFstats.mat','EFmeans','EFvars')
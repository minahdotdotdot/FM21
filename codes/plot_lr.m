addpath('../../MathWorks');
k = 3;
ds = (5:5:100);
EFmeans = zeros(length(ds),1);
EFvars = zeros(length(ds),1)
for jj = 1 : 20
    winners = ds(jj);
    load(sprintf('../data/%03d-portfolio-010.mat',winners),'means','vars','maxn','happinesses');
    lambdas = linspace(0.05,50,5000);
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
    saveas(gcf,sprintf('../figs/lr010_%03d.png',winners)) 
    clf;
end
save('../data/010-EFstats.mat','EFmeans','EFvars')

%%
clf;
load('../data/000-EFstats.mat')
EFmeans000=EFmeans; EFvars000=EFvars;
load('../data/010-EFstats.mat')
EFmeans010=EFmeans; EFvars010=EFvars;
load('../data/100-EFstats.mat')
EFmeans100=EFmeans; EFvars100=EFvars;
dd=20;
subplot(121)
plot(ds(1:dd),EFmeans000(1:dd));hold on
plot(ds(1:dd),EFmeans100(1:dd));hold on
plot(ds(1:dd),EFmeans010(1:dd));hold on
xlabel("Size of portfolio")
ylabel("Average mean return")
legend(["000","100","010"])
title("Average mean return over size of portfolio")
ax=subplot(122)
plot(ds(1:dd),EFvars000(1:dd));hold on
plot(ds(1:dd),EFvars100(1:dd));hold on
plot(ds(1:dd),EFvars010(1:dd));hold on
xlabel("Size of portfolio")
ylabel("Average var return")
legend(["000","100","010"])
th=title({"Average var return over size of portfolio" ""})
set(gcf, 'Position',  [100, 100, 800, 400])
saveas(gcf,"../figs/000-100-010.png")


load('../data/cool_strategy.mat')
scatter(vars, means, 'filled','r');
%set(gca,'xscale','log')
xlabel('Vars')
ylabel('Means')
EFmeans=mean(means);
EFvars=mean(vars);
title(sprintf('cool strategy: Efficient Frontier: [mean,var]=[%.3f,%1.1e]',EFmeans,EFvars))
saveas(gcf,'../figs/coolEF.png')

d=50;
nL=1000;
lambdas = linspace(0.01,50,nL);
alphas = zeros(size(lambdas));
ns = zeros(size(lambdas));
for jj = 1 : length(lambdas)
    [a,n]=mapl2a(lambdas(jj),d);
    alphas(jj)=a;
    ns(jj)=n;
end
clf;
yyaxis left;
plot(lambdas,alphas);
ylabel('Alpha values');
yyaxis right;
plot(lambdas,ns)
ylabel('Number of winners')
xlabel('Lambdas')
title('Mapping lambda to winners')
saveas(gcf,'../figs/l2w.png')

clf;
yyaxis left;
scatter(lambdas,means);
ylabel('Means');
yyaxis right;
scatter(lambdas,vars)
set(gca,'yscale','log')
ylabel('Variances')
xlabel('Lambdas')
title('lambda vs Mean-Variance')
saveas(gcf,'../figs/l2mv_scatter.png')
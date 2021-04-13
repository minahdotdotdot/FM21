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
title(sprintf('cool strategy k=.25: Efficient Frontier: [mean,var]=[%.3f,%1.1e]',EFmeans,EFvars))
saveas(gcf,'../figs/cool_k25_EF.png')

d=50;
nL=1000;
k=0.25;
lambdas = linspace(0.01,50,nL);
lambdas = lambdas(:);
alphas = zeros(size(lambdas));
ns = zeros(size(lambdas));
for jj = 1 : length(lambdas)
    [a,n]=mapl2a(lambdas(jj),d,k);
    alphas(jj)=a;
    ns(jj)=n;
end
clf;
yyaxis left;
plot(lambdas,alphas);hold on;
ylabel('Alpha values');
yyaxis right;
plot(lambdas,ns)
ylabel('Number of winners')
xlabel('Lambdas')
title('Mapping lambda to winners')
saveas(gcf,'../figs/l2w_k25.png')

clf;
yyaxis left;
scatter(lambdas,means);hold on;
plot(lambdas,means-(lambdas.*vars),'k','LineWidth',1)
ylabel('Means');
yyaxis right;
scatter(lambdas,vars)
%set(gca,'yscale','log')
ylabel('Variances')
xlabel('Lambdas')
title('lambda vs Mean-Variance')
saveas(gcf,'../figs/l2mv_scatter_h.png')




clf;
load('../data/cool_strategy.mat')
means_k50l25 = means; vars_k50l25 = vars;
load('../data/cool_strategy_k25.mat')
means_k25l25 = means; vars_k25l25 = vars;
load('../data/cool_strategy_k50l10.mat')
means_k50l10 = means; vars_k50l10=vars;
load('../data/cool_strategy_k25l10.mat')
means_k25l10 = means; vars_k25l10=vars;
load('../data/equal_weights.mat')
means_baseline = mean(means)*ones(size(means_k25l10)); 
vars_baseline=mean(vars)*ones(size(means_k25l10));


d=50;
nL=1000;
lambdas = linspace(0.01,50,nL); lambdas=lambdas(:);
scatter(1*lambdas,means_baseline-(1*lambdas.*vars_baseline),'filled');hold on;
%scatter(.1*lambdas,means_baseline-(.1*lambdas.*vars_baseline),'filled');hold on;
scatter(1*lambdas,means_k50l25-(1*lambdas.*vars_k50l25));hold on;
scatter(1*lambdas,means_k25l25-(1*lambdas.*vars_k25l25));hold on;
scatter(1*lambdas,means_k50l10-(1*lambdas.*vars_k50l10));hold on;
scatter(1*lambdas,means_k25l10-(1*lambdas.*vars_k25l10));hold on;
xlabel('Lambdas')
ylabel('Objective Function')
legend(["equal weights", "k=0.50, l0=25","k=0.25, l0=25","k=0.50, l0=10","k=0.25,, l0=10"])
saveas(gcf,'../figs/compare_ks_h_l1.png'); clf;

lst=201;
lf=1000;
scatter(vars_k25l25(lst:lf), means_k25l25(lst:lf), 250, 'filled','MarkerFaceAlpha',1); hold on;
scatter(vars_k25l10(lst:lf), means_k25l10(lst:lf), 150, 'filled','MarkerFaceAlpha',1); hold on;
scatter(vars_k50l25(lst:lf), means_k50l25(lst:lf), 70, 'filled','MarkerFaceAlpha',1); hold on;
scatter(vars_k50l10(lst:lf), means_k50l10(lst:lf), 25, 'k', 'filled','MarkerFaceAlpha',1); hold on;
%set(gca,'xscale','log')
xlabel('Vars')
ylabel('Means')
legend(["k=.25, \lambda_0=25","k=.25, \lambda_0=10","k=.50, \lambda_0=25","k=.50, \lambda_0=10"])
title(sprintf("Compare Efficient Frontiers, k=0.50 lambda in (%.4f,%.4f)",lambdas(lst),lambdas(lf)))
saveas(gcf,sprintf("../figs/EF_%.4f_%.4f.png",lambdas(lst),lambdas(lf)));clf
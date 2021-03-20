function plot_run(sim_obj, T, filepath)
    % Plot simulated price history
    subplot(221);
    plot(1:(T+1),sim_obj.s_hist);
    title('Stock Price Evolution')

    % Plot portfolio weights
    subplot(222);
    plot(1:T,sim_obj.w_hist);
    title('Weight Evolution')

    % Plot portfolio 1-period returns + mean
    subplot(223);
    hold on;
    plot(1:T,sim_obj.r_hist);
    plot(1:T,ones(1,T) * mean(sim_obj.r_hist))
    hold off;
    title('1-Period-Return Evolution')

    % Plot portfolio cumulative growth
    subplot(224);
    plot(1:T,sim_obj.R_hist-1);
    title('Cumulative Growth')
    saveas(gcf,filepath)
    clf();
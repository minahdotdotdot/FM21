function w=get_strategy_weights(lambda,i,sim_obj)
    tt = i; %The current time-step.
    % First, predict the stock prices at time tt+1;
    %snew = model(sim_obj,i);

    %% Now, use snew to solve the optimization problem.
    r = (news- sim_obj.s_hist(:,tt))./sim_obj.s_hist(:,tt); % return given news.
    wprev = sim_obj.w_hist(:,tt-1);                         % weights at previous period.
    sprev, s = sim_obj.s_hist(:,tt-1:tt);                   % stock prices at previous/current period.
    Pprev, P = sim_obj.P_hist(tt-1:tt);                     % portfolio value at previous/current period.

    % Scale eta for this problem given lambda.
    eta = sim_obj.eta; % no scaling done.

    % Set up an optimization problem w.r.t. w.
    prob = optimproblem();
    w = optimvar('w',d,1,'Lowerbound',0,'UpperBound',1); % Variable being optimized and constraints.
    fun = @(w,r,s,P,wprev,sprev,Pprev)-dot(w,r) + eta*sum(abs((P*w./s)-(Pprev*wprev./sprev)));
    prob.Objective = fcn2optimexpr(fun,w,r,s,P,wprev,sprev,Pprev);
    prob.Constraints.cons1 = sum(w) == 1;

    % Initialize a guess and solve.
    init.w = wprev;
    [sol,fvalproblem,exitflagproblem,outputproblem] = solve(prob,init);
    w = sol.w;
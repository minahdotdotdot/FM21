function [w,exitflagproblem,snew]=get_strategy_weights(lambda,i,simObj)
    %Do nothing until time-step 41.
    numSteps = 40;
    d=size(simObj.s_hist,1);
    load('../data/model_40_2.mat')
    exitflagproblem=0;
    prob = optimproblem();
    u = optimvar('u',d,1,'Lowerbound',0);
    fun = @(u,s,r,uprev,eta)-dot(u.*s,r)/(dot(u,s)-eta*sum(abs(u-uprev))) + eta*sum(abs(u-uprev));
    opts=optimoptions('fmincon', 'MaxFunctionEvaluations',10000);
    spred=0;
    snew = 0;
    if i < numSteps
        % do nothing.
        if i == 1
            w= ones(simObj.d,1)/simObj.d;
        else
            u_prev = simObj.w_hist(:,i-1).*simObj.P_hist(i-1)./simObj.s_hist(:,i-1);
            w = simObj.w_hist(:,i-1).*(simObj.P_hist(i-1)*simObj.s_cur./(sum((u_prev.*simObj.s_cur))*simObj.s_hist(:,i-1)));
            w = w./sum(w);
        end
    else
        % First, predict the stock prices at time i+1;
        %snew = model(simObj,i);
        %snew = simObj.s_hist(:,i+1);
        s_r = reshape(simObj.s_hist(:,i-numSteps+1:i)',numSteps,1,1,[]);
        snew = double(predict(net,s_r-100))+100;
        %% Now, use snew to solve the optimization problem.
        r = (snew- simObj.s_hist(:,i))./simObj.s_hist(:,i); % return given snew.
        wprev = simObj.w_hist(:,i-1);                         % weights at previous period.
        s = simObj.s_hist(:,i-1:i);                          % stock prices at previous/current period.
        sprev = s(:,1); s= s(:,2);
        Pprev = simObj.P_hist(i-1);                            % portfolio value at previous/current period.
        % Scale eta for this problem given lambda.
        eta = simObj.eta; % no scaling done.

        % Set up an optimization problem w.r.t. u.
        uprev = simObj.w_hist(:,i-1).*simObj.P_hist(i-1)./simObj.s_hist(:,i-1);
        %% Initialize a guess and solve.
        prob.Objective = fcn2optimexpr(fun,u,s,r,uprev,eta);
        init.u = uprev;
        [solu,fvalproblem,exitflagproblem,outputproblem] = solve(prob,init,'options',opts);
        if exitflagproblem == 0
            u_prev = simObj.w_hist(:,i-1).*simObj.P_hist(i-1)./simObj.s_hist(:,i-1);
            w = simObj.w_hist(:,i-1).*(simObj.P_hist(i-1)*simObj.s_cur./(sum((u_prev.*simObj.s_cur))*simObj.s_hist(:,i-1)));
            w = w./sum(w);
        else
            P = dot(solu.u,s)-eta*sum(abs(solu.u-uprev));
            w = solu.u.*s/P;
            w = w/sum(w);
        end
    end
end

%[x,fval,exitflag,output,lambda,grad,hessian] = fmincon(___)
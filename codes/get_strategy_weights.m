function [w,exitflagproblem,snew]=get_strategy_weights(lambda,i,simObj)
%function [w,snew] = get_strategy_weights(lambda,i,simObj)
    load('../data/final_net.mat')
    numSteps = window_size; clear window_size;
    %Use the do nothing strategy until time-step window_size+1.
    %But use
    %numSteps = 40;
    d=size(simObj.s_hist,1);
    %load('../data/model_40_2.mat')
   
    exitflagproblem=0;
    %s=zeros(d,1);r=zeros(d,1);uprev=zeros(d,1);eta=simObj.eta;
    % fun = @(u,s,r,uprev,eta)-dot(u.*s,r)/(dot(u,s)-eta*sum(abs(u-uprev))) + eta*sum(abs(u-uprev));
    % prob.Objective = fcn2optimexpr(fun,u,s,r,uprev,eta);
    % opts=optimoptions('fmincon', 'MaxFunctionEvaluations',10000,'Display','off');
    spred=0; snew = 0; s_r = 0;
    % Scale eta for this problem given lambda.
    if lambda <0.2
        lamda = 0.2
    end
    lambda=0.2;eta = simObj.eta*10^(log(2000)/(log(10)*log(50))*log(lambda/0.2));
    %simObj.eta*(10+lambda-0.2); % no scaling done.
    if i < floor(numSteps/2)
        % do nothing.
        if i == 1
            w= ones(simObj.d,1)/simObj.d;
        else
            u_prev = simObj.w_hist(:,i-1).*simObj.P_hist(i-1)./simObj.s_hist(:,i-1);
            w = simObj.w_hist(:,i-1).*(simObj.P_hist(i-1)*simObj.s_cur./(sum((u_prev.*simObj.s_cur))*simObj.s_hist(:,i-1)));
            w = w./sum(w);
        end
    elseif rem(i,10)==0
        % First, predict the stock prices at time i+1;
        %snew = model(simObj,i);
        %snew = simObj.s_hist(:,i+1);
        %s_r = reshape(simObj.s_hist(:,i-numSteps+1:i)',numSteps,1,1,[]);
        if i < numSteps
            s_r = simObj.s_hist(:,1:i);
        else
            s_r = simObj.s_hist(:,i-numSteps+1:i);
        end
        m_s_r = mean(s_r,2);
        scell = mat2cell(s_r-m_s_r,ones(d,1));
        snew = double(predict(net,scell)) + m_s_r;
        %snew = double(predict(net,s_r-100))+100;
        
        %% Now, use snew to solve the optimization problem.
        r = (snew- simObj.s_hist(:,i))./simObj.s_hist(:,i); % return given snew.
        wprev = simObj.w_hist(:,i-1);                         % weights at previous period.
        s = simObj.s_hist(:,i-1:i);                          % stock prices at previous/current period.
        sprev = s(:,1); s= s(:,2);
        Pprev = simObj.P_hist(i-1);                            % portfolio value at previous/current period.

        % Set up an optimization problem w.r.t. u.
        uprev = simObj.w_hist(:,i-1).*simObj.P_hist(i-1)./simObj.s_hist(:,i-1);
        prob = optimproblem();
        u = optimvar('u',d,1,'Lowerbound',0);
        fun = @(u,s,r,uprev,eta)-dot(u.*s,r)/(dot(u,s)-eta*sum(abs(u-uprev))) + eta*sum(abs(u-uprev));
        prob.Objective = fcn2optimexpr(fun,u,s,r,uprev,eta);
        opts=optimoptions('fmincon', 'MaxFunctionEvaluations',10000,'Display','off');
        %% Initialize a guess and solve.
        prob.Objective = fcn2optimexpr(fun,u,s,r,uprev,eta);
        init.u = uprev;
        %[solu,fvalproblem,exitflagproblem,outputproblem] = solve(prob,init,'options',opts);
        [solu,~,exitflagproblem,~] = solve(prob,init,'options',opts);
        if exitflagproblem == 0
            u_prev = simObj.w_hist(:,i-1).*simObj.P_hist(i-1)./simObj.s_hist(:,i-1);
            w = simObj.w_hist(:,i-1).*(simObj.P_hist(i-1)*simObj.s_cur./(sum((u_prev.*simObj.s_cur))*simObj.s_hist(:,i-1)));
            w = w./sum(w);
        else
            P = dot(solu.u,s)-eta*sum(abs(solu.u-uprev));
            w = solu.u.*s/P;
            w = w/sum(w);
        end
    else
        u_prev = simObj.w_hist(:,i-1).*simObj.P_hist(i-1)./simObj.s_hist(:,i-1);
        w = simObj.w_hist(:,i-1).*(simObj.P_hist(i-1)*simObj.s_cur./(sum((u_prev.*simObj.s_cur))*simObj.s_hist(:,i-1)));
        w = w./sum(w);
    end
end

%[x,fval,exitflag,output,lambda,grad,hessian] = fmincon(___)
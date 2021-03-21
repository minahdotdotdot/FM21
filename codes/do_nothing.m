function simObj = do_nothing(simObj,lambda)
    % Strategy that doesn't do any trades 
    if nargin<2
        lambda = 0.5;
    end
    simObj.reset(); % reset simulation environment
    
    for i=1:simObj.T
        if i==1
            w_const = ones(simObj.d,1)/simObj.d;
            simObj.step(w_const);
        end
        if i>1
            % calculate last period number of shares u_prev, and set w such
            % that u_delta =0
            u_prev = simObj.w_hist(:,i-1).*simObj.P_hist(i-1)./simObj.s_hist(:,i-1);
            w_const = simObj.w_hist(:,i-1).*(simObj.P_hist(i-1)*simObj.s_cur./(sum((u_prev.*simObj.s_cur))*simObj.s_hist(:,i-1)));
            w_const = w_const./sum(w_const); % weights that keep u unchanged
            simObj.step(w_const);
        end
    end
end
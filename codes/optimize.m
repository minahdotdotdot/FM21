addpath('/projects/luya7574/MathWorks')
%% Fixed parameters
eta = .001;
d = 20;
Mrank = floor(0.25*d);
[U,S,V] = svd( randn(d,d) );
diagM = diag( [ normrnd(0,1,Mrank,1) ; zeros(d-Mrank,1) ] );
M = 5e-3 * U * diagM * V'; % Randomly generated matrix of rank Mrank
mu = 2e-5 * normrnd(0,1,d,1).^2;
c = 1e-8 * normrnd(0,1,d,1).^2;
s0 = 100*ones(d,1);
T = 250;
d = 20;


%% Generate data
model_params = struct('mu',mu,'M',M,'c',c,'eta',eta);
sim_obj = MarketSimulator(T,s0,model_params);
sim_obj = example_strategy_1(sim_obj); 

%% Choose a data point.
tt = 10
r = (sim_obj.s_hist(:,tt+1) -news- sim_obj.s_hist(:,tt))./sim_obj.s_hist(:,tt); % return given news.
wprev = sim_obj.w_hist(:,tt-1);                                                 % weights at previous period.
sprev, s = sim_obj.s_hist(:,tt-1:tt);                                           % stock prices at previous/current period.
Pprev, P = sim_obj.P_hist(tt-1:tt);                                             % portfolio value at previous/current period.

%% Set up problem w.r.t. w(tt)
prob = optimproblem();
w = optimvar('w',d,1,'Lowerbound',0,'UpperBound',1);
%fun = @(w,r,wprev)-dot(w,r) + eta*sum(abs(w-wprev));
fun = @(w,r,s,P,wprev,sprev,Pprev)-dot(w,r) + eta*sum(abs((P*w./s)-(Pprev*wprev./sprev)));
%prob.Objective = fcn2optimexpr(fun,w,r,wprev);
prob.Objective = fcn2optimexpr(fun,w,r,s,P,wprev,sprev,Pprev)
prob.Constraints.cons1 = sum(w) == 1;

%% Initialize a guess and solve.
init.w = wprev;
[sol,fvalproblem,exitflagproblem,outputproblem] = solve(prob,init)
[sol.w,sol.w-wprev,r]
%eta
sum(abs((P*sol.w./s)-(Pprev*wprev./sprev)))
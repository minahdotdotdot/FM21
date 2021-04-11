 function [simObj,efps,serr] = test_strategy(simObj, lambda)
  d=size(simObj.s_hist,1);
  serr = zeros(d,simObj.T);
  if nargin<2
    lambda = 0.5;
  end
  simObj.reset(); % reset simulation environment
  efps = zeros(simObj.T,1);
  for i=1:simObj.T
    %i
    [w,efp,snew] = get_strategy_weights(lambda,i,simObj); % your strategy should return the weights
    efps(i) = efp;
    %[w,snew]=get_strategy_weights(lambda,i,simObj);
    simObj.step(w);
    %norm(simObj.s_cur-snew)/norm(simObj.s_cur)
    if i > 20
       serr(:,i)=snew;
    end
end
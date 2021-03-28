 function [simObj,efps,serr] = test_strategy(simObj, lambda)
  serr = zeros(simObj.T,1);
  if nargin<2
    lambda = 0.5;
  end
  simObj.reset(); % reset simulation environment
  efps = zeros(simObj.T,1);
  for i=1:simObj.T
    %i
    [w,efp,snew] = get_strategy_weights(lambda,i,simObj); % your strategy should return the weights
    efps(i) = efp;
    simObj.step(w);
    if i > 40
      serr(i)=norm(simObj.s_cur-snew)/norm(simObj.s_cur);
    end
end
 function [simObj,efps] = test_strategy(simObj, lambda)

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
      (simObj.s_cur-snew)./simObj.s_cur
    end
end
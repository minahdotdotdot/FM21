function [loss,Grad] = modelGradients(net, x, y)
    ypred = forward(net, x);
    %loss = mean(abs((y-ypred) ./y));
    %loss = crossentropy(ypred, y);
    %loss = mse(y,ypred);
    loss = mean(-(y.*log(ypred)+(1-y).*log(1-ypred)));
    Grad = dlgradient(loss, net.Learnables);
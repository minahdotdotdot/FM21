cd('/projects/luya7574/FM21/codes')
%load('../data/DATA.mat');
%load('../data/lognet_40_031.mat');

genData2
%Xt = log(Xt); Yt = log(Yt); Xv = log(Xv); Yv=log(Yv);
Yt = sign(Yt - squeeze(Xt(:,end)));
Z = zeros(size(Yt,1),1); Z(find(Yt==1))=1; Yt = Z; %Z(find(Yt==-1),1)=1; 
Yv = sign(Yv - squeeze(Xv(:,end)));
Z = zeros(size(Yv,1),1); Z(find(Yv==1))=1; Yv = Z; %Z(find(Yt==-1),1)=1; 
%meanX = mean(Xt(:)); stdX = std(Xt(:));
%meanY = mean(Yt(:)); %stdY = std(Yt(:));
%Xt = (Xt-meanX)/stdX;
%Yt = (Yt-meanY)/stdY;
%Xv = (Xv-meanX)/stdX;
%Yv = (Yv-meanY)/stdY;

% %% Shuffle data.
% tshuf = randperm(size(Xt,1)); Xt = Xt(tshuf,:); Yt = Yt(tshuf,:);
% vshuf = randperm(size(Xv,1)); Xv = Xv(vshuf,:); Yv = Yv(vshuf,:);
%save('../data/pm1_DATA.mat','Xt','Yt','Xv','Yv','meanX','stdX')
%load('../data/pm1_DATA.mat');
Xt = Xt';Xv = Xv';
[numSteps,numTrainImages]=size(Xt);
Xt = dlarray(reshape(Xt,[numSteps 1 1 size(Xt,2)]),'SSCB');
Xv = dlarray(reshape(Xv,[numSteps 1 1 size(Xv,2)]),'SSCB');
Yt = dlarray(Yt','CB');
Yv = dlarray(Yv','CB');

%% Load net

%net1
net2
net = modelNet;

executionEnvironment = "auto";
loc = '../data/';
numEpochs = 50;
miniBatchSize = 3500; % maxes out around 10GB
lr = .0001;
numIterations = floor(numTrainImages/miniBatchSize);
iteration = 0;

avgGradients = [];
avgGradientsSquared = [];
oldloss = 100;
improve_iter = 1;
epoch = 1;
while epoch <=numEpochs
    tic;
    loss = 0;
    for i = 1:numIterations
        
        iteration = iteration + 1;
        idx = (i-1)*miniBatchSize+1:i*miniBatchSize;
        XBatch = Xt(:,:,:,idx);
        YBatch = Yt(:,idx);
        XBatch = dlarray(single(XBatch), 'SSCB');
        YBatch = dlarray(single(YBatch), 'CB');


        if (executionEnvironment == "auto" && canUseGPU) || executionEnvironment == "gpu"
            XBatch = gpuArray(XBatch);
        end

        [batch_loss,Grad] = dlfeval(@modelGradients, net, XBatch, YBatch);
        [net.Learnables, avgGradients, avgGradientsSquared] = ...
            adamupdate(net.Learnables, ...
                Grad, avgGradients, avgGradientsSquared, iteration, lr);
        loss = loss + extractdata(batch_loss);
    end
    loss = loss/numIterations;
    elapsedTime = toc;
    %mapet =mean(abs((forward(net,Xt)-Yt)./Yt));
    YPred = forward(net,Xv);
    vloss = mean(-(Yv.*log(YPred)+(1-Yv).*log(1-YPred)));
    %exp(sqrt(mean((YPred-Yv).^2)))-1;
    %mapev = mean(abs((YPred - Yv)./Yv));
    %disp("Epoch : "+epoch+" trn/val loss = "+gather(extractdata(mapet))+"/"+gather(extractdata(mapev))+". Time taken for epoch = "+ elapsedTime + "s")
    disp("Epoch : "+epoch+" trn/val loss = "+loss+"/"+gather(extractdata(vloss))+". Time taken for epoch = "+ elapsedTime + "s")
    if oldloss > vloss
        save(loc+sprintf("lognet_40_%03d.mat",epoch),'net');
        %save(loc+"lognet_40_"+num2str(epoch)+".mat","net")
        oldloss = vloss;
        improve_iter = epoch;
    end
    % if epoch-improve_iter>20
    %     epoch = numEpochs+1;
    % end
    epoch = epoch + 1;
end
YPred = forward(net,Xv);
YPred(:,1:10)
Yv(:,1:10)
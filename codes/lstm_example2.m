clear all

numFeatures = 1;
numResponses = 1;
numHiddenUnits = 32;

layers = [ ...
    sequenceInputLayer(numFeatures)
    %lstmLayer(numHiddenUnits, 'OutputMode','sequence')
    lstmLayer(numHiddenUnits,'OutputMode','last')
    fullyConnectedLayer(numResponses)
    regressionLayer];

n.TRAIN = 100;
n.TEST = 5;

% create fake data
window_size = 40;
Xtrn = cell(n.TRAIN, 1);
Ytrn = zeros(n.TRAIN,numResponses);
%Ytrn = cell(n.TRAIN,numResponses);
for i = 1 : n.TRAIN
    Xtrn{i} = randn(1,window_size);
    Ytrn(i,:) = [mean(Xtrn{i})];%; std(Xtrn{i})];
    %Ytrn{i} = [mean(Xtrn{i}); std(Xtrn{i})];%sum(Xtrn{i});%
end
Xval = cell(n.TEST, 1);
%Yval = cell(n.TEST,numResponses);
Yval = zeros(n.TEST,numResponses);
for i = 1 : n.TEST
    Xval{i} = randn(1,window_size);
    Yval(i,:) = [mean(Xval{i})];%; std(Xval{i})];
    %Yval{i} = [mean(Xval{i}); std(Xval{i})];%sum(Xval{i});%
end
options = trainingOptions('adam', ...
    'MaxEpochs',100, ...
    'GradientThreshold',1, ...
    'InitialLearnRate',0.005, ...
    'LearnRateSchedule','piecewise', ...
    'LearnRateDropPeriod',125, ...
    'LearnRateDropFactor',0.2, ...
    'Verbose',1);

%% Train.
net = trainNetwork(Xtrn,Ytrn,layers,options);

valPred = predict(net,Xval)


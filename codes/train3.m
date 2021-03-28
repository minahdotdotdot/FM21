clear all
%% Load data.
load('../data/DATA.mat')
data=reshape(data,size(data,1)*size(data,2),[]);
%data_mean = mean(data(:)); data_std = std(data(:)); 
%data = (data-data_mean)/data_std;

window_size = 40;
numResponses =1;
total_samples = size(data,1)*(size(data,2)-window_size-1);

count = 0;
data_c = zeros(total_samples, window_size+1);
for ii = 1 : size(data,1)
    for jj = 1 : size(data,2)-window_size-1
        count = count + 1;
        data_c(count,:) = data(ii,jj:jj+window_size);
    end
end
clear data

%% Shuffle and split 
%rng(1205)
randinds = randperm(total_samples);
data_c = data_c(randinds,:);
clear randinds
split_factor =0.8;
n.TRAIN = floor(split_factor*total_samples);
n.TEST = total_samples-n.TRAIN;

Xtrn = cell(n.TRAIN, 1);
Ytrn = zeros(n.TRAIN,numResponses);
for ii = 1 : n.TRAIN
    Xtrn{ii} = data_c(ii:ii,1:end-1);
    m = mean(Xtrn{ii}); Xtrn{ii} = Xtrn{ii}-m;
    Ytrn(ii) = data_c(ii:ii,end)-m;
end
Xval = cell(n.TEST, 1);
Yval = zeros(n.TEST,numResponses);
for ii = 1:n.TEST
    Xval{ii} = data_c(ii+n.TRAIN:ii+n.TRAIN,1:end-1);
    m = mean(Xval{ii}); Xval{ii} = Xval{ii}-m;
    Yval(ii) = data_c(ii+n.TRAIN:ii+n.TRAIN,end)-m;
end
clear data_c

%% Set up model.
numFeatures = 1;
numResponses = 1;
numHiddenUnits = 32;
layers = [ ...
    sequenceInputLayer(numFeatures)
    %lstmLayer(numHiddenUnits, 'OutputMode','sequence')
    lstmLayer(numHiddenUnits,'OutputMode','last')
    fullyConnectedLayer(numResponses)
    regressionLayer];

%% Train options
epochs = 100;
options = trainingOptions('adam', ...
    'MaxEpochs',epochs, ...
    'GradientThreshold',1, ...
    'InitialLearnRate',0.005, ...
    'LearnRateSchedule','piecewise', ...
    'LearnRateDropPeriod',125, ...
    'LearnRateDropFactor',0.2, ...
    'MiniBatchSize',10000, ...
    'ValidationData',{Xval,Yval},...
    'CheckpointPath','/rc_scratch/luya7574/FM21/',...
    ...'ExecutionEnvironment','cpu',...
    ...'WorkerLoad',4,...
    'Verbose',1);

%% Train.
%net = trainNetwork(Xtrn,Ytrn,layers,options);
%save('../data/final_net.mat','net')


load('../data/final_net.mat','net')
valPred = predict(net,Xval)

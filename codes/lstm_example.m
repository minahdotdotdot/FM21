%% Get the data ready.
data = chickenpox_dataset;
data = [data{:}];
numTimeStepsTrain = floor(0.9*numel(data));

% plot into train/test
dataTrain = data(1:numTimeStepsTrain+1);
dataTest = data(numTimeStepsTrain+1:end);

% Standardsize
mu = mean(dataTrain);
sig = std(dataTrain);
dataTrainStandardized = (dataTrain - mu) / sig;

% Split into input/output
XTrain = dataTrainStandardized(1:end-1);
YTrain = dataTrainStandardized(2:end);

%% Set up LSTM.
numFeatures = 1;
numResponses = 1;
numHiddenUnits = 200;

layers = [ ...
    sequenceInputLayer(numFeatures)
    lstmLayer(numHiddenUnits)
    fullyConnectedLayer(numResponses)
    regressionLayer];
options = trainingOptions('adam', ...
    'MaxEpochs',250, ...
    'GradientThreshold',1, ...
    'InitialLearnRate',0.005, ...
    'LearnRateSchedule','piecewise', ...
    'LearnRateDropPeriod',125, ...
    'LearnRateDropFactor',0.2, ...
    'Verbose',0);

%% Train.
net = trainNetwork(XTrain,YTrain,layers,options);

%% See how it did, and put in true value as we go.
net = resetState(net);
net = predictAndUpdateState(net,XTrain);
model= layerGraph([
YPred = [];

dataTestStandardized = (dataTest - mu) / sig;
XTest = dataTestStandardized(1:end-1);
numTimeStepsTest = numel(XTest);
for i = 1:numTimeStepsTest
    [net,YPred(:,i)] = predictAndUpdateState(net,XTest(:,i),'ExecutionEnvironment','cpu');
end

% Un-standardize.
YPred = sig*YPred + mu;

% Evaluate with RMSE.
YTest = dataTest(2:end);
rmse = sqrt(mean((YPred-YTest).^2))

%% Plot
clf();
subplot(2,1,1)
plot(YTest)
hold on
plot(YPred,'.-')
hold off
legend(["Observed" "Predicted"])
ylabel("Cases")
title("Forecast with Updates")

subplot(2,1,2)
stem(YPred - YTest)
xlabel("Month")
ylabel("Error")
title("RMSE = " + rmse)
saveas(gcf,'../figs/lstm_example.png')
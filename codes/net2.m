modelLG = layerGraph([
    imageInputLayer([numSteps 1 1],'Name','input_encoder','Normalization','none')
    % convolution2dLayer([3 1], 3, 'Padding','same', 'Stride', 1, 'Name', 'conv1a')
    % eluLayer('Name','elu1a')
    % convolution2dLayer([3 1], 9, 'Padding','same', 'Stride', 1, 'Name', 'conv1b')
    % eluLayer('Name','elu1b')
    % convolution2dLayer([3 1], 27, 'Padding','same', 'Stride', 1, 'Name', 'conv1c')
    % eluLayer('Name','elu1c')
    % maxPooling2dLayer([2,1], 'Stride',[2,1], 'Name','pool1') % Drops to dsize/2
    % convolution2dLayer([3,1], 27, 'Padding','same', 'Stride', 1, 'Name', 'conv2a')
    % eluLayer('Name','elu2a')
    % convolution2dLayer([3,1], 27, 'Padding','same', 'Stride', 1, 'Name', 'conv2b')
    % eluLayer('Name','elu2b')
    % maxPooling2dLayer([2,1], 'Stride',[2,1], 'Name','pool2') % Drops to dsize/4
    % convolution2dLayer([3,1], 27, 'Padding','same', 'Stride', 1, 'Name', 'conv3a')
    % eluLayer('Name','elu3a')
    % convolution2dLayer([3,1], 27, 'Padding','same', 'Stride', 1, 'Name', 'conv3b')
    % eluLayer('Name','elu3b')
    fullyConnectedLayer(16, 'Name', 'fc_encoder1')
    % sigmoidLayer('Name','sigmoid1')
    reluLayer('Name','relu4a')
    fullyConnectedLayer(16, 'Name', 'fc_encoder2')
    %sigmoidLayer('Name','sigmoid2')
    reluLayer('Name','relu4b')
    fullyConnectedLayer(1, 'Name', 'fc_encoder3')
    %softmaxLayer('Name','softmax')
    sigmoidLayer('Name','sigmoid3')
    ]);
modelNet = dlnetwork(modelLG);

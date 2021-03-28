modelLG = layerGraph([
    imageInputLayer([numSteps 1 1],'Name','input_encoder','Normalization','none')
    convolution2dLayer([3 1], 3, 'Padding','same', 'Stride', 1, 'Name', 'conv1a')
    eluLayer('Name','elu1a')
    convolution2dLayer([3 1], 9, 'Padding','same', 'Stride', 1, 'Name', 'conv1b')
    eluLayer('Name','elu1b')
    convolution2dLayer([3 1], 27, 'Padding','same', 'Stride', 1, 'Name', 'conv1c')
    eluLayer('Name','elu1c')
    maxPooling2dLayer([2,1], 'Stride',[2,1], 'Name','pool1') % Drops to dsize/2
    convolution2dLayer([3,1], 27, 'Padding','same', 'Stride', 1, 'Name', 'conv2a')
    eluLayer('Name','elu2a')
    convolution2dLayer([3,1], 27, 'Padding','same', 'Stride', 1, 'Name', 'conv2b')
    eluLayer('Name','elu2b')
    maxPooling2dLayer([2,1], 'Stride',[2,1], 'Name','pool2') % Drops to dsize/4
    convolution2dLayer([3,1], 27, 'Padding','same', 'Stride', 1, 'Name', 'conv3a')
    eluLayer('Name','elu3a')
    convolution2dLayer([3,1], 27, 'Padding','same', 'Stride', 1, 'Name', 'conv3b')
    eluLayer('Name','elu3b')
    fullyConnectedLayer(50, 'Name', 'fc_encoder1')
    eluLayer('Name','elu4a')
    fullyConnectedLayer(1, 'Name', 'fc_encoder2')
    ]);
modelNet = dlnetwork(modelLG);

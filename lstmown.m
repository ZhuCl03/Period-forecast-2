%% 导入数据
for i=1:size(G_new,1)
    data(i,:) = G_new{i,1};
end
%% 归一化
mu = mean(data);
sig = std(data);
for i=1:size(data,2)
    dataStandardized(:,i) = (data(:,i) - mu(:,i) )/ sig(:,i);
end
XTrain = dataStandardized(1:end-1,:)';
YTrain = dataStandardized(2:end,:)';
%% 网络结构
layers = [
    sequenceInputLayer(size(data,2),"Name","input")
    lstmLayer(floor(sqrt(2*size(data,2)))+3,"Name","lstm")
%     dropoutLayer(0.2,"Name","drop")
    fullyConnectedLayer(size(data,2),"Name","fc")
    regressionLayer];
% 定义训练参数
options = trainingOptions('adam', ...
    'MaxEpochs',2000, ...
    'GradientThreshold',1, ...
    'InitialLearnRate',0.005, ...
    'LearnRateSchedule','piecewise', ...
    'LearnRateDropPeriod',125, ...
    'LearnRateDropFactor',0.2, ...
    'Verbose',0, ...
    'Plots','training-progress');
%% 训练网络
net = trainNetwork(XTrain,YTrain,layers,options);
%% 测试集归一化
% % 预测
net = predictAndUpdateState(net,XTrain);
[net,YPred] = predictAndUpdateState(net,YTrain(:,end-1));

for i = 2:10
    [net,YPred(:,i)] = predictAndUpdateState(net,YPred(:,i-1),'ExecutionEnvironment','cpu');
end
YPred=YPred';
for i=1:size(YPred,2)
    YPrednew(:,i) = YPred(:,i)*sig(i)+mu(i);
end
% YPred = sig*YPred + mu; 



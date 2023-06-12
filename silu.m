clc
clear
%% 初始化（设置阈值读取数据）
xi=xlsread('C:\Users\夜语\Desktop\混沌时间序列.xls');
plot(xi)
hold on
T_period=50;test1=1081;
%% step1（读取自然周期点）
x=xi(1:test1);
[Pmax,kmax]=max(x(end-T_period:end,1));
kmax=kmax+size(x,1)-T_period-1;
[Pmin,kmin]=min(x(end-T_period:end,1));
kmin=kmin+size(x,1)-T_period-1;
if kmax>kmin
    P(1,:)=[kmax Pmax];
    key=1;
else
    P(1,:)=[kmin Pmin];
    key=2;
end
i=1;
while P(i,1)-T_period>=0
    if key==1
        [Pmin,kmin]=min(x(P(i,1)-T_period:P(i,1),1));
        kmin=kmin+P(i,1)-T_period-1;
        key=2;
        P(i+1,:)=[kmin Pmin];
        key=2;
    else
        [Pmax,kmax]=max(x(P(i,1)-T_period:P(i,1),1));
        kmax=kmax+P(i,1)-T_period-1;
        key==2;
        P(i+1,:)=[kmax Pmax];
        key=1;
    end
    i=i+1;
end
plot(P(:,1),P(:,2),'k+')
P_point=sortrows(P,1);
P_point(end,:)=[];
%% BPNN的出下一个极值点
%输入层
t_num=5;
for i=1:size(P_point)-t_num
    PP=[];
    for j=0:t_num
        PP=[PP P_point(i+j,1)];
    end
    P_data(i,:)=PP;
end
P_data=P_data';

P=[];
p=P_data(1:end-1,:);
t=P_data(end,:);
[P,minp,maxp,T,mint,maxt]=premnmx(p,t); %样本数据归一化  
net=newff(minmax(P),[floor(sqrt(t_num+1))+5,1],{'tansig','purelin'},'traingdx');%创建一个新的前向神经网络
                         %设置训练参数
net.trainParam.show=50;%显示中间结果的周期
net.trainParam.lr=0.0035;%学习率
net.trainparam.epochs=50000;%最大迭代次数
net.trainparam.goal=1e-6;%目标误差
                   %用traingdm算法训练BP网络
[net,tr]=train(net,P,T);
                      %对BP网络进行仿真
A=sim(net,P);
a=postmnmx(A,mint,maxt);
inputWeights=net.IW{1,1};%优化后输入层权值和阈值
inputbias=net.b{1};                  
layerWeights=net.LW{2,1};%优化后网络层权值和阈值
layerbias=net.b{2};
%% 预测出实际数值
pnew=P_data(2:end,end);
SamNum=size(pnew,2);
%用原始数据的归一化参数对新数据归一化
pnewn=tramnmx(pnew,minp,maxp);
%隐含层输出预测结果
HiddenOut=tansig(inputWeights*pnewn+repmat(inputbias,1,SamNum));
%输出层输出预测结果
anewn=purelin(layerWeights*HiddenOut+repmat(layerbias,1,SamNum));
%还原为原始数据组
anew=postmnmx(anewn,mint,maxt)
figure
plot(t)
hold on
plot([a floor(anew)],zeros(size([a floor(anew)])),'+')
figure
plot(t-a)
%% 窗口周期
anew=1089;
T_point=[P_point(:,1);floor(anew)];
test2=test1;
lamda=(test1-T_point(end-1))/(T_point(end)-T_point(end-1));
i=size(T_point,1)-1;
while i-2>0
    i=i-2;
    tt=floor(lamda*(T_point(i+1)-T_point(i))+0.5)+T_point(i);
    test2=[tt;test2];
end





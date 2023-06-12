clc
clear
%% 初始化（设置阈值读取数据）
%xi=xlsread('C:\Users\夜语\Desktop\混沌时间序列.xls');
%xi=xlsread('C:\Users\夜语\Desktop\水流数据.xls');
%xi=xlsread('C:\Users\夜语\Desktop\每日低温.xls');
xi=xlsread('C:\Users\夜语\Desktop\每月太阳黑子1949.02-2022.04.xls');
plot(xi)
hold on    
x=xi(1:1081);tGG=1;
for T_period=10:1:200
    P=[];
    %% step1（读取自然周期点）
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
        if P(i,1)-T_period<=0
            break
        end
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
    GG{tGG,1}=P;
    GG{tGG,2}=1;
    GG{tGG,3}=T_period;
    for i=2:size(P,1)-1
        if P(i-1,1)-P(i,1)<=T_period/4
            GG{tGG,2}=2;
            break
        end
    end
    tGG=tGG+1;
end
P_point=sortrows(P,1);
P_point(end,:)=[];
for i=1:size(GG,1)
    N1(i,1)=size(GG{i,1},1);
end
figure
plot(1:size(N1,1),N1)
t=1;
for i=1:size(GG,1)
    if GG{i,2}==1
    N(t,1)=size(GG{i,1},1);
    N(t,2)=GG{i,3};
    t=t+1;
    end
end
plot(N(t,2),N(t,1))




%GG{127,1}-GG{125,1}
%plot(P(:,1),P(:,2),'k+')
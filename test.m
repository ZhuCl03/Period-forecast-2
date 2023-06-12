%   Simple usage example of l1tf
x=xlsread('C:\Users\夜语\Desktop\混沌时间序列.xls');
n = length(x);
y=x;
lambda_max = l1tf_lambdamax(y);
[z1,status] = l1tf(y, 0.00025*lambda_max);
[z2,status] = l1tf(y, 0.00005*lambda_max);
[z3,status] = l1tf(y, 0.00025*lambda_max);
xyzs = [x y z1 z2 z3];
maxx = max(max(xyzs));
minx = min(min(xyzs));

figure(1);
subplot(2,2,1); plot(1:n,x,'b',1:n,y, 'r'); ylim([minx maxx]); title('original');
subplot(2,2,2); plot(1:n,x,'b',1:n,z1,'r'); ylim([minx maxx]); title('lambda = 0.0001');
subplot(2,2,3); plot(1:n,x,'b',1:n,z2,'r'); ylim([minx maxx]); title('lambda = 0.0005');
subplot(2,2,4); plot(1:n,x,'b',1:n,z3,'r'); ylim([minx maxx]); title('lambda = 0.0025');

test1=1081;
i=1;l1=[];
while i+1<test1&&i+j<=test1
    key=1;
    k=z1(i+1)-z1(i);
    b=z1(i)-k;
    j=2;
    while key==1&&i+j<=test1
        if abs(z1(i+j)-(k*(j+1)+b))<1e-2
            j=j+1;
        else
            l1=[l1;i+j-1];
            key=2;
            i=i+j;
        end
    end
end
%% 计算数据
l1=[1;l1;test1];
for i=1:size(l1,1)-1
    T=l1(i+1)-l1(i)+1;
    k=(z1(l1(i+1))-z1(l1(i)))/(T-1);
    b=z1(l1(i))-k;
    delta=norm(z1(l1(i):l1(i+1),1)-y(l1(i):l1(i+1),1),2)/sqrt(T);
    PL(i,:)=[k b T delta];
end
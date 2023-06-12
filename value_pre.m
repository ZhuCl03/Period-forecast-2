% for j=1:size(YPrednew(1,:),2)/3
%     P_new(j,:)=YPrednew(1,3*(j-1)+1:3*j);
% end
% %修正
% for j=1:size(P_new,1)
%     if P_new(j,3)<0
%         P_new(j,3)=0;
%     end 
%     if j==1
%         P_new(j,3)=floor(sum(P_new(1:j,3)));
%     else
%         P_new(j,3)=floor(sum(P_new(1:j,3)))-sum(P_new(1:j-1,3));
%     end
% end
% Pv_new=[];
% for j=1:size(P_new,1)
%     if P_new(j,3)~=0
%         Pv_new=[Pv_new [1:P_new(j,3)]*P_new(j,1)+P_new(j,2)];
%     end
% end
% figure
% plot(y(test1+1:test1+size(Pv_new,2)))
% hold on
% plot(Pv_new)
pk=1;
P_new=[];
for i=2:size(YPrednew,1)
    for j=1:size(YPrednew(i,:),2)/3
        P_new(pk,:)=YPrednew(i,3*(j-1)+1:3*j);
        pk=pk+1;
    end
end
%修正
for j=1:size(P_new,1)
    if P_new(j,3)<0
        P_new(j,3)=0;
    end
    if j==1
        P_new(j,3)=floor(sum(P_new(1:j,3)));
    else
        P_new(j,3)=floor(sum(P_new(1:j,3)))-sum(P_new(1:j-1,3));
    end
end
Pv_new=[];
for j=1:size(P_new,1)
    if P_new(j,3)~=0
        Pv_new=[Pv_new [1:P_new(j,3)]*P_new(j,1)+P_new(j,2)];
    end
end
figure
qq=120;
plot(y(test1+1:test1+qq))
hold on
plot(Pv_new(1:qq))

for i=1:qq
    RMSE(i,1)=norm(y(test1+1:test1+i)-Pv_new(1:i)')/sqrt(i);
    MAE(i,1)=sum(abs(y(test1+1:test1+i)-Pv_new(1:i)'))/i;
end
aaa=Pv_new(1:qq)'
bbb=y(test1+1:test1+qq)
R2(1)=1-60*RMSE(60)^2/sum((y(test1+1:test1+60)-mean(y(test1+1:test1+60))).^2)
R2(2)=1-120*RMSE(120)^2/sum((y(test1+1:test1+120)-mean(y(test1+1:test1+120))).^2)

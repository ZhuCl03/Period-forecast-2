N_Cut=3;alpha=0.5;
for i=1:size(G,1)
    PL_off=[];
    for j=1:size(G{i,1},2)/4
        PL_off(j,:)=[G{i,1}(1,4*(j-1)+1:4*j) 0];
    end
    start_ori=test2(i);
    PL_num=size(PL_off,1)
    for j=1:PL_num
            if PL_off(j,4)==0
                Fexp=0;
            else
                Fexp=0;
                for k=1:PL_off(j,3)
                    x_LS=PL_off(j,1)*k+PL_off(j,2);
                    x_OLS=y(start_ori+k);
                    Fexp=Fexp+exp(-((x_LS-x_OLS)^2/(2*PL_off(j,4)^2)));
                end
                Fexp=PL_off(j,3)*PL_off(j,4)/Fexp;
            end
            PL_off(j,5)=Fexp;
    end
        
    while size(PL_off,1)>N_Cut 
        PL_num=size(PL_off,1);
        PL5=[];
        for j=1:PL_num-1
            if j==1
                start_or1=1;
            else
                start_or1=sum(PL_off(1:j-1,3))+1;
            end
            x_OLS=y(start_ori+start_or1:start_ori+sum(PL_off(1:j+1,3)));
            kb_ONE=polyfit(1:size(x_OLS,1),x_OLS',1);
            x_OLS1=kb_ONE(1)*[1:size(x_OLS,1)]'+kb_ONE(2);
            delta=sqrt(sum(abs(x_OLS-x_OLS1).^2)/size(x_OLS,1));
            Fexp=0;
            for k=1:size(x_OLS,1)
                Fexp=Fexp+exp(-((x_OLS(k)-x_OLS1(k))^2/(2*delta^2)));
            end
            PL5(j,1:5)=[kb_ONE size(x_OLS,1) delta size(x_OLS,1)*delta/Fexp];
        end
        [value j]=min(PL5(:,5));
        if min(PL_off(j:j+1,5))==0
            PL_off(j,:)=[];
            PL_off(j,:)=PL5(j,:);
        elseif PL5(j,5)<=alpha*min(PL_off(j:j+1,5))&&min(PL_off(j:j+1,5))~=0
            PL_off(j,:)=[];
            PL_off(j,:)=PL5(j,:);
        elseif PL5(j,5)>alpha*min(PL_off(j:j+1,5))&&min(PL_off(j:j+1,5))~=0
            break;
        end
    end
    P=[];
    for j=1:size(PL_off,1)
        P=[P PL_off(j,:)];
    end
    G{i,1}=P;
end
        
        
    
%生成两个有明显平移性质的时间序列
PP=[];
for i_ori=size(G,1):-1:1
    PP=[PP [size(G{i_ori,1},2);i_ori]];
end
[a,b]=max(PP(1,:));
j_ori=PP(2,b);
for j=1:size(G{j_ori,1},2)/5
    PL_offori(j,:)=[G{j_ori,1}(1,5*(j-1)+1:5*j)];
end

for i_ori=1:size(G,1)
    if i_ori==6
        1;
    end
    if i_ori~=j_ori
        m=size(G{i_ori,1},2)/5;
        n=size(G{j_ori,1},2)/5;
        Dis=0;
        for i1=1:m
            for j1=1:n
                m_part=G{i_ori,1}(:,5*(i1-1)+1:5*i1-1);
                n_part=G{j_ori,1}(:,5*(j1-1)+1:5*j1-1);
                distance(i1,j1)=L_dis(m_part,n_part);
            end
        end
        %计算两个序列
        DP = zeros(m,n);
        DP(1,1) = distance(1,1);
        for i=2:m
            DP(i,1) = distance(i,1)+DP(i-1,1);
        end
        for j=2:n
            DP(1,j) = distance(1,j)+DP(1,j-1);
        end
        for i=2:m
            for j=2:n
                DP(i,j) = distance(i,j) + GetMin(DP(i-1,j),DP(i,j-1),DP(i-1,j-1));
            end
        end
        %回溯，找到各个特征点之间的匹配关系
        i = m;
        j = n;
        CP=[];
        while(~((i == 1)&&(j==1)))
            CP=[[i;j] CP];
            Dis=Dis+distance(i,j);
            if(i==1)
                index_i = 1;
                index_j = j-1;
            elseif(j==1)
                index_i = i-1;
                index_j = 1;
            else
                [index_i,index_j] = GetMinIndex(DP(i-1,j-1),DP(i-1,j),DP(i,j-1),i,j)
            end
            i = index_i;
            j = index_j;
        end
        CP=[[1;1] CP];
        
        for j=1:size(G{i_ori,1},2)/5
            PL_off1(j,:)=[G{i_ori,1}(1,5*(j-1)+1:5*j)];
        end
        
        PP_fix=[];PPi=1;
        while PPi<=size(CP,2)
            if PPi==size(CP,2)
                PP_fix=[PP_fix PL_off1(end,1:3)];
                PPi=PPi+1;
            elseif PPi<size(CP,2)&&CP(2,PPi+1)~=CP(2,PPi)
                j=1;
                while CP(1,PPi)==CP(1,PPi+j)
                    j=j+1;
                    if PPi+j>size(CP,2)
                        break
                    end
                end
                jk=j;
                PP=PL_offori(CP(2,PPi):CP(2,PPi+j-1),3);
                PP_cut=[];
                for j=1:size(PP,1)-1
                    PP_cut(j,1)=floor(PL_off1(CP(1,PPi),3)*sum(PP(1:j,1))/sum(PP));
                end
                for j=size(PP,1)-1:-1:2
                    PP_cut(j,1)=PP_cut(j,1)-PP_cut(j-1,1);
                end
                PP_cut(size(PP,1),1)=PL_off1(CP(1,PPi),3)-sum(PP_cut);
                PP_fix1=[];
                for j=1:size(PP_cut,1)
                    if j==1
                        PP_fix1=[PP_fix1;[PL_off1(CP(1,PPi),1:2) PP_cut(1,1)]];
                    else
                        b=PP_cut(j,1)*PL_off1(CP(1,PPi),1)+PP_fix1(j-1,2);
                        PP_fix1=[PP_fix1;[PL_off1(CP(1,PPi),1) b PP_cut(j,1)]];
                    end
                end
                for j=1:size(PP_fix1,1)
                    PP_fix=[PP_fix PP_fix1(j,:)];
                end
                PPi=PPi+jk;
            elseif size(CP,2)&&CP(2,PPi+1)==CP(2,PPi) 
                PP_fix1=[];
                j=1;
                while CP(2,PPi)==CP(2,PPi+j)
                    j=j+1;
                    if PPi+j>size(CP,2)
                        break
                    end
                end
                jk=j;
                if PPi==1
                    Py=y(test2(i_ori)+1:test2(i_ori)+sum(PL_off1(1:CP(1,PPi+jk-1),3)));
                else
                    Py=y(test2(i_ori)+sum(PL_off1(1:CP(1,PPi-1),3))+1:test2(i_ori)+sum(PL_off1(1:CP(1,PPi+jk-1),3)));
                end
                PP_fix1=polyfit(1:size(Py,1),Py',1);
                Px=PP_fix1(1)*[1:size(Py,1)]+PP_fix1(2);
                %delta=(norm(Py-Px',2))^2/size(Py,1);
                PP_fix1=[PP_fix1 size(Py,1)];
                PP_fix=[PP_fix PP_fix1];
                PPi=PPi+jk;
            end
            G_new{i_ori,1}=PP_fix;
        end
    else
        PP_fix1=[];
        for j=1:size(G{i_ori,1},2)/5
            PP_fix1=[PP_fix1 G{i_ori,1}(1,5*(j-1)+1:5*(j-1)+3)];
        end
        G_new{i_ori,1}=PP_fix1;
    end
end



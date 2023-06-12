for i=1:size(PL,1)-1
    PL(i,3)=PL(i,3)-1;
end
test2=[0;test2;test1];%0Óëend
i=1;j=i;k=0;p=1;
while i<size(PL,1)%(sum(PL(:,3))
    sumT=0;j=i;test_pnum=test2(p+1)-test2(p);
    while sumT<=test_pnum&&j<=size(PL,1)
        j=j+1;
        if  j<=size(PL,1)
            sumT=sum(PL(i:j,3));
        end
        if  j>size(PL,1)
            sumT=sum(PL(i:j-1,3));
        end
    end
    if sum(PL(i:j-1,3))==test_pnum
        P=[];
        for m=i:j-1
            P=[P PL(m,:)];
        end
        k=k+1;
        G{k,1}=P;
    elseif sum(PL(i:j-1,3))<test_pnum
        if j>size(PL,1)
            P=[];
            for m=i:size(PL,1)
                P=[P PL(m,:)];
            end
            k=k+1;
            G{k,1}=P;
        else
            P=[];
            for m=i:j-1
                P=[P PL(m,:)];
            end
            p_sum=sum(PL(i:j-1,3));
            start=test2(p)+p_sum;
            
            x_part=y(start+1:start+test_pnum-p_sum);
            kb_part=polyfit(1:test_pnum-p_sum,x_part',1);
            y_part=kb_part(:,1)*[1:test_pnum-p_sum]+kb_part(:,2);
            delta=norm(y_part-x_part',2)/sqrt(test_pnum-p_sum);
            part1=[PL(j,1:2) test_pnum-p_sum delta];
            
            if PL(j,3)-part1(3)-1==0
                x_part=y(start+test_pnum-p_sum+1:start+test_pnum-p_sum+PL(j,3)-part1(3)+1);
                kb_part=polyfit(1:PL(j,3)-part1(3)+1,x_part',1);
                delta=0; 
                part2=[kb_part PL(j,3)-part1(3) delta];
            else
                x_part=y(start+test_pnum-p_sum+1:start+test_pnum-p_sum+PL(j,3)-part1(3));
                kb_part=polyfit(1:PL(j,3)-part1(3),x_part',1);
                y_part=kb_part(:,1)*[1:PL(j,3)-part1(3)]+kb_part(:,2);
                delta=norm(y_part-x_part',2)/sqrt(PL(j,3)-part1(3));
                part2=[kb_part PL(j,3)-part1(3) delta];
            end
            PL(j,:)=part2;
            k=k+1;
            P=[P part1];
            G{k,1}=P;
        end
    end
    p=p+1;
    i=j;
end
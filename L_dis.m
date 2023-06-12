function dis = L_dis(m_part,n_part)
syms x
%上小m下大n
if m_part(:,3)>n_part(:,3)
    Nu=m_part;
    m_part=n_part;
    n_part=Nu;
end
nu=m_part(:,3);
dis1=int(abs((m_part(:,1)*x+m_part(:,2))-(n_part(:,1)*x+n_part(:,2))),0,nu);
dis1=eval(dis1)+sqrt(2*pi)/2*abs(m_part(:,4)-n_part(:,4))*nu;

point1=m_part(:,1)*nu+m_part(:,2);
point2=n_part(:,1)*n_part(:,3)+n_part(:,2);
nuew=n_part(:,3)-nu;
if nuew==0
    dis2=0;
else
    m_part=[(point2-point1)/nuew point1 nuew 0];
    n_part=[n_part(:,1) n_part(:,1)*nu+n_part(:,2) nuew n_part(:,4)];
    dis2=int(abs((m_part(:,1)*x+m_part(:,2))-(n_part(:,1)*x+n_part(:,2))),0,nuew);
    dis2=eval(dis2)+sqrt(2*pi)/2*abs(m_part(:,4)-n_part(:,4))*nuew;
end
dis=dis1+dis2;


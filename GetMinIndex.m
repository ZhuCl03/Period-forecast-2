function [index_i,index_j] = GetMinIndex(a,b,c,i,j)
%a ���������Ͻǣ�b ���������Ϸ���c˵�������� 
%i �ǵ�ǰ��x����  j �ǵ�ǰ y����
if(a <= b && a <= c)
    index_i = i-1;
    index_j = j-1;
elseif(b <= a && b <= c)
    index_i = i-1;
    index_j = j;
elseif(c <= b && c <= a)
    index_i = i;
    index_j = j-1;
end
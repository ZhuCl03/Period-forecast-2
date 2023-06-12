function [index_i,index_j] = GetMinIndex(a,b,c,i,j)
%a 是相邻左上角，b 是相邻正上方，c说相邻正左方 
%i 是当前的x坐标  j 是当前 y坐标
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
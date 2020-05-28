function [YXOX,Mp] = MultilevelYXOXDensityFunc(XUp,XDown,X,Px,sigma_w,MarginP)
%MULTILEVELYDENSITY 此处显示此函数摘要
%   此处显示详细说明
N=length(X);
r=log2(N);
%X is like X5X4X3...X1 from left to right
XB=[XDown,XUp];
Index=[0:2^(r-length(XB))-1]*2^(length(XB))+bin2dec(XB)+1;
if XDown=='0'
    Mp=MarginP;
else
    Mp=1-MarginP;
end
YXOXstr=['@(x) ', num2str(1/Mp),'*('];

for I=1:length(Index)
    YXOXstr=[YXOXstr,'Px(',num2str(Index(I)),')*normpdf(x,','X(',num2str(Index(I)),'),',num2str(sigma_w),')+'];
    
end
YXOXstr(end)=[];
YXOXstr=[YXOXstr,')'];
%YBOB=str2func(YBOBstr);
YXOX=eval(YXOXstr);
end


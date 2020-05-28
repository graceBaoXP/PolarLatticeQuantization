function [YXDens] = MultilevelYXDensityFunc(XUp,X,Px,sigma_w)
%MULTILEVELYDENSITY 此处显示此函数摘要
%   此处显示详细说明
N=length(X);
r=log2(N);
if isempty(XUp)
   Index=1:N;
else
    Index=[0:2^(r-length(XUp))-1]*2^(length(XUp))+bin2dec(XUp)+1;
end
YXstr='@(x) ';

for I=1:length(Index)
    %YBstr=[YBstr,'normpdf(x,',num2str(QzPoint(Index(I))),',',num2str(sqrt(D)),')+'];
    YXstr=[YXstr,'Px(',num2str(Index(I)),')*normpdf(x,','X(',num2str(Index(I)),'),',num2str(sigma_w),')+'];
end
YXstr(end)=[];
%YB=str2func(YBstr);
YXDens=eval(YXstr);
end


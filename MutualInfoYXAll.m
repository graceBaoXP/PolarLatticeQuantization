function [ MIYX]=MutualInfoYXAll(X,Px,sigma_w)
%MUTUALINFOYXALL 此处显示此函数摘要
%   此处显示详细说明
N=numel(X);
MIYX=0;
YDens= MultilevelYDensityFunc(X,Px,sigma_w );
    for I=1:N
        YOX=@(x) normpdf(x,X(I),sigma_w);
        F=@(x) YOX(x).*log2(YOX(x)./(YDens(x)+eps)+eps);
        MIYX=MIYX+Px(I)*integral(F,-inf,inf);
    end
end


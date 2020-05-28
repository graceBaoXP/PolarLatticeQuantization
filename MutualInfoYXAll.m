function [ MIYX]=MutualInfoYXAll(X,Px,sigma_w)
%MUTUALINFOYXALL �˴���ʾ�˺���ժҪ
%   �˴���ʾ��ϸ˵��
N=numel(X);
MIYX=0;
YDens= MultilevelYDensityFunc(X,Px,sigma_w );
    for I=1:N
        YOX=@(x) normpdf(x,X(I),sigma_w);
        F=@(x) YOX(x).*log2(YOX(x)./(YDens(x)+eps)+eps);
        MIYX=MIYX+Px(I)*integral(F,-inf,inf);
    end
end


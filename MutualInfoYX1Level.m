function [ MI ] = MutualInfoYX1Level(XUp,XDown,X,Px,sigma_w,MarginPL)
%MUL �˴���ʾ�˺���ժҪ
%   �˴���ʾ��ϸ˵��
YX=MultilevelYXDensityFunc(XUp,X,Px,sigma_w );
[YXOX,Mp]=MultilevelYXOXDensityFunc(XUp,XDown,X,Px,sigma_w,MarginPL);
F=@(x) YXOX(x).*log2(YXOX(x)./(YX(x)+eps)+eps);
% Tx=-10:0.01:10;
% Ty=F(Tx);
% Temp=isnan(Ty);
% XI=find(Temp==0);
MI=Mp*integral(F,-inf,inf);
%MI=quadgk(F,Tx(XI(1)),Tx(XI(end)));
end


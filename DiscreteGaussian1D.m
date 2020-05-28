function [x,prob,Anvp] = DiscreteGaussian1D(eta,sigma_s,M)
%DISCRETEGAUSSIAN1D 此处显示此函数摘要
%   此处显示详细说明
x=eta*(-1*M/2+1:M/2);
% x=0:1:M-1;
xdens=normpdf(x,0,sigma_s);
% xdens=normpdf(x,M/2,sigma_s);
%prob=xdens./(sum(xdens));
prob=xdens;
Anvp=sum(x.^2.*prob);
%estimate flatness factor
end


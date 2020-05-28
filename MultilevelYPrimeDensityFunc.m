function [ YDens ] = MultilevelYPrimeDensityFunc(X,Px,sigma_w )
%MULTILEVELYDENSITY �˴���ʾ�˺���ժҪ
%   �˴���ʾ��ϸ˵��
N=length(X);
Ystr='@(x) ';
for I=1:N
    Ystr=[Ystr,'Px(',num2str(I),')*normpdf(x,','X(',num2str(I),'),',num2str(sigma_w),')+'];
    
end
Ystr(end)=[];
YDens=eval(Ystr);
end


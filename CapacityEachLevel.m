function [ MI ] = CapacityEachLevel(l,X,Px,sigma_w,MarginP)
%CAPACITY4LEVEL �˴���ʾ�˺���ժҪ
%   �˴���ʾ��ϸ˵��
MI=0;
if l==1
   MI=MI+MutualInfoYX1Level([],'0',X,Px,sigma_w,MarginP(1,l))+MutualInfoYX1Level([],'1',X,Px,sigma_w,MarginP(1,l));
else
    for J=1:2^(l-1)
        MI=MI+MutualInfoYX1Level(dec2bin(J-1,l-1),'0',X,Px,sigma_w,MarginP(1,l))+MutualInfoYX1Level(dec2bin(J-1,l-1),'1',X,Px,sigma_w,MarginP(1,l) );
    end
end

end


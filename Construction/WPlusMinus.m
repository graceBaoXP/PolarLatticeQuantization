function [PPlus,PMinus] = WPlusMinus(Pary)
%WPLUSMINUS 此处显示此函数摘要
%   此处显示详细说明
[~,N]=size(Pary);
Pyox=zeros(2,N);
Pyox(2,:)=Pary(1,:).*Pary(2,:);
Pyox(1,:)=Pary(1,:)-Pyox(2,:);
Pxy=kron(Pyox,Pyox);
CPlus(1,:)=[Pxy(1,:),Pxy(3,:)];
CPlus(2,:)=[Pxy(4,:),Pxy(2,:)];
CMinus(1,:)=Pxy(1,:)+Pxy(4,:);
CMinus(2,:)=Pxy(2,:)+Pxy(3,:);
PPlus(1,:)=sum(CPlus,1);
PPlus(2,:)=min(CPlus)./PPlus(1,:);
PMinus(1,:)=sum(CMinus,1);
PMinus(2,:)=min(CMinus)./PMinus(1,:);
end


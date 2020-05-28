function [Qary]=PAdjust(Pary,Nmax)
%PADJUST 此处显示此函数摘要
%   此处显示详细说明
%#codegen
%coder.inline('never');

% Temp=find(Pary(2,:)>0.5);
% Pary(2,Temp)=1-Pary(2,Temp);
% Pary(2,:)=round(Pary(2,:)*1e8)/1e8;
Temp= Pary(1,:)==0;
Pary(:,Temp)=[];
[~,N]=size(Pary);
Puniq=unique(Pary(2,:),'sorted');
Nu=length(Puniq);
Qary=zeros(2,Nu);
    for I=1:Nu
        Qary(2,I)=Puniq(I);
        Temp= Pary(2,:)==Puniq(I);
        Qary(1,I)=sum(Pary(1,Temp));
    end

    if Nu>Nmax
       
    Qary=DegradePary_mex(Qary,uint32(Nmax));   
    end

end


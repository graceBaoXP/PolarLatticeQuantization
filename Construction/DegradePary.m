function [Qary] = DegradePary(Qary,Nmax )
%DEGRADEPARY 此处显示此函数摘要
%   此处显示详细说明
%#codegen
coder.inline('never');
       BSCp=Qary(2,:);
       Nu=length(BSCp);
%        PerfectC=find(BSCp==0);
%        BSCc(PerfectC)=1;
%        UselessC=find(BSCp==0.5);
%        Index([PerfectC,UselessC])=[];
       BSCc=sqrt(BSCp.*(1-BSCp));
       while Nu>Nmax
           DeltaC=zeros(1,Nu-1);
           BSCpbar=zeros(1,Nu-1);
           Cbar=zeros(1,Nu-1);
           Pbar=zeros(1,Nu-1);
           for I=1:Nu-1
               Pbar(I)=Qary(1,I)+Qary(1,I+1);
               BSCpbar(I)=Qary(1,I)/Pbar(I)*Qary(2,I)+Qary(1,I+1)/Pbar(I)*Qary(2,I+1);
               
               Cbar(I)=sqrt(BSCpbar(I)*(1-BSCpbar(I)));
              
               DeltaC(I)=Pbar(I)*Cbar(I)-Qary(1,I)*BSCc(I)-Qary(1,I+1)*BSCc(I+1);
           end
           %fprintf('%f\n',min(DeltaC));
           BestI=find(DeltaC==min(DeltaC));
           BestIJ=BestI(1);
           
           Qary(1,BestIJ)=Pbar(BestIJ);
           Qary(2,BestIJ)=BSCpbar(BestIJ);
           BSCc(BestIJ)=Cbar(BestIJ);
           BSCc(BestIJ+1)=[];
           Qary(:,BestIJ+1)=[];
           Nu=Nu-1;
       end
end




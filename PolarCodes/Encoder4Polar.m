function [X] = Encoder4Polar(Miu)
%ENCODER4POLAR 此处显示此函数摘要
%   此处显示详细说明
%#codegen
coder.inline('never');

BL=length(Miu);
Dim=log2(BL);
Idx=(1:1:BL);
OH=(1:2:BL);
EH=(2:2:BL);
Temp=Miu;
Temp1=Miu;
    if Dim==0
        X=Miu;
    else 
        for I=1:Dim
          OIdx=Idx(OH);
          EIdx=Idx(EH);
          Temp1(EIdx)=Temp(EIdx);
          Temp1(OIdx)=bitxor(Temp(EIdx),Temp(OIdx));
          %Temp1(OIdx)=Temp(EIdx)+Temp(OIdx);
          Idx=reshape(Idx,2,BL/2);
          Idx=reshape(Idx',1,BL);
          Temp=Temp1;
        end
        X=Temp1;
    end
    

    

end


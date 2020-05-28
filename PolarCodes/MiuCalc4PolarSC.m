function [MiuRegister] = MiuCalc4PolarSC(MiuRegister,I,SCLayer,NewMiu)
%MIUCALC4POLARSC 此处显示此函数摘要
%   此处显示详细说明
%#codegen
coder.inline('never');

N=length(MiuRegister(:,end))*2;
    if mod(I,2)==1
        MiuRegister(1,1)=NewMiu;
    %elseif I<N
    else
        EndLayer=SCLayer(I+1,1);
        Temp=zeros(2^(EndLayer-1),1,'uint8');
        Temp(1)=NewMiu;
        for J=1:EndLayer-1
            %MiuTemp=zeros(2^(J-1),2);
            MiuTemp=[MiuRegister(1:2^(J-1),J),Temp(1:2^(J-1),1)];
            MiuTemp(:,1)=mod(sum(MiuTemp,2),2);           
            Temp(1:2^J,1)=reshape(MiuTemp',2^J,1);            
        end
        MiuRegister(1:2^(EndLayer-1),EndLayer)=Temp;
    end

end


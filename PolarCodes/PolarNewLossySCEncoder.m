function [SigRec] = PolarNewLossySCEncoder(LROut,FreezeFlag,SigInAll,SCLayer,ReverseIndex)
%POLARSCLRDECODER Summary of this function goes here
%   Detailed explanation goes here
%#codegen
coder.inline('never');

N=length(LROut);
n=log2(N);
LRRegister=ones(N/2,n);
MiuRegister=zeros(N/2,n);
SigRec=zeros(1,N);

for I=1:N
    
    if FreezeFlag(uint32(I))==1
        LRRegister=LRCalc4PolarSC(LRRegister,MiuRegister,LROut,uint32(I),SCLayer);
        SigRec(uint32(I))=SigInAll(ReverseIndex(uint32(I)));
        MiuRegister=MiuCalc4PolarSC(MiuRegister,uint32(I),SCLayer,SigRec(uint32(I)));
    else
        LRRegister=LRCalc4PolarSC(LRRegister,MiuRegister,LROut,uint32(I),SCLayer);
        SigRec(uint32(I))=(LRRegister(1,1)<1); %MAP
        %SigRec(uint32(I))=(rand(1)<(1/(1+LRRegister(1,1))));% Random Rounding
        MiuRegister=MiuCalc4PolarSC(MiuRegister,uint32(I),SCLayer,SigRec(uint32(I)));
        
    end
    
end
SigRec=SigRec(ReverseIndex);
end


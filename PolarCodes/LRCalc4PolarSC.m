function [LRRegister] = LRCalc4PolarSC(LRRegister,MiuRegister,LRInput,OutputIndex,SCLayer)
%LRCACL4POLARSCDECODER Summary of this function goes here
%   Detailed explanation goes here
%#codegen
coder.inline('never');

LRMax=1e30;
N=length(LRInput);
    if OutputIndex==1
        EndLayer=SCLayer(OutputIndex,1);
        LR1=LRInput(1:2:N);
        LR2=LRInput(2:2:N);
        LRRegister(:,EndLayer)=(LR1.*LR2+1)./(LR1+LR2);
        for I=EndLayer-1:-1:1
            LR1=LRRegister(1:2:2^I,I+1);
            LR2=LRRegister(2:2:2^I,I+1);
            LRRegister(1:2^(I-1),I)=(LR1.*LR2+1)./(LR1+LR2);          
            LRRegister(1:2^(I-1),I)=LRAdjust(LRRegister(1:2^(I-1),I),LRMax);       
        end
    elseif OutputIndex==N/2+1
        EndLayer=SCLayer(OutputIndex,1);
        LR1=LRInput(1:2:N);
        LR2=LRInput(2:2:N);
        BitUsed=MiuRegister(:,end);
        LRRegister(:,EndLayer)=LR1.^(1-2*double(BitUsed')).*LR2;    
        LRRegister(:,EndLayer)=LRAdjust(LRRegister(:,EndLayer),LRMax);
       for I=EndLayer-1:-1:1
            LR1=LRRegister(1:2:2^I,I+1);
            LR2=LRRegister(2:2:2^I,I+1);
            LRRegister(1:2^(I-1),I)=(LR1.*LR2+1)./(LR1+LR2);          
            LRRegister(1:2^(I-1),I)=LRAdjust(LRRegister(1:2^(I-1),I),LRMax);       
        end
    elseif mod(OutputIndex,2)==0
       EndLayer=SCLayer(OutputIndex,1);
       LR1=LRRegister(1,EndLayer+1);
       LR2=LRRegister(2,EndLayer+1);
       BitUsed=MiuRegister(1,1);
       LRRegister(1,EndLayer)=LR1^(1-2*double(BitUsed))*LR2;
       LRRegister(1,EndLayer)=LRAdjust(LRRegister(1,EndLayer),LRMax);
    else
        EndLayer=SCLayer(OutputIndex,1);
        LR1=LRRegister(1:2:2^EndLayer,EndLayer+1);
        LR2=LRRegister(2:2:2^EndLayer,EndLayer+1);
        BitUsed=MiuRegister(1:2^(EndLayer-1),EndLayer);
        LRRegister(1:2^(EndLayer-1),EndLayer)=LR1.^(1-2*double(BitUsed)).*LR2;
        LRRegister(1:2^(EndLayer-1),EndLayer)=LRAdjust(LRRegister(1:2^(EndLayer-1),EndLayer),LRMax);
        for I=EndLayer-1:-1:1
            LR1=LRRegister(1:2:2^I,I+1);
            LR2=LRRegister(2:2:2^I,I+1);
            LRRegister(1:2^(I-1),I)=(LR1.*LR2+1)./(LR1+LR2);          
            LRRegister(1:2^(I-1),I)=LRAdjust(LRRegister(1:2^(I-1),I),LRMax);       
        end
    end


end


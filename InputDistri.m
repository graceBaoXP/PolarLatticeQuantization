function [InpDistri,MarginP,ShapChan,Entro] = InputDistri(p)
%INPUTDISTRI 此处显示此函数摘要
%   此处显示详细说明
M=numel(p);
r=log2(M);
InpDistri=cell(1,r);
ShapChan=cell(1,r);
MarginP=zeros(1,r);
Entro=zeros(1,r);
Ind=1:1:M;
RvInd=BitReverse(Ind);
% RvInd=mod(RvInd+16,32);
% kkk= RvInd==0;
% RvInd(kkk)=M;
InpDistri{1,r}=p(RvInd);
MarginP(1,r)=sum(InpDistri{1,r}(1:2:M));
Temp=InpDistri{1,r};
Entro(1,r)=sum(-Temp.*log2(Temp+eps));
Temp=reshape(Temp,2,2^(r-1));
TempChan(1,:)=Temp(1,:)/MarginP(1,r);
TempChan(2,:)=Temp(2,:)/(1-MarginP(1,r));
ShapChan{1,r}=TempChan;

    for L=r-1:-1:1
        TempChan=zeros(2,2^(L-1));
        Temp=InpDistri{1,L+1};
        Temp=reshape(Temp,2,2^L);
        InpDistri{1,L}=sum(Temp,1);
        MarginP(1,L)=sum(InpDistri{1,L}(1:2:2^L));
        Temp=InpDistri{1,L};
        Entro(1,L)=sum(-Temp.*log2(Temp+eps));
        Temp=reshape(Temp,2,2^(L-1));
        TempChan(1,:)=Temp(1,:)/MarginP(1,L);
        TempChan(2,:)=Temp(2,:)/(1-MarginP(1,L));
        ShapChan{1,L}=TempChan;
    end

end


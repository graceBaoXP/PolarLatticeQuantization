%This is the main file to show the lossy compression performance of 
%polar lattices

clc;
clear;
current_path=cd;
addpath([current_path,'\PolarCodes']); % Add the path for the polar SC algorithm
%==========================================================================
k=14; 
N=2^k; % Block length $N$ in our paper
ReverseIndex=BitReverse(1:N); % Bit inverse index for polar codes
[SCLayer] = PolarSCDecodePrepare(k); % Prepare the parameters of the polar SC decoder

% The following 2 mat files are generated by 'LatticeQZ_Para_settings_FixSigma_s.m'

load('LRFunc_save_test_D_0.20_SigmaS_3.0000.mat'); %Load the Probability functions P(Y|X1) P(Y,X1|X2).... etc. for each level
load('SymCapaLvl_save_test_D_0.20_SigmaS_3.0000.mat'); % Load the best achievable rate for F S and I at each level.


% The following Bhattacharyya parameters files are calculated by 'CalculateZn.m' for each level
load('Pe_BIMod2AWGN_test_D_0.20_tSigma_0.4422_Lvl_1_n_14.mat'); 
Zn1=PeLast(ReverseIndex);
load('Pe_BIMod2AWGN_test_D_0.20_tSigma_0.4422_Lvl_2_n_14.mat');
Zn2=PeLast(ReverseIndex);
load('Pe_BIMod2AWGN_test_D_0.20_tSigma_0.4422_Lvl_3_n_14.mat');
Zn3=PeLast(ReverseIndex);

% Since in the current demo, the target distortion is relatively small (We prepared 3 parameters Delta=0.1, 0.14 and 0.2)
% The channels for the last 3 levels are quite clean, with capacity close
% to 1. So we skip the Bhattacharyya parameters to save space.



%==========================================================================
C=CapacityLevel;
eta=0.5;
sigma_s=3; % sigma_s of the Gaussian source
M=64;
r=log2(M);  % Number of partition channels
D=0.20;     % Target Distortion
sigma_x=sqrt(sigma_s^2-D);

for Time=1:100
y=sigma_s*randn(1,N);
E=sum(y)/N;
%sum((y-E).^2)/N   %check the source variance.


%==========================================================================
% Compression for level 1
%==========================================================================
ISNum1=ceil(N*C(1));
FNum1=N-ISNum1;
[~,FreezeIndex,~]=SelectGoodChannels4Polar(Zn1,ISNum1);
FreezeRslv=ReverseIndex(FreezeIndex);
FreezeFlag=zeros(N,1);
FreezeFlag(FreezeRslv)=1;
LRLvl1=LRFunc{1,1}{1};
LROut1=LRLvl1(y);
SigIn1=randi([0,1],1,N);
tic;
[SigRec1] = PolarNewLossySCEncoder_mex(LROut1,uint32(FreezeFlag),uint8(SigIn1),int32(SCLayer),uint32(ReverseIndex));
toc;
X1=Encoder4Polar(SigRec1);
%==========================================================================


%==========================================================================
% Compression for level 2
%==========================================================================
ISNum2=ceil(N*C(2));
FNum2=N-ISNum2;
[~,FreezeIndex,~]=SelectGoodChannels4Polar(Zn2,ISNum2);
FreezeRslv=ReverseIndex(FreezeIndex);
FreezeFlag=zeros(N,1);
FreezeFlag(FreezeRslv)=1;
PreviousX=X1;
LROut2=ones(1,N);
for I=1:2^(2-1)
    temp=find(PreviousX==(I-1));
    LRFuncTemp=LRFunc{1,2}{I};
    LROut2(temp)=LRFuncTemp(y(temp));
end
SigIn2=randi([0,1],1,N);
[SigRec2] = PolarNewLossySCEncoder_mex(LROut2,uint32(FreezeFlag),uint8(SigIn2),int32(SCLayer),uint32(ReverseIndex));
X2=Encoder4Polar(SigRec2);


%==========================================================================
%Compression for level 3
%==========================================================================
ISNum3=ceil(N*C(3));
FNum3=N-ISNum3;
[SelectIndex,FreezeIndex,ZnSmall]=SelectGoodChannels4Polar(Zn3,ISNum3);
FreezeRslv=ReverseIndex(FreezeIndex);
FreezeFlag=zeros(N,1);
FreezeFlag(FreezeRslv)=1;
PreviousX=2*X2+X1;
LROut3=ones(1,N);
for I=1:2^(3-1)
    temp=find(PreviousX==(I-1));
    LRFuncTemp=LRFunc{1,3}{I};
    LROut3(temp)=LRFuncTemp(y(temp));
end
SigIn3=randi([0,1],1,N);
[SigRec3] = PolarNewLossySCEncoder_mex(LROut3,uint32(FreezeFlag),uint8(SigIn3),int32(SCLayer),uint32(ReverseIndex));
X3=Encoder4Polar(SigRec3);
%==========================================================================

%==========================================================================
%Compression for level 4
%==========================================================================
ISNum4=N;
FNum4=0;
FreezeFlag=zeros(N,1);
PreviousX=4*X3+2*X2+X1;
LROut4=ones(1,N);
for I=1:2^(4-1)
    temp=find(PreviousX==(I-1));
    LRFuncTemp=LRFunc{1,4}{I};
    LROut4(temp)=LRFuncTemp(y(temp));
end
SigIn4=randi([0,1],1,N);
[SigRec4] = PolarNewLossySCEncoder_mex(LROut4,uint32(FreezeFlag),uint8(SigIn4),int32(SCLayer),uint32(ReverseIndex));
X4=Encoder4Polar(SigRec4);


%==========================================================================
%Compression for level 5
%==========================================================================
ISNum5=N;
FNum5=0;
PreviousX=8*X4+4*X3+2*X2+X1;
LROut5=ones(1,N);
for I=1:2^(5-1)
    temp=find(PreviousX==(I-1));
    LRFuncTemp=LRFunc{1,5}{I};
    LROut5(temp)=LRFuncTemp(y(temp));
end
X5=LROut5<1; % In this demo since the target distortion is very small (high SNR), the channel at level 5 is very clean, 
             %therefore we can use hard descion to save some time. For
             %lower SNR, we can use the following SC algorithm to compress.

             
% SigIn5=randi([0,1],1,N);
% [SigRec5] = PolarNewLossySCEncoder_mex(LROut5,uint32(FreezeFlag),uint8(SigIn5),int32(SCLayer),uint32(ReverseIndex));
% X5=Encoder4Polar(SigRec5);


%==========================================================================
%Compression for level 6
%==========================================================================
ISNum6=N;
FNum6=0;
FreezeFlag=zeros(N,1);
PreviousX=16*X5+8*X4+4*X3+2*X2+X1;
LROut6=ones(1,N);
for I=1:2^(6-1)
    temp=find(PreviousX==(I-1));
    LRFuncTemp=LRFunc{1,6}{I};
    LROut6(temp)=LRFuncTemp(y(temp));
end

X6=LROut6<1;  % In this demo since the target distortion is very small (high SNR), the channel at level 5 is very clean, 
              %therefore we can use hard descion to save some time. For
              %lower SNR, we can use the following SC algorithm to compress.

% SigIn6=randi([0,1],1,N);
% [SigRec6] = PolarNewLossySCEncoder_mex(LROut6,uint32(FreezeFlag),uint8(SigIn6),int32(SCLayer),uint32(ReverseIndex));
%X6=Encoder4Polar(SigRec6);


%==========================================================================
%Combine all r levels and obtain the reconstruction signal x
%==========================================================================
AllIndex=32*X6+16*X5+8*X4+4*X3+2*X2+X1+1;
x=eta*(-1*M/2+1:M/2);
Reconstruct=x(AllIndex); 
D_real(Time)=sum((y-Reconstruct).^2)/N % calculate the instant distortion  
end
fprintf('The average distortion is %f.\n',sum(D_real)/Time);
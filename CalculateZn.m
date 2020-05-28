% This m file is used to prepare the Bhattacharyya parameters for the polar
% codes at each level.

clear;
clc;
current_path=cd;
addpath([current_path,'\Construction']); % add the path for the construction of polar codes

n=18;
eta=0.5; % Partition scaling factor $\eta$
sigma_s=3;
D=0.20;
sigma_x=sqrt(sigma_s^2-D);
tilde_sigma=sigma_x*sqrt(D)/sigma_s; % The MMSE re-scaled noise variance for the symmtrized channel
Level=1;
Name=['Pe_BIMod2AWGN_test_D_',num2str(D,'%1.2f'),'_tSigma_',num2str(tilde_sigma,'%1.4f'),'_Lvl_',num2str(Level),];
%load('DiffEntroX.mat'); % Open this when calculating the shaping set Zn
%====================================
%for BIMod2AWGN
[Pary] = BIMod2AWGN2Pary(tilde_sigma/eta/2^(Level-1),16,20);  % Quantize the Mod Lambda/Lambda' partition channl
                                                              
% The function BIMod2AWGN2Pary is based on Z/2Z. So for the 1st level tilde_sigma is scaled by eta; 
% for the 2nd level tilde_sigma is scaled by eta and 1/2
% for the 2nd level tilde_sigma is scaled by eta and 1/4
%.......
% 16 is the quantization level
% 20 is the number of neighbours for each lattice point when calculating the Mod Lambda arised noise

                                                              
%====================================
% The following method is mainly based on Tal and Vardy's paper: How to
% construct polar codes, where we use degrading merging method to control
% the complexity.
Qz_lvl=16;
ChannelTemp=cell(1,1);
ChannelTemp{1}=Pary;
Pe=cell(1,n);
for I=1:n
    fprintf('The polarization level is %d now.\n',I);
    ChannelTT=cell(1,2^I);
    for J=1:2^(I-1)
        
        ChannelT=ChannelTemp{J};
        [PPlus,PMinus]=WPlusMinus(ChannelT); % From a channel W we get W+ and W-.
        [PPlus]=PAdjust(PPlus,Qz_lvl);
        [PMinus]=PAdjust(PMinus,Qz_lvl);
        PePlus=ErrorPary(PPlus);
        PeMinus=ErrorPary(PMinus);
        ChannelTT{2*J-1}=PMinus;
        ChannelTT{2*J}=PPlus;
        Pe{I}=[Pe{I},PeMinus,PePlus];
        
    end
    ChannelTemp=ChannelTT;
    
    % Save the Bhattacharyya parameters 
    
    %if  I>9 &&I<19
            %PeLast=Pe{I};
            %Name_temp=[Name,'_n_',num2str(I),'.mat'];
            %save(Name_temp,'PeLast');
    %end
end

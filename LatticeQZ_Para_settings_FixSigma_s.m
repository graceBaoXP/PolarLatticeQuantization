% The m file is to set the parameter of the polar lattices
% for fixed sigma_s and given target distortion
% we check the distance between Y and Y' in our paper.
% we calculate the flatness factor associated with the partition chain
% and obtain the proportions of the set F I and S for each level

clc;
clear;



eta=0.5;
sigma_s=3;
M=64;
r=log2(M); % number of levels 
D=0.20;    % Target distortion
sigma_x=sqrt(sigma_s^2-D); % reconstruction Gaussian variance
[x,px,Avp]=DiscreteGaussian1D(eta,sigma_x,M); % Calculate the pmf of lattice Gaussian distrition
%======================================================
figure
stem(x,px,'ro');
px=px./(sum(px));
hold on
plot(x,normpdf(x,0,sigma_x),'b--');
hold off
%======================================================
%P(Y') estimation
%======================================================
[YPrimeDens]=MultilevelYPrimeDensityFunc(x,px,sqrt(D));
y=-10:.00001:10;
DensYP=YPrimeDens(y);
DensY=normpdf(y,0,sigma_s);
figure
plot(y,DensYP);
hold on
plot(y,DensY,'-r')
hold off
legend('Density YPrime','Density Y');
VD=sum(abs(DensYP-DensY))*0.0001/2;
text(-4,max(DensY)/4,['Total VD=', num2str(VD)],'FontSize',18);
%=================================================================
%flatness estimation
%=================================================================
tilde_sigma=sigma_x*sqrt(D)/sigma_s;
[y1,ModDensity]=GaussianNoisePDFModN(tilde_sigma,0,eta,30,1);
UDensity=1/eta;
flatfct=max(abs((ModDensity-UDensity)));
figure;
plot(y1,ModDensity);
hold on
plot([y1(1),y1(end)],[UDensity,UDensity],'-r');
hold off
legend('Mod Density','Uniform Density');
text(0,UDensity,['Flatness factor=', num2str(flatfct)],'FontSize',18);
%=====================================================================
AWGNCap=1/2*log2(sigma_s^2/D);
[InpDistri,MarginP,ShapC,JointEntro]=InputDistri(px);
DiffEntroX=diff(JointEntro);
MutualIX=-MarginP(2:end).*log2(MarginP(2:end))-(1-MarginP(2:end)).*log2(1-MarginP(2:end))-DiffEntroX;
MutualIX=[0,MutualIX];
%======================================================================
%obtain X_{\ell} to X_{1:\ell} from the privious level (For shaping)
%======================================================================
Pxary=cell(1,r-1);
for I=1:r-1
   SChan=ShapC{1,I+1};
   MPx=MarginP(1,I+1);
   SChan(1,:)=MPx*SChan(1,:);
   SChan(2,:)=(1-MPx)*SChan(2,:);
   TempChan=zeros(1,length(SChan));
   TempChan(1,:)=sum(SChan,1);
   TempChan(2,:)=min(SChan)./sum(SChan,1);
   Pxary{1,I}=TempChan;
end
%=====================================================================
CapaL=zeros(r,1);
[MIYX]=MutualInfoYXAll(x,px,sqrt(D));
 for J=1:r
    CapaL(J,1)=CapacityEachLevel(J,x,px,sqrt(D),MarginP)-MutualIX(1,J);
 end
 %=============================================================
 %obtain LR function for each level (For the SC algorithm)
 %=============================================================
 LRFunc=cell(1,r);
 [YXOX0,~]=MultilevelYXXDensityFunc([],'0',x,px,sqrt(D),MarginP(1));
 [YXOX1,~]=MultilevelYXXDensityFunc([],'1',x,px,sqrt(D),MarginP(1));
 LRF{1}=@(y) YXOX0(y)./YXOX1(y);
 LRFunc{1,1}=LRF;
 for I=2:r
     TempDens=cell(2^(I-1),1);
     MPtemp=MarginP(1,I);
     for J=1:2^(I-1)
        [YXOX0,~]=MultilevelYXXDensityFunc(dec2bin(J-1,I-1),'0',x,px,sqrt(D),MPtemp);
        [YXOX1,~]=MultilevelYXXDensityFunc(dec2bin(J-1,I-1),'1',x,px,sqrt(D),MPtemp); 
        LRF=@(y) YXOX0(y)./YXOX1(y);
        TempDens{J,1}=LRF;
     end
     LRFunc{1,I}=TempDens;
 end
 %=======================================================================
 %calculate the symmetric capacity of each level
 %=======================================================================
 CapacityLevel=zeros(1,r);
 for LvlIdx=1:r
     sigma_temp=tilde_sigma/(eta*2^(LvlIdx-1));
     if sigma_temp>1
         CapacityLevel(1,LvlIdx)=0;
     elseif sigma_temp<0.05
         CapacityLevel(1,LvlIdx)=1;
     else
     CapacityLevel(1,LvlIdx)=CapacityModN1N2(sigma_temp,1,2,20);
 
     end
 end
 
 %calculate the proportion of I for each level
 CapaL=CapaL';
 
 %calculate the proportion of S for each level
 ShapingRate=CapacityLevel-CapaL;
 ShapingRate=max(ShapingRate,0); % sometimes the shaping rate might be sightly smaller than 0 due to the simulation loss
 ShapingRate=min(ShapingRate,1); % sometimes the shaping rate might be sightly larger than 1 due to the simulation loss
 
Name1=['LRFunc_save_test_D_',num2str(D,'%1.2f'),'_SigmaS_',num2str(sigma_s,'%1.4f'),'.mat'];
Name2=['SymCapaLvl_save_test_D_',num2str(D,'%1.2f'),'_SigmaS_',num2str(sigma_s,'%1.4f'),'.mat'];
save(Name1,'LRFunc');
save(Name2,'CapacityLevel', 'CapaL', 'ShapingRate');
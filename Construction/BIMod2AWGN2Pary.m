function [Pary] = BIMod2AWGN2Pary(sigma,Nmax,Neighbor)
%BIAWGN2PARY 此处显示此函数摘要
%   此处显示详细说明
Cmin=0;
[X,Density0]=GaussianNoisePDFModN(sigma,0,2,Neighbor,1);
[~,Density1]=GaussianNoisePDFModN(sigma,1,2,Neighbor,1);
LR=Density0./Density1;
N=length(X);
HalfN=(N-1)/2;
LRmax=max(LR);
BSCpMin=1/(1+LRmax);
Cmax=1+BSCpMin*log2(BSCpMin)+(1-BSCpMin)*log2(1-BSCpMin);
CPoint=Cmin:Cmax/Nmax:Cmax*(1-1/Nmax);
%================================
%inverse func of h2(p)
x=linspace(eps,0.5,1e6);
y=1+x.*log2(x)+(1-x).*log2(1-x);
BSCp=interp1(y,x,CPoint);
%=======================================
LRneed=(1-BSCp)./BSCp;
xPoint=interp1(LR(1:HalfN+1),X(1:HalfN+1),LRneed);
xPoint=[xPoint,0];
Sample=-Neighbor/2:Neighbor/2;
xxPoint=ones(length(Sample),1)*xPoint+2*Sample'*ones(1,length(xPoint));
p0=normcdf(xxPoint,0,sigma);
p0=diff(p0');
p0=sum(p0,2);
p0=p0';
p1=normcdf(xxPoint,1,sigma);
p1=diff(p1');
p1=sum(p1,2);
p1=p1';


Pary(1,:)=(p0+p1)*2;
Pary(2,:)=p1./(p0+p1);
Pary=Pary(:,end:-1:1);
end


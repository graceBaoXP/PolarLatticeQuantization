function [ SelectIndex,FreezeIndex,ZnSmall] = SelectGoodChannels4Polar(Zn,K)
%This function is used to select the good channels according to the
%calculated Bhattacharyya parameter Zn
% Gn is the initial n*n generator matrix and K is the number of good
% channels we want to use, so K<n
[ZnSmall, Index]=sort(Zn);
SelectIndex=sort(Index(1:K));
FreezeIndex=sort(Index(K+1:end));
ZnSmall=ZnSmall(1:K);
%GnGood=Gn(SelectIndex,:);
end


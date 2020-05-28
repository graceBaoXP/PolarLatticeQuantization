function [SCLayer] = PolarSCDecodePrepare(k)
%POLARSCDECODEPREPARE Summary of this function goes here
%   Detailed explanation goes here
N=2^k;
%SCLayer=ones(N,1);
SCLayer=ones(N+1,1);
SCLayer(1,1)=k;
    for I=2:N
        EndLayer=1;
        Index=I;
    while mod(Index,2)==1
        EndLayer=EndLayer+1;
        Index=(Index+1)/2;
    end
    SCLayer(I,1)=EndLayer;
    end
end


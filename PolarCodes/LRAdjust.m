function [ LR ] = LRAdjust( LR, MaxLR )
%LLRADJUST Summary of this function goes here
%   Detailed explanation goes here
%#codegen
coder.inline('never');

ta= LR>MaxLR;
tb= LR<(MaxLR^(-1));
LR(ta)=MaxLR;
LR(tb)=MaxLR^(-1);
end


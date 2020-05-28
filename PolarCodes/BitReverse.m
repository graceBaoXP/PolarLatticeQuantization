function [ Reversal ] = BitReverse( Normal )
%BITREVERSE Summary of this function goes here
%   Detailed explanation goes here
%#codegen
coder.inline('never');

Reversal =bin2dec(fliplr(dec2bin(Normal-1)))+1;
end


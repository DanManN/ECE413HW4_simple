function [output] = ringmod(constants,inSound,inputFreq,depth)
%RINGMOD applies ring modulator effect to inSound
assert(0 <= depth && depth <= 1)
output = (depth * sin(2*pi*inputFreq*(1:length(inSound))/constants.fs)'.*inSound + inSound)/(1+depth);
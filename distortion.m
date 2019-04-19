function [output]=distortion(constants,inSound,gain,tone)
%DISTORTION applies the specified gain to inSound, then applies clipping
%according to internal parameters and filtering according to the specified
%tone parameter
assert(0 <= tone && tone <= 1)
output = lowpass(sigmf(gain * (inSound+1), [1 gain*0.9])-0.5, tone, 'Steepness', 0.5);
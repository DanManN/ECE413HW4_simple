function [output]=distortion(constants,inSound,gain,tone)
%DISTORTION applies the specified gain to inSound, then applies clipping
%according to internal parameters and filtering according to the specified
%tone parameter
if tone < 0.5
    tone = 0.5
elseif tone >= 1
    tone = 0.999
end
output = highpass(sigmf(gain * (inSound+1), [1 gain*0.9])-0.5, 0.1, 'Steepness', tone);
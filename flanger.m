function [output]=flanger(constants,inSound,depth,delay,width,LFO_Rate)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%    [soundOut]=flanger(constants,inSound,depth,delay,width,LFO_Rate)
%
% This function creates the sound output from the flanger effect
%
% OUTPUTS
%   soundOut = The output sound vector
%
% INPUTS
%   constants   = the constants structure
%   inSound     = The input audio vector
%   depth       = depth setting in seconds
%   delay       = minimum time delay in seconds
%   width       = total variation of the time delay from the minimum to the maximum
%   LFO_Rate    = The frequency of the Low Frequency oscillator in Hz
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

output = zeros(size(inSound));
delay_time = (delay+0.5*width*(cos(2*pi*LFO_Rate*(1:length(inSound))/constants.fs)+1))*constants.fs;
for s = (1+(delay+width)*constants.fs):length(inSound)
    output(floor(s)) = ...
        inSound(floor(s)) + ...
        inSound(floor(s-delay_time(floor(s))))*depth;
end
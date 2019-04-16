function [output] = tremolo(constants,inSound,LFO_type,LFO_rate,lag,depth)
%TREMOLO applies a stereo tremelo effect to inSound by multiplying the
%signal by a low frequency oscillator specified by LFO_type and LFO_rate. 
% depth determines the prevalence of the tremeloed signal in the output,
% and lag determines the delay between the left and right tracks.
assert(0 <= depth && depth <= 1)
switch LFO_type
    case {'sin'}
        output = (depth * sin(2*pi*LFO_rate*(1:length(inSound))/constants.fs+lag)'.*inSound + inSound)/(1+depth);
    case {'triangle'}
        output = (depth * sawtooth(2*pi*LFO_rate*(1:length(inSound))/constants.fs+lag)'.*inSound + inSound)/(1+depth);
    case {'square'}
        output = (depth * sqaure(2*pi*LFO_rate*(1:length(inSound))/constants.fs+lag)'.*inSound + inSound)/(1+depth);
    otherwise
        error("Invalid LFO_type");
end
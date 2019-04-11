function [soundOut,gain] = compressor(constants,inSound,threshold,slope,attack,avg_len)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%    [output,gain] = compressor(constants,inSound,threshold,attack,avg_len)
%
%COMPRESSOR applies variable gain to the inSound vector by limiting the
% level of any audio sample of avg_length with rms power greater than
% threshold according to slope
%
% OUTPUTS
%   soundOut    = The output sound vector
%   gain        = The vector of gains applied to inSound to create soundOut
%
% INPUTS
%   constants   = the constants structure
%   inSound     = The input audio vector
%   threshold   = The level setting to switch between the two gain settings
%   slope       = The ratio of input to gain to apply to the signal past
%   the threshold
%   attack      = time over which the gain changes
%   avg_len     = amount of time to average over for the power measurement

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
assert(slope<=1 && threshold <= 1 && threshold >= 0)

b = threshold - slope * threshold; % b in y = mx + b line above threshold
step = floor(attack*constants.fs);

soundOut = [inSound; zeros(step-rem(length(inSound),step)+1,size(inSound,2))];
gain = zeros((length(soundOut)-1)/(step),1);
for samples = 1:step:length(inSound)-step+1
    pow = sum(rms(soundOut(max(1,samples-avg_len):samples,:)))+0.0001;
    limit = slope*pow+b;
    gain((step+samples-1)/(step)) = (pow>threshold)*(limit/pow) + (pow<=threshold);
    soundOut(samples:samples+step,:) = soundOut(samples:samples+step,:) * gain((step+samples-1)/(step));
end


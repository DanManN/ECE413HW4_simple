function [output]=delay(constants,inSound,depth,delay_time,feedback)
%DELAY applies a delay effect to inSound which is delayed by delay_time 
% then added to the original signal according to depth and passed back as
% feedback with the feedback gain specified
output = zeros(size(inSound));
for frame = 1+2*delay_time*constants.fs:delay_time*constants.fs:length(inSound)
    output(frame-delay_time*constants.fs:frame) = ...
        inSound(frame-delay_time*constants.fs:frame) + ...
        inSound(frame-2*delay_time*constants.fs:frame-delay_time*constants.fs)*depth + ...
        output(frame-2*delay_time*constants.fs:frame-delay_time*constants.fs)*feedback;
end
       

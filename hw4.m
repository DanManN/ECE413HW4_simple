%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SCRIPT
%    hw4
%
% NAME: _________________
%
% This script runs questions 1 through 7 of the HW4 from ECE313:Music and
% Engineering.
%
% This script was adapted from hw1 recevied in 2012
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Setup
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all
clear functions
clear variables
dbstop if error

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Constants
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
constants.fs=44100;                     % Sampling rate in samples per second
STDOUT=1;                               % Define the standard output stream
STDERR=2;                               % Define the standard error stream

%% Sound Samples
% claims to be guitar
% source: http://www.traditionalmusic.co.uk/scales/musical-scales.htm
[pianoSound, fsg] = audioread('piano_C_major.wav');

% sax riff - should be good for compressor
% source: http://www.freesound.org/people/simondsouza/sounds/763
[saxSound, fss] = audioread('sax_riff.wav');

% a fairly clean guitar riff
% http://www.freesound.org/people/ERH/sounds/69949/
[cleanGuitarSound, fsag] = audioread('guitar_riff_acoustic.wav');

% Harmony central drums (just use the first half)
[drumSound, fsd] = audioread('drums.wav');
L = size(drumSound,1);
drumSound = drumSound(1:round(L/2), :);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Common Values 
% may work for some examples, but not all
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
depth=75;
LFO_type='sin';
LFO_rate=0.5;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Question 1 - Compressor
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
threshold = 0.05; 
attack = 0.005;
avg_len = 1024*4;
slope = 0.3; 
[output,gain]=compressor(constants,saxSound,threshold,slope,attack,avg_len);

soundsc(saxSound,constants.fs)
disp('Playing the Compressor input')
pause
soundsc(output,constants.fs)
disp('Playing the Compressor Output');
pause
%audiowrite(output,fss,'output_compressor.wav');

%% PLOTS for Question 1d
t = linspace(0,length(output)/constants.fs,length(output));
figure
subplot(2,1,1)
plot(t(1:length(saxSound)),saxSound,'b',t,output,'r')
title('Sax Sound (before=blue, after=red)')
xlabel('time (sec)')
ylabel('Amplitude')
axis tight
subplot(2,1,2)
t = linspace(0,length(output)/constants.fs,length(gain));
plot(t,10*log10(gain))
xlabel('time (sec)')
ylabel('Gain (dB)')
axis tight

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Question 2 - Ring Modulator
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
constants.fs = fsg;
% the input frequency is fairly arbitrary, but should be about an order of
% magnitude higher than the input frequencies to produce a
% consistent-sounding effect
inputFreq = 2500;
depth = 0.5;
[output]=ringmod(constants,pianoSound,inputFreq,depth);

soundsc(pianoSound,constants.fs)
disp('Playing the RingMod input')
pause
soundsc(output,constants.fs)
disp('Playing the RingMod Output');
pause
%audiowrite(output,fsg,'output_ringmod.wav');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Question 3 - Stereo Tremolo
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
LFO_type = 'sin';
LFO_rate = 5;
% lag is specified in number of samples
% the lag becomes very noticeable one the difference is about 1/10 sec
lag = constants.fs/4;
depth = 0.9;
[output]=tremolo(constants,pianoSound,LFO_type,LFO_rate,lag,depth);

soundsc(pianoSound,constants.fs)
disp('Playing the Tremolo input')
pause
soundsc(output,constants.fs)
disp('Playing the Tremolo Output');
pause
%audiowrite(output,fsg,'output_tremelo.wav');



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Question 4 - Distortion
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
gain = 20;
inSound = cleanGuitarSound(:,1);
tone = 0.5;
[output]=distortion(constants,inSound,gain,tone);

soundsc(inSound,constants.fs)
disp('Playing the Distortion input')
pause
soundsc(output,constants.fs)
disp('Playing the Distortion Output');
pause
%audiowrite(output,fsag,'output_distortion.wav');

%% look at what distortion does to the spectrum
L = 10000;
n = 1:L;
sinSound = sin(2*pi*440*(n/fsag));
[output]=distortion(constants,sinSound,gain,tone);

figure
subplot(2,1,1)
spectrogram(sinSound)
title('Pure Sin Tone')
subplot(2,1,2)
spectrogram(output)
title('Distortion')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Question 5 - Delay
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% slapback settings
inSound = cleanGuitarSound(:,1);
delay_time = 0.08; % in seconds
depth = 0.8;
feedback = 0;
[output]=delay(constants,inSound,depth,delay_time,feedback);

soundsc(inSound,constants.fs)
disp('Playing the Slapback input')
pause
soundsc(output,constants.fs)
disp('Playing the Slapback Output');
pause
%audiowrite(output,fsag,'output_slapback.wav');


%% cavern echo settings
inSound = pianoSound;
delay_time = 0.4;
depth = 0.8;
feedback = 0.7;
[output]=delay(constants,inSound,depth,delay_time,feedback);

soundsc(inSound,constants.fs)
disp('Playing the cavern input')
pause
soundsc(output,constants.fs)
disp('Playing the cavern Output');
pause
%audiowrite(output,fsh,'output_cave.wav');


%% delay (to the beat) settings
inSound = pianoSound;
delay_time = 0.30;
depth = 1;
feedback = 1;
[output]=delay(constants,inSound,depth,delay_time,feedback);

soundsc(inSound,constants.fs)
disp('Playing the delayed on the beat input')
pause
soundsc(output,constants.fs)
disp('Playing the delayed on the beat Output');
pause
%audiowrite(output,fsg,'output_beatdelay.wav');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Question 6 - Flanger
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%inSound = drumSound;
%constants.fs = fsd;
inSound = pianoSound(:,1);
constants.fs = fsg;
depth = 0.8;
delay = .001;   
width = .002;   
LFO_Rate = 0.5;   
[output]=flanger(constants,inSound,depth,delay,width,LFO_Rate);

soundsc(inSound,constants.fs)
disp('Playing the Flanger input')
pause
soundsc(output,constants.fs)
disp('Playing the Flanger Output');
pause
%audiowrite(output,fsd,'output_flanger.wav');



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Question 7 - Chorus
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
inSound = pianoSound(:,1);
constants.fs = fsg;
depth = 0.9;
delay = .03;   
width = 0.1;   
LFO_Rate = 0.5; % irrelevant if width = 0
[output]=flanger(constants,inSound,depth,delay,width,LFO_Rate);

soundsc(inSound,constants.fs)
disp('Playing the Chorus input')
pause
soundsc(output,constants.fs)
disp('Playing the Chorus Output');
pause
%audiowrite(output,fsg,'output_chorus.wav');



%% Display filter bank logarithm energies:


%% Code:

addpath('Feature_operator');

[signal,Fs]=audioread('ba_01_S1.wav');

logfb = (msf_logfb(signal,Fs,'nfilt',40))';

pcolor(logfb);xlabel('Frames');ylabel('Filters'); c=colorbar;
 c.Label.String = 'Energies(dB)';
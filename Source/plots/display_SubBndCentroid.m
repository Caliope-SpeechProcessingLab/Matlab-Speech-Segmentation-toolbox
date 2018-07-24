%% Display mel-spectral sub-band centroids:

%% Code:

addpath('Feature_operator');

[signal,Fs]=audioread('ba_01_S1.wav');

ssc = (msf_ssc(signal,Fs,'nfilt',40))';

pcolor(ssc);xlabel('Frames');ylabel('Filters'); c=colorbar;
 c.Label.String = 'Energies(dB)';
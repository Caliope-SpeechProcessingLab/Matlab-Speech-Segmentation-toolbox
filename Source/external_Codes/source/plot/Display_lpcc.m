%Display Linear prediction cepstral coefficients:


%% Code:

addpath('Feature_operator');

[signal,Fs]=audioread('ba_01_S1.wav');
lpcc = (msf_lpcc(signal,Fs,'order',10))';

pcolor(lpcc);xlabel('Frames');ylabel('Ordinary number of Coefficient'); c=colorbar;
 c.Label.String = 'Coeficient value';
%Display Linear prediction cepstral coefficients:


%% Code:

addpath('Feature_operator');

[signal,Fs]=audioread('ba_01_S1.wav');
lpcc = (msf_lpcc(signal,Fs,'order',10))';

figure; subplot(2,1,1);
    pcolor(lpcc);
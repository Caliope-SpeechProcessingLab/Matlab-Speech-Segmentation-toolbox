%% Display Line spectral frequencies vs LPC spectrum vs fft sectrum:

%% Code:

addpath('Feature_operator');

[signal,Fs]=audioread('ba_01_S1.wav');

% ESTA EN PROCESO....


lsf= (msf_lsf(signal,Fs,'order',10));
lsf=lsf*((Fs/2)/pi); %pasamos de unidades pi a frecuencia normal
figure; plot(pSd);  hold on;plot(H); hold on; %plot();

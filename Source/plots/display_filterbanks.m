
addpath('Feature_operator');

nfilt=26;
Fs=48000;

filters_bark=msf_Barkfilterbank(nfilt,Fs,0,Fs/2,512);
filters_mel=msf_filterbank(nfilt,Fs,0,Fs/2,512);

figure; subplot(2,1,1);

for i=1:nfilt
    plot(filters_mel(i,:));hold on;
end
title('Mel-spaced filter banks');

subplot(2,1,2);

for i=1:nfilt
    plot(filters_bark(i,:));hold on;
end
title('Bark-spaced filter bank');
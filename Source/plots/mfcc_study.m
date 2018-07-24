% Fixed frame segmentation created by msf_framesig function
%
% msf_framesig function copyrigth:
%     The MIT License (MIT)
%     Copyright (c) 2013 James Lyons
 

% msf_powspec function copyrigth:
%     The MIT License (MIT)
%     Copyright (c) 2013 James Lyons

%Rest of code copyrigth:
% Version: 0.0.1 
% Copyright 11-06-2018 
% Author: Salvador Florido Llorens   Telecomunication department  (University of Malaga)
% Reviewers: Ignacio Moreno Torres   Spanish department (University of Malaga)
%            Enrique Nava Baro       Telecomunication  department (University of Malaga)

%% Section 1: Simple visualization in matrix.

addpath('../features');

% Signal:
[signal,Fs]=audioread('../../data/audio/JASA/Q/so_01_S1.wav');
% %Preemphasis
% z=tf('z'); % declaramos 'z'
% Pz=(1-0.98*z^-1); 
% %usamos la función impulse para tener la respuesta impulso del filtro
% RespImp=impulse(Pz);
% % convolucionamos la respuesta impulso obteniendo con nuestra señal
% senalFiltrada=conv(RespImp,signal);
% % cogemos solo las muestras de la señal, ya que la convolución añade muestras
% signal=senalFiltrada(1:length(signal));

% mel-frequency cepstral coefficient: default win_len:0.025, win_step:0.01
%Praat: minimum mel: 100 mel
%Praat: maximum mel: 4000 mel


nfft=2^nextpow2(length(signal));

lowmel=100;
highmel=4000;
hzMin = 700*(10.^(lowmel./2595) -1);
hzMax=700*(10.^(highmel./2595) -1);
%mel = 2595*log10(1+hz./700);
[mfccs,indices] = msf_mfcc(signal,Fs,'winlen',0.025,'winstep',0.01,'lowfreq',hzMin','highfreq',hzMax,'nfilt',39,'ncep',30,'nfft',512);%2048
mfccs=mfccs';
figure; 

pcolor(mfccs); colormap(jet);

% spectrumPraat=praat2matlab('../so_01_S1Spectrum','../spectrumPraat.mat');
% p=10*log10(abs(spectrumPraat).^2);
% subplot(2,1,2),plot(p);
%% Section 2: Frame by frame visualization:

addpath('../Feature_operator');

% Signal:
[signal,Fs]=audioread('../../data/audio/JASA/Q/so_01_S1.wav');
%Preemphasis
z=tf('z'); % declaramos 'z'
Pz=(1-0.98*z^-1); 
%usamos la función impulse para tener la respuesta impulso del filtro
RespImp=impulse(Pz);
% convolucionamos la respuesta impulso obteniendo con nuestra señal
senalFiltrada=conv(RespImp,signal);
% cogemos solo las muestras de la señal, ya que la convolución añade muestras
% signal=senalFiltrada(1:length(senal));
% 
% hzMin = 700*(10.^(100./2595) -1);
% hzMax=700*(10.^(4000./2595) -1);
% %mel = 2595*log10(1+hz./700);
% mfccs = (msf_mfcc(signal,48000,'lowfreq',hzMin','highfreq',hzMax,'nfilt',39,'ncep',13))';
% 












  
  
  
  
  
  
  
  
  
  
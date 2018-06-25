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

%% Code:

addpath('Feature_operator');

% Signal:
[signal,Fs]=audioread('ba_01_S1.wav');

% mel-frequency cepstral coefficient: default win_len:0.025, win_step:0.01
 mfccs = (msf_mfcc(signal,48000,'nfilt',40,'ncep',12))';
 
 pcolor(mfccs);ylabel('Ordinary number of cepstral coefficients');xlabel('Frames'); c=colorbar;
 c.Label.String = 'Cepstral coefficient values';
function display_spectrogram(signal,Fs,varargin)

%% Display spectrogram:

% Fixed frame segmentation created by msf_framesig function
%
% msf_framesig function copyrigth:
%     The MIT License (MIT)
%     Copyright (c) 2013 James Lyons


%  Spectrogram data created by msf_powspec function
%
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

p = inputParser;
addOptional(p,'winlen',0.025,@isnumeric);
addOptional(p,'winstep',0.01,@isnumeric);
addOptional(p,'nfft',512,@isnumeric);
addOptional(p,'variable',false,@islogical);
parse(p,varargin{:});
in = p.Results;


nfft=2^nextpow2(length(signal));

% msf_powspec function convert seg to samples. And uses a hamming window by
% default.
[Sx,indices] = msf_powspec(signal,Fs,'winlen',in.winlen,'winstep',in.winstep,'nfft',nfft,'variable',true);

%Spectrogram visualization:
fmax=input('Maximum frequency: ');
fmax=ceil((fmax*nfft)/Fs);
stft=Sx(:,1:fmax);
stft_log=log10(stft(:,1:fmax));
stft_log=stft_log.';

t=(1:length(signal))./Fs;

f=((1:fmax).*(Fs/nfft))';
t_frames=(indices(:,1))./Fs;

figure; subplot(2,1,1);plot(t,signal); subplot(2,1,2);pcolor((t_frames+(in.winlen/2)),f,stft_log);
axis xy;
colormap(flipud(gray(512))); title('Espectrograma');
shading interp;
h=gca;
h.XLim=[0 length(signal)/Fs];

end


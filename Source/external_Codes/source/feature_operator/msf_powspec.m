%% msf_powspec - Compute power spectrum of audio frames
%
%   function pspec = msf_powspec(speech,fs,varargin)
%
% given a speech signal, splits it into frames and computes the power spectrum for each frame.
%
% * |speech| - the input speech signal, vector of speech samples
% * |fs| - the sample rate of 'speech', integer
%
% optional arguments supported include the following 'name', value pairs 
% from the 3rd argument on:
%
% * |'winlen'| - length of window in seconds. Default: 0.025 (25 milliseconds)
% * |'winstep'| - step between successive windows in seconds. Default: 0.01 (10 milliseconds)
% * |'nfft'| - the FFT size to use. Default: 512
%
% Example usage:
%
%   lpcs = msf_powspec(signal,16000,'winlen',0.5);
%
% The MIT License (MIT)
%
% Copyright (c) 2013 James Lyons


function [pspec,indices] = msf_powspec(speech,fs,varargin)
    p = inputParser;   
    addOptional(p,'winlen',0.025,@isnumeric); 
    addOptional(p,'winstep',0.01,@isnumeric);
    addOptional(p,'nfft',512,@isnumeric); 
    addOptional(p,'variable',false,@islogical); 
    parse(p,varargin{:});
    in = p.Results;
       
        [frames,indices] = msf_framesig(speech,in.winlen*fs,in.winstep*fs,@(x)gausswin(x),in.variable,fs);
        if isa(frames,'cell') %Cell array
            nSeg=length(indices(:,1));
            for i=1:nSeg
                frame=(frames{1,i})';
                pspec(i,1:in.nfft) = 1/(length(frame)*fs)*abs(fft(frame,in.nfft,2)).^2;
                pspec = pspec(:,1:in.nfft/2);
            end
        else
            pspec = 1/(in.winlen*fs)*abs(fft(frames,in.nfft,2)).^2;
            pspec = pspec(:,1:in.nfft/2);
        end
    
end
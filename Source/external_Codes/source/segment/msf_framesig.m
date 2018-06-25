%% msf_framesig - break a signal into frames
%
%   function win_frames = msf_framesig(signal, frame_len, frame_step, winfunc)
%
% Takes a 1 by N signal, and breaks it up into frames. Each frame starts
% _frame_step_ samples after the start of the previous frame. Each frame is
% windowed by wintype.
%
% - to specify window, use e.g. @hamming, @(x)chebwin(x,30), @(x)ones(x,1), etc.
%
% * |signal| - the input signal, vector of audio samples
% * |frame_len| - length of window in samples.
% * |frame_step| - step between successive windows in seconds. In samples.
% * |winfunc| - A function to be applied to each window.
%
% Example usage with hamming window:
%
%   frames = msf_framesig(speech, winlen*fs, winstep*fs, @(x)hamming(x));
%
% 
% The MIT License (MIT)
%
% Copyright (c) 2013 James Lyons

 
function [win_frames,indices] = msf_framesig(signal, frame_len, frame_step, winfunc,var,fs) 

if var==1 %Phased
         %indices es boundaries
        [indices,Fs_S,NF,win_frames]=phased_segmenter_01(signal,fs);  
else %Fixed
    if size(signal,1) ~= 1
        signal = signal';
    end
    
    signal_len = length(signal);
    if signal_len <= frame_len  % if very short frame, pad it to frame_len
        num_frames = 1;
    else
        num_frames = 1 + ceil((signal_len - frame_len)/frame_step);
    end
    padded_len = (num_frames-1)*frame_step + frame_len;
    % make sure signal is exactly divisible into N frames
    pad_signal = [signal, zeros(1,padded_len - signal_len)];
    
    %Indices tiene por cada columna los indices de los frames.
    % build array of indices
    indices = repmat(1:frame_len, num_frames, 1) + ...
        repmat((0: frame_step: num_frames*frame_step-1)', 1, frame_len);
    frames = pad_signal(indices);
    
    win = repmat(winfunc(frame_len)', size(frames, 1), 1);
    % apply window
    win_frames = frames .* win;
end

end
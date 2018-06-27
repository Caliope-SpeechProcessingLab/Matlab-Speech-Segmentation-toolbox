%% Code:

%   function fbank = msf_Barkfilterbank(nfilt,fs,lowfreq,highfreq,nfft)
%
% returns a mel-spaced filterbank for use with filterbank energies, mfccs, sscs etc.
%
% * |nfilt| - the number filterbanks to use. 
% * |fs| - the sample rate of 'speech', integer
% * |lowfreq| - the lowest filterbank edge. In Hz.
% * |highfreq| - the highest filterbank edge. In Hz.
% * |nfft| - the FFT size to use.
%
% Example usage:
%
%   lpcs = msf_Barkfilterbank(26,16000,0,16000,512);

function fbank = msf_Barkfilterbank(nfilt,fs,lowfreq,highfreq,nfft)

% compute points evenly spaced in mels
    lowBark = hz2bark(lowfreq);
    highBark = hz2bark(highfreq);
    barkpoints = linspace(lowBark,highBark,nfilt+2);
    % our points are in Hz, but we use fft bins, so we have to convert from Hz to fft bin number
    bin = 1+floor((nfft-1)*bark2hz(barkpoints)/fs);
    
    fbank = zeros(nfilt,nfft/2);
    for j = 1:nfilt
        for i = bin(j):bin(j+1)
            fbank(j,i) = (i - bin(j))/(bin(j+1)-bin(j));
        end
        for i = bin(j+1):bin(j+2)
            fbank(j,i) = (bin(j+2)-i)/(bin(j+2)-bin(j+1));
        end
    end

end


function hz = bark2hz(bark)
    hz = (600.*(exp(bark./3)-1))./(2.*exp(bark./6));
end

function bark = hz2bark(hz)
    bark = 6*log((hz/600) + sqrt((hz/600).^2 + 1));
end
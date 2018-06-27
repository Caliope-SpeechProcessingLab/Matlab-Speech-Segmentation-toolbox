%% Code

nfilt=26;
fs=48000;
lowfreq=0;
highfreq=fs/2;
nfft=512;

lowbark = hz2bark(lowfreq);
highbark = hz2bark(highfreq);
barkpoints = linspace(lowbark,highbark,nfilt+2);

fbank = zeros(nfilt,nfft/2);

a1=0.5;
a2=-0.5;
b1=1.3;
b2=-2.5;

coeffs=[a1 a2 b1 b2];
hz_coeffs = bark2hz(coeffs);
hz_fc=bark2hz(barkpoints);
% for i=1:nfilt+2
%     a2=barkpoint(i)-2.5; %Valor filtro 10^...
%     b1=barkpoint(i)+0.5; %Valor filtro 0
%     b2=barkpoint(i)-0.5; %Valor filtro 0
%     a1=barkpoint(i)+1.3;   %Valor filtro 10^...
% end
% bin = 1+floor((nfft-1)*bark2hz(barkpoints)/fs);
for j=1:nfilt
    
    fbank(j,i)=
end

% our points are in Hz, but we use fft bins, so we have to convert from Hz to fft bin number








function hz = bark2hz(bark)
    hz = (600.*(exp(bark./3)-1))./(2.*exp(bark./6));
end

function bark = hz2bark(hz)
    bark = 6*log((hz/600) + sqrt((hz/600).^2 + 1));
end
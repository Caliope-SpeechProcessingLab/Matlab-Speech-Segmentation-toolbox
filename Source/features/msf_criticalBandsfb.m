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

% for i=1:nfilt+2
%     a2=barkpoint(i)-2.5; %Valor filtro 10^...
%     b1=barkpoint(i)+0.5; %Valor filtro 0
%     b2=barkpoint(i)-0.5; %Valor filtro 0
%     a1=barkpoint(i)+1.3;   %Valor filtro 10^...
% end
 
 fB_l=zeros(1,nfilt+2);
 fB_h=zeros(1,nfilt+2);
 fB_05=zeros(1,nfilt+2);
 fB_n05=zeros(1,nfilt+2);
for j=1:nfilt+2
   fB_l(1,j)=barkpoints(j)-2.5;
   fB_h(1,j)=barkpoints(j)+1.3;
   fB_05(1,j)=barkpoints(j)+0.5;
   fB_n05(1,j)=barkpoints(j)-0.5;
end

hz_fc=bark2hz(barkpoints);
bin = 1+floor((nfft-1)*hz_fc/fs);

hzL=bark2hz(fB_l);
hzH=bark2hz(fB_h);
hz05=bark2hz(fB_05);
hzn05=bark2hz(fB_n05);

bin_l = 1+floor((nfft-1)*hzL/fs);
bin_h = 1+floor((nfft-1)*hzH/fs);
bin_05 = 1+floor((nfft-1)*hz05/fs);
bin_n05 = 1+floor((nfft-1)*hzn05/fs);

i1=find(bin_l>0 && bin_l<256);
bin_l=bin_l(i1);
i2=find(bin_h>0 && bin_h<256);
bin_h=bin_l(i2);
i3=find(bin_05>0 && bin_05<256);
bin_05=bin_05(i3);
i4=find(bin_n05>0 && bin_n05<256);
bin_n05=bin_n05(i4);
% for j=1:nfilt+2
%    
% end

       
% our points are in Hz, but we use fft bins, so we have to convert from Hz to fft bin number








function hz = bark2hz(bark)
    hz = (600.*(exp(bark./3)-1))./(2.*exp(bark./6));
end

function bark = hz2bark(hz)
    bark = 6*log((hz/600) + sqrt((hz/600).^2 + 1));
end
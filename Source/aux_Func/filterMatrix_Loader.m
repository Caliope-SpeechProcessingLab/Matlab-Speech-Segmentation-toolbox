function [filtros,N]=filterMatrix_Loader(Fs)
% 
% FUNCTION DESCRIPTION:
%
% [filtros,N]=filterMatrix_Loader(Fs)==> Coefficient filter Matrix creator
% This function generates a cell array, in which each cell contains a
% vector of filter coefficients. Those filter are created with a sample
% rate Fs. Each filter is a band pass variable bandwitdh, according with
% critical bands bio-acoustic theory.
%
%The frequency band of each filter are determines by 2 arrays:
% 
%   -lowcut: having all lowest bandpass frequency values.
%   -highcut: having all highest bandpass frequency values.
% 
%  nERB: are the number of bands are going to be computed.
%
% For this version, all filters have this specifications:
% 
% Passband attenuation (A): 2 dB
% First Stopband attenuation: 40 dB
% Second Stopband atttenuation: 40 dB
% 
% Version: 0.1   Date:01/06/2018
% Copyrigth: Salvador Florido Llorens

%%
lowcut = [250 421 505 607 720 877 1053 1266 1521 1827 2196 2638 3170 3809 4577];
highcut=[420 504 606 719 876 1052 1265 1520 1826 2195 2637 3169 3808 4576 7700];
nERB=length(lowcut); %Number of critical bands

if length(lowcut)~=length(highcut)
   fprintf(['WARNING you cannot have different lowcut highcut number of elements']);
end

% 
% Fp11=lowcut(1);  Fst11 = Fp11-60;
% Fp22=highcut(1); Fst22 = Fp22+60;

% Hf = fdesign.bandpass('Fst1,Fp1,Fp2,Fst2,Ast1,Ap,Ast2',Fst11,Fp11,Fp22,Fst22,Ast1,Ap,Ast2,Fs);
% H1= design(Hf,'equiripple','minphase',true);
% b1= H1.Numerator;
% N=length(H1.Numerator);
Ap=2;
Ast1=40;
Ast2=40;
filtros=cell(1,15);


for i=1:nERB
    
    
    Fp1=lowcut(i);  
    Fp2=highcut(i); 
      
    Fst1 = Fp1*0.80;
    Fst2 = Fp2*1.2;
    
    if Fst2 > Fs/2
        fprintf(['WARNING filter number ',num2str(i),' exceeds half sample rate, it is update to Fs/2\n']);
        Fst2=8000;
    end
    
    Hf = fdesign.bandpass('Fst1,Fp1,Fp2,Fst2,Ast1,Ap,Ast2',Fst1,Fp1,Fp2,Fst2,Ast1,Ap,Ast2,Fs);
    H= design(Hf,'equiripple','minphase',true);
    coeffs= H.Numerator;
    N=length(H.Numerator);
    
    filtros{i}=coeffs;
    fprintf('%s\n', ['Filtro ',num2str(i),' y N: ',num2str(N)]);
    
end
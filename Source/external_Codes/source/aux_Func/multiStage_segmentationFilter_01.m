function [x_filtered,NT]=multiStage_segmentationFilter(x,Fs,newFs)

%Fs has to be 16000Hz and the Fs of x has to be 16000Hz
%We want to convert a 16000Hz signal to a 64Hz signal.

%      16000Hz --------> 64Hz

%Fs=16000Hz
%newFs=64Hz


%  Fs/newFs=D;  16000Hz/64Hz=250;

%D=250;   D=D1xD2xD3xD4
%D1=2; D2=5; D3=5; D4=5;
%newFs1=16000/2=8000Hz
%newFs2=8000/5=1600Hz
%newFs3=1600/5=320Hz
%newFs4=320/5=64Hz



D=Fs/newFs;
D1=2; D2=5; D3=5;D4=5;


newFs1=Fs/D1; %8000Hz
newFs2=newFs1/D2; %1600Hz
newFs3=newFs2/D3; %320Hz
newFs4=newFs3/D4; %64Hz




%% 1º Stage: Fs es 16000Hz to 8000Hz

%Create anti-aliasing filter with fc=newFs/2:

Fst_1=newFs1/2; %4000 Hz 
Fp_1=Fst_1-3989; %Respetando hasta 11 Hz
Ap=3;
Ast=40;
Hf1 = fdesign.lowpass('Fp,Fst,Ap,Ast',Fp_1,Fst_1,Ap,Ast,Fs);
H1=design(Hf1,'equiripple','minphase',true);
N1=length(H1.Numerator);
%fvtool(H1);

x1=filter(H1.Numerator,1,x); %Señal x1 filtrada para la 1º decimacion.

%Decimation:
x1d=resample(x1,1,2); %decimation by a factor of 2.



%% 2º stage: Fs es 8000Hz to 1600Hz

%Create anti-aliasing filter with fc=newFs/2:


Fst_2=newFs2/2; %800Hz
Fp_2=Fst_2-789; %Respetando hasta 11 Hz
Ap=3;
Ast=40;
Hf2 = fdesign.lowpass('Fp,Fst,Ap,Ast',Fp_2,Fst_2,Ap,Ast,newFs1);
H2=design(Hf2,'equiripple','minphase',true);
N2=length(H2.Numerator);
%fvtool(H2);

x2=filter(H2.Numerator,1,x1d); %Señal x1 filtrada para la 2º decimacion.

%Decimation:

x2d=resample(x2,1,5); %decimation by a factor of 5.


%% 3º stage: Fs es 1600Hz to 320Hz


Fst_3=newFs3/2; %160Hz
Fp_3=Fst_3-149;   %Respetando hasta 11 Hz
Ap=3;
Ast=40;
Hf3 = fdesign.lowpass('Fp,Fst,Ap,Ast',Fp_3,Fst_3,Ap,Ast,newFs2);
H3=design(Hf3,'equiripple','minphase',true);
N3=length(H3.Numerator);
%fvtool(H3);

x3=filter(H3.Numerator,1,x2d); %Señal x1 filtrada para la 3º decimacion.

%Decimation:

x3d=resample(x3,1,5); %decimation by a factor of 5.

%% 4º Stage: Fs es 320Hz to 64Hz

Fst_4=newFs4/2; %32Hz
Fp_4=Fst_4-21;   %Respetando hasta 11 Hz
Ap=3;
Ast=40;
Hf4 = fdesign.lowpass('Fp,Fst,Ap,Ast',Fp_4,Fst_4,Ap,Ast,newFs3);
H4=design(Hf4,'equiripple','minphase',true);
N4=length(H4.Numerator);
%fvtool(H4);

x4=filter(H4.Numerator,1,x3d); %Señal x1 filtrada para la 3º decimacion.

%Decimation:

x4d=resample(x4,1,5); %decimation by a factor of 5.


%% Theta band Filtering: 4-10Hz. In a 64Hz signal

Fp1=4;  Fst1 = Fp1-3;
Fp2=10; Fst2 = Fp2+10;
Ap=6;
Ast1=20;
Ast2=40;
Hf = fdesign.bandpass('Fst1,Fp1,Fp2,Fst2,Ast1,Ap,Ast2',Fst1,Fp1,Fp2,Fst2,Ast1,Ap,Ast2,newFs4);

H_Theta= design(Hf,'equiripple','minphase',true);
N_theta=length(H_Theta.Numerator);
%fvtool(H_Theta);

x_filtered=filter(H_Theta.Numerator,1,x4d); %4-stage filtered signal of 64Hz theta bandpass filtered.

NT=N1+N2+N3+N4+N_theta;














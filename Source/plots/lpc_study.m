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
signal=senalFiltrada(1:length(signal));

%Linear prediction coefficient: default win_len:0.025, win_step:0.01

order=12;

lpc = (msf_lpc(signal,Fs,'order',order))';
figure; subplot(2,1,1); 
pcolor(lpc);ylabel('Ordinary number of LP coefficients');colormap(flipud(gray));xlabel('Frames');ylabel('Ordinary number of LP Coefficient'); c=colorbar;
c.Label.String = 'Coeficient value'; title('Matlab LPC: wl 0.025 seg y wS 0.01 seg');

subplot(2,1,2);
load ../lpcPraat;
pcolor(lpcPraat); xlabel('Frames');ylabel('Ordinary number of LP Coefficient');colormap(flipud(gray)); c=colorbar;
c.Label.String = 'Coeficient value'; title('Praat LPC: wL 0.025 seg y wS 0.01 seg');
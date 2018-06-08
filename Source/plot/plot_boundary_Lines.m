function h=plot_boundary_Lines(x,boundaries,Fs)

%% Main code:


%Ploting orignal signal:
t=(1:length(x))/Fs;
figure; plot(t,x,'k'); hold on;

%Getting minimum value of the original signal, and the ending point of each
%segment:
minSignal=min(x);
nSeg=length(boundaries(:,2));
endings=boundaries(:,2); %array con todos los finales de segmento.
endings=endings./Fs; %De muestras a segundos

%Configuring the plot frame.
ax=gca;
ylims=ax.YLim;  
ax.YLim=[(minSignal+minSignal*0.8) ylims(2)];

%Plotting vertical lines for each ending segment point.
for i=1:nSeg
    yLine=minSignal:0.01:ylims(2);
    xLine= repelem(endings(i),length(yLine));
    h=plot(xLine,yLine,'b','LineStyle','--','LineWidth',2); hold on;
end







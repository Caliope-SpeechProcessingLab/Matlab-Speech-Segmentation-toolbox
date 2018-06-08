function h=plot_boundary_LinesE(x,boundaries,Fs,ecDist)

%% Main code:


%To plot first vertical lines:
h=plot_boundary_Lines(x, boundaries, Fs);

%Endings of each segment.
endings=boundaries(:,2);
nSeg=length(endings);
%Minimum value of the original speech sound.
minValueX=min(x);
%Mean of euclidean distance vector.
me=mean(ecDist);
%Standard deviation of euclidean distance vector.
stde=std(ecDist);

%Loop that plot each z-score euclidean distance value in each
%ending segment point, except last one.
for i=1:nSeg-1
    x_ax=(endings(i)/Fs);
    y_ax=minValueX+minValueX*0.1;
    z_score=(ecDist(i)-me)/stde;
    z_score=round(z_score,2);
    v=text(x_ax,y_ax,num2str(z_score)); v.HorizontalAlignment='center';v.FontWeight='bold'; hold on;
end
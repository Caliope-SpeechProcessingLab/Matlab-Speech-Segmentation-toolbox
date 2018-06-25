%% Desciption:

% Code:

function display_frames(signal,Fs,indices,filename)

t1=(1:length(signal))./Fs;
nframes=length(indices(:,1));
figure; h1=subplot(2,1,1); 
h2=subplot(2,1,2);
plot(h1,t1,signal);hold(h1,'on');
title(h1,['Original signal1 ',filename]); xlabel(h1,'tiempo(s)');ylabel(h1,'Amplitud(Pa)')
for iframe=1:nframes-1
    tframe=indices(iframe,:)./Fs;
    plot(h2,tframe,signal(indices(iframe,:)));
    h3=plot(h1,tframe,signal(indices(iframe,:)),'r','LineWidth',1);
    title(h2,['Frame ',num2str(iframe)]);xlabel('tiempo(s)');ylabel('Amplitud(Pa)');
    drawnow
    k=waitforbuttonpress;
    if k==0 %mouse button click
        break;
    end
    set(h3,'Visible','off')
end
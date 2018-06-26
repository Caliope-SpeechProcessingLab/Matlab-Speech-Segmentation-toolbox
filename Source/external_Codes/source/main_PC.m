%% Main parameter comparison:

% The aim of this main is to compare how change a single parameter for
% different wav-files:


addpath('feature_operator');
addpath('segment');
addpath('aux_Func');
addpath('plot');

%% Setting variables:

disp_frames=input('Frame-by-frame visualization (1: sí; 0: no): ');



%% Section 2: File selection: 


%Case you want to change or select new wav-files:
[file,path] = uigetfile('../data/PC_study/*.wav','Select One or More Files', 'MultiSelect', 'on');

if isequal(file,0)
   disp('User selected Cancel');
else
   disp(['User selected ', fullfile(path,file)]);
end

%Case you want those files always selected:

%% Section 2: Storing speech files in a cell array:
nfiles=length(file);

speech_audios=cell(3,nfiles);

for ifile=1:nfiles
    
    [speech_signal,Fs]=audioread(fullfile(path,file{1,ifile}));
    
    [path,name,ext]=fileparts(fullfile(path,file{1,ifile}));
    
    speech_audios{1,ifile}=speech_signal;
    speech_audios{2,ifile}=name;
    speech_audios{3,ifile}=Fs;
    
end



%% Section 3: Selecting 2 wav-files for comparing:

%List box. Contains all wav.files selected. For comparison select 2 files:
filenames=file;
[indx,tf] = listdlg('Name','Comparison selection','PromptString','Select 2 Files: ','SelectionMode','multiple',...
                           'ListString',filenames);

signal1=speech_audios{1,indx(1)};
Fs1=speech_audios{3,indx(1)};
signal2=speech_audios{1,indx(2)};
Fs2=speech_audios{3,indx(2)};

%% Section 4: 1º trial MFCCS

%Calculating MFCCS of 2 different signals:
[mfccs1,indices1] = msf_mfcc(signal1,Fs1,'nfilt',40,'ncep',12,'winlen',0.025,'winstep',0.010);
[mfccs2,indices2] = msf_mfcc(signal2,Fs2,'nfilt',40,'ncep',12,'winlen',0.025,'winstep',0.010);


if disp_frames==1
    %Viewing each temporal frame (selecting vector):
    %If you don´t want to visualize it, click mouse button. But if you want to see
    %frame by frame click a keyboard button.
    display_frames(signal1,Fs1,indices1,speech_audios{2,indx(1)});
    display_frames(signal2,Fs2,indices2,speech_audios{2,indx(2)});
end
%----------------------------------------------------------------------------%
% Based on what you view in the above visualization you may want to select
% a unique frame for both signals to compare it.
frame_indx=1; %frame 23 por ejemplo....

%Comparison between 2 vectors (frame) distances:
v1=mfccs1(frame_indx,:);
v2=mfccs2(frame_indx,:);

% Plotting first sound:
figure; plot(v1'); xlabel('Frames');ylabel('MFCCS values'); 
t=title(['MFCC Vector: ',speech_audios{2,indx(1)},' (Frame ',num2str(frame_indx),')']);
t.Interpreter='none';


% Plotting simple difference:
diff12=abs(v1-v2);
figure; plot(diff12'); xlabel('Frames');ylabel('MFCCS values'); 
t=title(['MFCC Vector difference: ',speech_audios{2,indx(1)},' and ',speech_audios{2,indx(2)},' (Frame ',num2str(frame_indx),')']);
t.Interpreter='none';

% Euclidean distance:
euc_Dist = norm(v1 - v2)  %Compute the euclidean norm of the difference of 2 vectors


%Comparison between 2 matrixes(all frames) distances:

% Plotting simple matrix: 1
figure; pcolor(mfccs1'); xlabel('Frames');ylabel('MFCCS values'); colorbar;
t=title(['MFCC matrix 1: ', speech_audios{2,indx(1)}]);
t.Interpreter='none';

% Plotting simple matrix: 2
figure; pcolor(mfccs2'); xlabel('Frames');ylabel('MFCCS values'); colorbar;
t=title(['MFCC matrix 2: ', speech_audios{2,indx(2)}]);
t.Interpreter='none';


% Plotting simple difference:
nframes1=length(mfccs1(:,1));
nframes2=length(mfccs2(:,1));
nframes=min(nframes1,nframes2);


diff12m=abs(mfccs1(1:nframes,:) - mfccs2(1:nframes,:));
figure; pcolor(diff12m'); xlabel('Frames');ylabel('MFCCS values'); colorbar;
t=title(['MFCC matrix difference: ',speech_audios{2,indx(1)},' and ',speech_audios{2,indx(2)},' (all frames)']);
t.Interpreter='none';

% Euclidean distance:

euc_Distm = norm(diff12m,'fro') %suma valores al cuadrado de la columna y luego ese resultado se suma por cada fila.y por ultimo raiz cuadrada.














%% Main: Statistic comparison



% Assumptions:
%    -You have 2 folders
%        *Folder 1: contains wav-files you want to compare with Folder 2.
%        *Folder 2: contains wav-files you want to compare with Folder 1.

% Aim:
%   -Compare statistically 2 different sets of speech audio parameters. For example: MFCCs.
% 

% Notes:
% For ergonomy purposes and not repeating the file selection each time you
% want to see results: RUN ISOLATED SECTIONS.

%% Section 1: Setting variables

addpath('Feature_operator');
addpath('segment');
addpath('aux_Func');
addpath('plot');

ncep=input('Numero de coeff cepstrums: ');

%% Section 2: Folder file Selection. 

[files1,path1] = uigetfile('../data/EC_study/Folder 2/Alveolares/*.wav','Select One or More Files', 'MultiSelect', 'on');
[files2,path2] = uigetfile('../data/EC_study/Folder 2/Labiales/*.wav','Select One or More Files', 'MultiSelect', 'on');

if isequal(files1,0)|| isequal(files2,0)
   disp('User selected Cancel');
else
   disp(['1º Wav-file Set', fullfile(path1,files1)]);
   disp(['2º Wav-file Set', fullfile(path2,files2)]);
end


%% Section 3: Storing each speech file in a cell array. And Checking if lengths of the two sets of files are the same.

nfiles1=length(files1);
nfiles2= length(files2);

% if nfiles1~=nfiles2
%     warning('2 speech sets must contain the same number of wav-files');
%     
%     [files1,path1] = uigetfile('../data/EC_study/Folder1/*.wav','Select One or More Files', 'MultiSelect', 'on');
%     [files2,path2] = uigetfile('../data/EC_study/Folder2/*.wav','Select One or More Files', 'MultiSelect', 'on');
%     if isequal(files1,0)|| isequal(files2,0)
%         disp('User selected Cancel');
%     else
%         disp(['1º Wav-file Set', fullfile(path1,files1)]);
%         disp(['2º Wav-file Set', fullfile(path2,files2)]);
%     end

%end


speech_audios1=cell(3,nfiles1);
speech_audios2=cell(3,nfiles2);

for ifile=1:nfiles1
    
    [speech_signal1,Fs1]=audioread(fullfile(path1,files1{1,ifile}));
    [path1,name1,ext1]=fileparts(fullfile(path1,files1{1,ifile}));
    
    speech_audios1{1,ifile}=speech_signal1;
    speech_audios1{2,ifile}=name1;
    speech_audios1{3,ifile}=Fs1;
   
end

for ifile=1:nfiles2
    
    [speech_signal2,Fs2]=audioread(fullfile(path2,files2{1,ifile}));
    [path2,name2,ext2]=fileparts(fullfile(path2,files2{1,ifile}));
    
    speech_audios2{1,ifile}=speech_signal2;
    speech_audios2{2,ifile}=name2;
    speech_audios2{3,ifile}=Fs2;
end


%% Section 4: Storing all MFCCs values in a cell array.

MFCCS1=cell(2,nfiles1);
MFCCS2=cell(2,nfiles2);

for ifile=1:nfiles1
    
    speech_signal1=speech_audios1{1,ifile};
    
    [mfccs1,indices1] = msf_mfcc(speech_signal1,speech_audios1{3,ifile},'nfilt',40,'ncep',ncep,'winlen',0.025, 'winstep',0.01);
    nframes1=length(indices1(:,1));
    
    MFCCS1{1,ifile}=mfccs1;
    MFCCS1{2,ifile}=nframes1;
   
end

for ifile=1:nfiles2
    
    speech_signal2=speech_audios2{1,ifile};
    
    [mfccs2 ,indices2] = msf_mfcc(speech_signal2,speech_audios2{3,ifile},'nfilt',40,'ncep',ncep,'winlen',0.025, 'winstep',0.01);
    nframes2=length(indices2(:,1));
    
    MFCCS2{1,ifile}=mfccs2;
    MFCCS2{2,ifile}=nframes2;
         
end

%% Section 5: Which is the minimum number of frames?


nF1=zeros(1,nfiles1);
nF2=zeros(1,nfiles2);

for ifile=1:nfiles1
    nF1(1,ifile)=MFCCS1{2,ifile};
    minNF1=min(nF1);
end

for ifile=1:nfiles2
    nF2(1,ifile)=MFCCS2{2,ifile};
    minNF2=min(nF2);
end


minNFrames=min(minNF1,minNF2);


%% Section 6: Calculating mfccs means matrix. One for each set of speech files.


s1=zeros(1,nfiles1);
s2=zeros(1,nfiles2);
means1=zeros(minNFrames,ncep);
means2=zeros(minNFrames,ncep);
for i=1:minNFrames
    for j=1:ncep
        for ifile=1:nfiles1
            mfccs1=MFCCS1{1,ifile};
            s1(1,ifile)=mfccs1(i,j);
        end
        means1(i,j)=mean(s1);
    end 
end

for i=1:minNFrames
    for j=1:ncep
        for ifile=1:nfiles2
            mfccs2=MFCCS2{1,ifile};
            s2(1,ifile)=mfccs2(i,j);
        end
        means2(i,j)=mean(s2);
    end 
end

means1=means1';
means2=means2';
diffMeans=abs(means1-means2);

%% Section 7: Matrix means visualization.



f=figure; 
subplot(3,1,1);
pcolor(means1);c=colorbar; c.Label.String = 'Mean MFCC values';
xlabel('Frames'); ylabel('Ordinary number of MFCCs'); title('Set 1: MFCC Mean matrix');
subplot(3,1,2);
pcolor(means2);c=colorbar; c.Label.String = 'Mean MFCC values';
xlabel('Frames'); ylabel('Ordinary number of MFCCs'); title('Set 2: MFCC Mean matrix');

subplot(3,1,3);
pcolor(diffMeans);c=colorbar; c.Label.String = 'Simple Difference Mean MFCC values';
xlabel('Frames'); ylabel('Ordinary number of MFCCs'); title('Comparative MFCC Mean matrix');

%Saving picture:

%[year month day hour minute seconds]
c=clock;
filename=['../data/EC_study/Median matrizes figures/',num2str(c(1)),'-',num2str(c(2)),'-',num2str(c(3)),'_',num2str(c(4)),'_',num2str(c(5)),'.png'];
saveas(f,filename);







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

%% Section 1: Folder file selection. Assigning config.txt directory information to matlab variables..
clear all


addpath('Feature_operator');
addpath('segment');
addpath('aux_Func');
addpath('plot');

%Assigning folder names and paths
a = importdata('config.txt',' ');

dirIn1=a.textdata;
dirIn1=char(dirIn1(1));
k = strfind(dirIn1,'wav');
Folder1=dirIn1(k+4:end);
dirIn1=dirIn1(11:k+3);
dir1=dir(dirIn1);

dirIn2=a.textdata;
dirIn2=char(dirIn2(2));
k = strfind(dirIn2,'wav');
Folder2=dirIn2(k+4:end);
dirIn2=dirIn2(11:k+3);
dir2=dir(dirIn2);




%% Section 2: Assigning config.txt parameter information to matlab variables... 



%% Section 3: Storing each speech file in a cell array. And Checking if lengths of the two sets of files are the same.

nfiles1=length(dir1);
nfiles2= length(dir2);

speech_audios1=cell(3,nfiles1);
speech_audios2=cell(3,nfiles2);

for ifile=1:nfiles1
    
    [speech_signal1,Fs1]=audioread(fullfile(dir1(ifile).folder,dir1(ifile).name));
    [path1,name1,ext1]=fileparts(fullfile(dir1(ifile).folder,dir1(ifile).name));
    
    speech_audios1{1,ifile}=speech_signal1;
    speech_audios1{2,ifile}=name1;
    speech_audios1{3,ifile}=Fs1;
   
end

for ifile=1:nfiles2
    
    [speech_signal2,Fs2]=audioread(fullfile(dir2(ifile).folder,dir2(ifile).name));
    [path2,name2,ext2]=fileparts(fullfile(dir2(ifile).folder,dir2(ifile).name));
    
    speech_audios2{1,ifile}=speech_signal2;
    speech_audios2{2,ifile}=name2;
    speech_audios2{3,ifile}=Fs2;
end


%% Section 4: Storing all MFCCs values in a cell array.


feat1=cell(2,nfiles1);
feat2=cell(2,nfiles2);

parameters=a.textdata;
features_validation=a.data;
parameters=parameters(4:end); %MOMENTO QUE PONGAS MAS COSAS ARRIBA DE LOS PARAMETROS CUIDADO
ind=find(features_validation==1);

for ifile=1:nfiles1
    
    speech_signal1=speech_audios1{1,ifile};
    
    switch  parameter(ind(1))
        case 'mfcc'
            [feature1,indices1] = msf_mfcc(speech_signal1,speech_audios1{3,ifile},'nfilt',nfilt,'ncep',ncep,'winlen',0.025, 'winstep',0.01);
        case 'lpc'
            [feature1,indices1] = msf_lpc(speech_signal1,speech_audios1{3,ifile},'order',order,'winlen',0.025, 'winstep',0.01);
        case 'lpcc'
            [feature1,indices1] = msf_lpcc(speech_signal1,speech_audios1{3,ifile},'order',order,'winlen',0.025, 'winstep',0.01);
        case 'lsf'
            [feature1,indices1] = msf_lsf(speech_signal1,speech_audios1{3,ifile},'order',order,'winlen',0.025, 'winstep',0.01);
        case 'lar'
            [feature1,indices1] = msf_lar(speech_signal1,speech_audios1{3,ifile},'order',order,'winlen',0.025, 'winstep',0.01);
        case 'rc'
            [feature1,indices1] = msf_rc(speech_signal1,speech_audios1{3,ifile},'order',order,'winlen',0.025, 'winstep',0.01);
        case 'ssc'
            [feature1,indices1] = msf_ssc(speech_signal1,speech_audios1{3,ifile},'nfilt',nfilt,'winlen',0.025, 'winstep',0.01);
        case 'logfb'
            [feature1,indices1] = msf_logfb(speech_signal1,speech_audios1{3,ifile},'nfilt',nfilt,'winlen',0.025, 'winstep',0.01);
        case 'powspec'
            [feature1,indices1] = msf_powspec(speech_signal1,speech_audios1{3,ifile},'winlen',0.025, 'winstep',0.01);
    end
    nframes1=length(indices1(:,1));
    
    feat1{1,ifile}=feature1;
    feat1{2,ifile}=nframes1;
                     
end

for ifile=1:nfiles2
    
    speech_signal2=speech_audios2{1,ifile};
    
      
    switch feature_type
        case 'mfcc'
            [feature2,indices2] = msf_mfcc(speech_signal2,speech_audios2{3,ifile},'nfilt',40,'ncep',ncep,'winlen',0.025, 'winstep',0.01);
            disp('mfcc computed');
        case 'lpc'
            [feature2,indices2] = msf_lpc(speech_signal2,speech_audios2{3,ifile},'order',order,'winlen',0.025, 'winstep',0.01);
            disp('lpc computed');
        case 'lpcc'
            [feature2,indices2] = msf_lpcc(speech_signal2,speech_audios2{3,ifile},'order',order,'winlen',0.025, 'winstep',0.01);
            disp('lpcc computed');
        case 'lsf'
            [feature2,indices2] = msf_lsf(speech_signal2,speech_audios2{3,ifile},'order',order,'winlen',0.025, 'winstep',0.01);
            disp('lsf computed');
        case 'lar'
            [feature2,indices2] = msf_lar(speech_signal2,speech_audios2{3,ifile},'order',order,'winlen',0.025, 'winstep',0.01);
            disp('lar computed');
        case 'rc'
            [feature2,indices2] = msf_rc(speech_signal2,speech_audios2{3,ifile},'order',order,'winlen',0.025, 'winstep',0.01);
            disp('rc computed');
        case 'ssc'
            [feature2,indices2] = msf_ssc(speech_signal2,speech_audios2{3,ifile},'nfilt',nfilt,'winlen',0.025, 'winstep',0.01);
            disp('ssc computed');
        case 'logfb'
            [feature2,indices2] = msf_logfb(speech_signal2,speech_audios2{3,ifile},'nfilt',nfilt,'winlen',0.025, 'winstep',0.01);
            disp('logfb computed');
        case 'powspec'
            [feature2,indices2] = msf_powspec(speech_signal2,speech_audios2{3,ifile},'winlen',0.025, 'winstep',0.01);
            disp('powspec computed');
    end
    nframes2=length(indices2(:,1));
    
    feat2{1,ifile}=feature2;
    feat2{2,ifile}=nframes2;
    
end




%% Section 5: Which is the minimum number of frames?


nF1=zeros(1,nfiles1);
nF2=zeros(1,nfiles2);

for ifile=1:nfiles1
    nF1(1,ifile)=feat1{2,ifile};
    minNF1=min(nF1);
end

for ifile=1:nfiles2
    nF2(1,ifile)=feat2{2,ifile};
    minNF2=min(nF2);
end


minNFrames=min(minNF1,minNF2);


%% Section 6: Calculating mfccs means matrix. One for each set of speech files.



if strcmp(feature_type,'mfcc')
    c=ncep;
    means1=zeros(minNFrames,c);
    means2=zeros(minNFrames,c);
end
if strcmp(feature_type,'lpc') || strcmp(feature_type,'lpcc') || strcmp(feature_type,'lsf')|| strcmp(feature_type,'lar') || strcmp(feature_type,'rc')
    c=order;
    means1=zeros(minNFrames,c);
    means2=zeros(minNFrames,c);
end

if strcmp(feature_type,'logfb') || strcmp(feature_type,'ssc')
    c=nfilt;
    means1=zeros(minNFrames,c);
    means2=zeros(minNFrames,c);
end
if strcmp(feature_type,'powspec')
    c=256;
    means1=zeros(minNFrames,c);
    means2=zeros(minNFrames,c);
end

s1=zeros(1,nfiles1);
s2=zeros(1,nfiles2);

for i=1:minNFrames
    for j=1:c
        for ifile=1:nfiles1
            feature1=feat1{1,ifile};
            s1(1,ifile)=feature1(i,j);
        end
        means1(i,j)=mean(s1);
    end 
end

for i=1:minNFrames
    for j=1:c
        for ifile=1:nfiles2
            feature2=feat2{1,ifile};
            s2(1,ifile)=feature2(i,j);
        end
        means2(i,j)=mean(s2);
    end 
end

means1=means1';
means2=means2';
diffMeans=abs(means1-means2);

%% Section 7: Matrix means visualization.

features=["MFFC","LPC", "LPCC", "Spectral Subband centroids", "Lines spectral frequencies", "Log area ratios", "Reflection coefficients", "Mel-Log-Filterbank", "Power spectrum"];
switch feature_type
    case 'mfcc'
        feature_s=features(1);
    case 'lpc'
         feature_s=features(2);
    case 'lpcc'
         feature_s=features(3);
    case 'lsf'
         feature_s=features(5);
    case 'lar'
         feature_s=features(6);
    case 'rc'
         feature_s=features(7);
    case 'ssc'
         feature_s=features(4);
    case 'logfb'
         feature_s=features(8);
    case 'powspec'
         feature_s=features(9);
end

f=figure; 
subplot(3,1,1);
pcolor(means1);c=colorbar; c.Label.String = ['Mean ', feature_s, ' values'];
xlabel('Frames'); ylabel(['Ordinary number of ',feature_s]); title(['Set 1: ',feature_s,' Mean matrix']);
subplot(3,1,2);
pcolor(means2);c=colorbar; c.Label.String = ['Mean ', feature_s, ' values'];
xlabel('Frames'); ylabel(['Ordinary number of ',feature_s]); title(['Set 2: ',feature_s,' Mean matrix']);

subplot(3,1,3);
pcolor(diffMeans);c=colorbar; c.Label.String = ['Simple Difference Mean ',feature_s,' values'];
xlabel('Frames'); ylabel(['Ordinary number of ',feature_s]); title(['Comparative ',feature_s,' Mean matrix']);

%Saving picture:

%[year month day hour minute seconds]
c=clock;
filename=['../data/EC_study/Median matrizes figures/',num2str(c(1)),'-',num2str(c(2)),'-',num2str(c(3)),'_',num2str(c(4)),'_',num2str(c(5)),'.png'];
saveas(f,filename);







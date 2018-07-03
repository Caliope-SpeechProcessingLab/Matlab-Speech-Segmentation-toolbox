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


parameters=a.data;
features_names=a.textdata;
features_names=features_names(4:end); %MOMENTO QUE PONGAS MAS COSAS ARRIBA DE LOS PARAMETROS CUIDADO

winlen=parameters(1);
winstep=parameters(2);
ncep=parameters(12);
nfilt=parameters(13);
order=parameters(14);

mfcc1=cell(2,nfiles1);
lpc1=cell(2,nfiles1);
lpcc1=cell(2,nfiles1);
lsf1=cell(2,nfiles1);
ssc1=cell(2,nfiles1);
rc1=cell(2,nfiles1);
lar1=cell(2,nfiles1);
logfb1=cell(2,nfiles1);
powspec1=cell(2,nfiles1);
for ifile=1:nfiles1
    
    speech_signal1=speech_audios1{1,ifile};
    
    if parameters(3)==1
        [feature1_1,indices1_1] = msf_mfcc(speech_signal1,speech_audios1{3,ifile},'nfilt',nfilt,'ncep',ncep,'winlen',winlen, 'winstep',winstep);
         disp('MFCC feature Executed');
        mfcc1{1,ifile}=feature1_1;
        nframes1_1=length(indices1_1(:,1));
        mfcc1{2,ifile}=nframes1_1;
    end
    if parameters(4)==1
        [feature1_2,indices1_2] = msf_lpc(speech_signal1,speech_audios1{3,ifile},'order',order,'winlen',winlen, 'winstep',winstep);
        disp('LPC feature Executed');
        lpc1{1,ifile}=feature1_2;
        nframes1_2=length(indices1_2(:,1));
        lpc1{2,ifile}=nframes1_2;
    end
    if parameters(5)==1
        [feature1_3,indices1_3] = msf_lpcc(speech_signal1,speech_audios1{3,ifile},'order',order,'winlen',winlen, 'winstep',winstep);
        disp('LPCC feature Executed');
        lpcc1{1,ifile}=feature1_3;
        nframes1_3=length(indices1_3(:,1));
        lpcc1{2,ifile}=nframes1_3;
    end
    if parameters(6)==1
        [feature1_4,indices1_4] = msf_lsf(speech_signal1,speech_audios1{3,ifile},'order',order,'winlen',winlen, 'winstep',winstep);
        disp('Lines spectral frequencies feature Executed');
        lsf1{1,ifile}=feature1_4;
        nframes1_4=length(indices1_4(:,1));
        lsf1{2,ifile}=nframes1_4;
    end
    
    if parameters(7)==1
        [feature1_5,indices1_5] = msf_ssc(speech_signal1,speech_audios1{3,ifile},'nfilt',nfilt,'winlen',winlen, 'winstep',winstep);
        disp('Spectral subband centroids feature Executed');
        ssc1{1,ifile}=feature1_5;
        nframes1_5=length(indices1_5(:,1));
        ssc1{2,ifile}=nframes1_5;
    end
    if parameters(8)==1
        [feature1_6,indices1_6] = msf_rc(speech_signal1,speech_audios1{3,ifile},'order',order,'winlen',winlen, 'winstep',winstep);
        disp('Reflection coefficients feature Executed');
        rc1{1,ifile}=feature1_6;
        nframes1_6=length(indices1_6(:,1));
        rc1{2,ifile}=nframes1_6;
    end
    if parameters(9)==1
        [feature1_7,indices1_7] = msf_lar(speech_signal1,speech_audios1{3,ifile},'order',order,'winlen',winlen, 'winstep',winlen);
        disp('Log area ratios feature Executed');
        lar1{1,ifile}=feature1_7;
        nframes1_7=length(indices1_7(:,1));
        lar1{2,ifile}=nframes1_7;
    end
    if parameters(10)==1
        [feature1_8,indices1_8] = msf_logfb(speech_signal1,speech_audios1{3,ifile},'nfilt',nfilt,'winlen',winlen, 'winstep',winstep);
        disp('Log Filterbanks feature Executed');
        logfb1{1,ifile}=feature1_8;
        nframes1_8=length(indices1_8(:,1));
        logfb1{2,ifile}=nframes1_8;
    end
    if parameters(11)==1
        [feature1_9,indices1_9] = msf_powspec(speech_signal1,speech_audios1{3,ifile},'winlen',0.025, 'winstep',0.01);
        disp('Power spectrum feature Executed');
        powspec1{1,ifile}=feature1_9;
        nframes1_9=length(indices1_9(:,1));
        powspec1{2,ifile}=nframes1_9;
    end
    
end

mfcc2=cell(2,nfiles2);
lpc2=cell(2,nfiles2);
lpcc2=cell(2,nfiles2);
lsf2=cell(2,nfiles2);
ssc2=cell(2,nfiles2);
rc2=cell(2,nfiles2);
lar2=cell(2,nfiles2);
logfb2=cell(2,nfiles2);
powspec2=cell(2,nfiles2);
for ifile=1:nfiles2
    
    speech_signal2=speech_audios2{1,ifile};
    
    if parameters(3)==1
        [feature2_1,indices2_1] = msf_mfcc(speech_signal2,speech_audios2{3,ifile},'nfilt',nfilt,'ncep',ncep,'winlen',winlen, 'winstep',winstep);
         disp('MFCC feature Executed');
        mfcc2{1,ifile}=feature2_1;
        nframes2_1=length(indices2_1(:,1));
        mfcc2{2,ifile}=nframes2_1;
    end
    if parameters(4)==1
        [feature2_2,indices2_2] = msf_lpc(speech_signal2,speech_audios2{3,ifile},'order',order,'winlen',winlen, 'winstep',winstep);
        disp('LPC feature Executed');
        lpc2{1,ifile}=feature2_2;
        nframes2_2=length(indices2_2(:,1));
        lpc2{2,ifile}=nframes2_2;
    end
    if parameters(5)==1
        [feature2_3,indices2_3] = msf_lpcc(speech_signal2,speech_audios2{3,ifile},'order',order,'winlen',winlen, 'winstep',winstep);
        disp('LPCC feature Executed');
        lpcc2{1,ifile}=feature2_3;
        nframes2_3=length(indices2_3(:,1));
        lpcc2{2,ifile}=nframes2_3;
    end
    if parameters(6)==1
        [feature2_4,indices2_4] = msf_lsf(speech_signal2,speech_audios2{3,ifile},'order',order,'winlen',winlen, 'winstep',winstep);
        disp('Lines spectral frequencies feature Executed');
        lsf2{1,ifile}=feature2_4;
        nframes2_4=length(indices2_4(:,1));
        lsf2{2,ifile}=nframes2_4;
    end
    
    if parameters(7)==1
        [feature2_5,indices2_5] = msf_ssc(speech_signal2,speech_audios2{3,ifile},'nfilt',nfilt,'winlen',winlen, 'winstep',winstep);
        disp('Spectral subband centroids feature Executed');
        ssc2{1,ifile}=feature2_5;
        nframes2_5=length(indices2_5(:,1));
        ssc2{2,ifile}=nframes2_5;
    end
    if parameters(8)==1
        [feature2_6,indices2_6] = msf_rc(speech_signal2,speech_audios2{3,ifile},'order',order,'winlen',winlen, 'winstep',winstep);
        disp('Reflection coefficients feature Executed');
        rc2{1,ifile}=feature2_6;
        nframes2_6=length(indices2_6(:,1));
        rc2{2,ifile}=nframes2_6;
    end
    if parameters(9)==1
        [feature2_7,indices2_7] = msf_lar(speech_signal2,speech_audios2{3,ifile},'order',order,'winlen',winlen, 'winstep',winlen);
        disp('Log area ratios feature Executed');
        lar2{1,ifile}=feature2_7;
        nframes2_7=length(indices2_7(:,1));
        lar2{2,ifile}=nframes2_7;
    end
    if parameters(10)==1
        [feature2_8,indices2_8] = msf_logfb(speech_signal2,speech_audios2{3,ifile},'nfilt',nfilt,'winlen',winlen, 'winstep',winstep);
        disp('Log Filterbanks feature Executed');
        logfb2{1,ifile}=feature2_8;
        nframes2_8=length(indices2_8(:,1));
        logfb2{2,ifile}=nframes2_8;
    end
    if parameters(11)==1
        [feature2_9,indices2_9] = msf_powspec(speech_signal2,speech_audios2{3,ifile},'winlen',0.025, 'winstep',0.01);
        disp('Power spectrum feature Executed');
        powspec2{1,ifile}=feature2_9;
        nframes2_9=length(indices2_9(:,1));
        powspec2{2,ifile}=nframes2_9;
    end
    
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







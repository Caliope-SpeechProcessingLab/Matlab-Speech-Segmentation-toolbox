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

feature_type=input(['Feature type:',newline,'mfcc (Mel-frecuency cepstrum coefficients)',newline,'lpc',newline,'lpcc',newline,'lsf (Line spectral frequencies)',newline,'rc',newline,'lar (Log area ratios)',newline,'powSpec',newline,'logfb',newline,'ssc (spectral sub-band centroid)',newline]);

if feature_type=='mfcc'
    ncep=input('Numero de coeff cepstrums: ');
    nfilt=input('Numero de filtros: ');
end
if feature_type=='lpc' || feature_type=='lpcc' || feature_type=='lsf' || feature_type=='lar' || feature_type=='rc'
    order=input('Numero de coeff predictivos lineales: ');
end

if feature_type=='logfb' || feature_type=='ssc'
    nfilt=input('Numero de filtros: ');
end
if feature_type=='powspec'
    
end




%% Section 2: Folder file Selection. 

[files1,path1] = uigetfile('../data/EC_study/Folder 2/Alveolares/*.wav','Select One or More Files', 'MultiSelect', 'on');
[files2,path2] = uigetfile('../data/EC_study/Folder 2/Labiales/*.wav','Select One or More Files', 'MultiSelect', 'on');

if isequal(files1,0)|| isequal(files2,0)
   disp('User selected Cancel');
else
   disp(['1� Wav-file Set', fullfile(path1,files1)]);
   disp(['2� Wav-file Set', fullfile(path2,files2)]);
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
%         disp(['1� Wav-file Set', fullfile(path1,files1)]);
%         disp(['2� Wav-file Set', fullfile(path2,files2)]);
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


feat1=cell(2,nfiles1);
feat2=cell(2,nfiles2);


for ifile=1:nfiles1
    
    speech_signal1=speech_audios1{1,ifile};
    
    switch feature_type
        case 'mfcc'
            [feature1,indices1] = msf_mfcc(speech_signal1,speech_audios1{3,ifile},'nfilt',40,'ncep',ncep,'winlen',0.025, 'winstep',0.01);
        case 'lpc'
            [feature1,indices1] = msf_lpc(speech_signal1,speech_audios1{3,ifile},'order',13,'winlen',0.025, 'winstep',0.01);
        case 'lpcc'
            [feature1,indices1] = msf_lpcc(speech_signal1,speech_audios1{3,ifile},'order',13,'winlen',0.025, 'winstep',0.01);
        case 'lsf'
            [feature1,indices1] = msf_lsf(speech_signal1,speech_audios1{3,ifile},'order',13,'winlen',0.025, 'winstep',0.01);
        case 'lar'
            [feature1,indices1] = msf_lar(speech_signal1,speech_audios1{3,ifile},'order',13,'winlen',0.025, 'winstep',0.01);
        case 'rc'
            [feature1,indices1] = msf_rc(speech_signal1,speech_audios1{3,ifile},'order',13,'winlen',0.025, 'winstep',0.01);
        case 'ssc'
            [feature1,indices1] = msf_ssc(speech_signal1,speech_audios1{3,ifile},'nfilt',26,'winlen',0.025, 'winstep',0.01);
        case 'logfb'
            [feature1,indices1] = msf_logfb(speech_signal1,speech_audios1{3,ifile},'nfilt',26,'winlen',0.025, 'winstep',0.01);
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
        case 'lpc'
            [feature2,indices2] = msf_lpc(speech_signal2,speech_audios2{3,ifile},'order',order,'winlen',0.025, 'winstep',0.01);
        case 'lpcc'
            [feature2,indices2] = msf_lpcc(speech_signal2,speech_audios2{3,ifile},'order',order,'winlen',0.025, 'winstep',0.01);
        case 'lsf'
            [feature2,indices2] = msf_lsf(speech_signal2,speech_audios2{3,ifile},'order',order,'winlen',0.025, 'winstep',0.01);
        case 'lar'
            [feature2,indices2] = msf_lar(speech_signal2,speech_audios2{3,ifile},'order',order,'winlen',0.025, 'winstep',0.01);
        case 'rc'
            [feature2,indices2] = msf_rc(speech_signal2,speech_audios2{3,ifile},'order',order,'winlen',0.025, 'winstep',0.01);
        case 'ssc'
            [feature2,indices2] = msf_ssc(speech_signal2,speech_audios2{3,ifile},'nfilt',nfilt,'winlen',0.025, 'winstep',0.01);
        case 'logfb'
            [feature2,indices2] = msf_logfb(speech_signal2,speech_audios2{3,ifile},'nfilt',nfilt,'winlen',0.025, 'winstep',0.01);
        case 'powspec'
            [feature2,indices2] = msf_powspec(speech_signal2,speech_audios2{3,ifile},'winlen',0.025, 'winstep',0.01);
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



if feature_type=='mfcc'
    c=ncep;
    means1=zeros(minNFrames,c);
    means2=zeros(minNFrames,c);
end
if feature_type=='lpc' || feature_type=='lpcc' || feature_type=='lsf' || feature_type=='lar' || feature_type=='rc'
    c=order;
    means1=zeros(minNFrames,c);
    means2=zeros(minNFrames,c);
end

if feature_type=='logfb' || feature_type=='ssc'
    c=nfilt;
    means1=zeros(minNFrames,c);
    means2=zeros(minNFrames,c);
end
if feature_type=='powspec'
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

features=['MFFC','LPC', 'LPCC', 'Spectral Subband centroids', 'Lines spectral frequencies','Log area ratios'];

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







% Assumptions:
%    -You have 2 folders
%        *Folder 1: contains wav-files you want to compare with Folder 2.
%        *Folder 2: contains wav-files you want to compare with Folder 1.

% Aim:
%   -Compare statistically 2 different sets of speech audio parameters. For example: MFCCs.
% 

% Notes:
% For mfcc feature--->ncep has to be smaller than nfilt. Good practice is
% that ncep=nfilt/2;
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

 



%% Section 2: Storing each speech file in a cell array. And Checking if lengths of the two sets of files are the same.

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


%% Section 3: Storing all feature values in a cell array.

parameters=a.data;
features_names=a(:,1).textdata;
features_names=features_names(4:end,1); %MOMENTO QUE PONGAS MAS COSAS ARRIBA DE LOS PARAMETROS CUIDADO

winlen=parameters(1);
winstep=parameters(2);
ncep=parameters(12);
nfilt=parameters(13);
order=parameters(14);


ind=find(parameters==1);
chosen_features=string(features_names(ind));

func_param=cell(length(ind),7);

for i=1:length(chosen_features) 
   if strcmp(chosen_features(i),'msf_mfcc')
      func_param{i,1}=chosen_features(i);
      func_param{i,2}=winlen;
      func_param{i,3}=winstep;
      func_param{i,4}='nfilt';
      func_param{i,5}=nfilt;
      func_param{i,6}='ncep';
      func_param{i,7}=ncep;
   end
   if strcmp(chosen_features(i),'msf_lpc') || strcmp(chosen_features(i),'msf_lpcc') || strcmp(chosen_features(i),'msf_lsf') || strcmp(chosen_features(i),'msf_rc') || strcmp(chosen_features(i),'msf_lar')
      func_param{i,1}=chosen_features(i);
      func_param{i,2}=winlen;
      func_param{i,3}=winstep;
      func_param{i,4}='order';
      func_param{i,5}=order; 
      func_param{i,6}='preemph';
      func_param{i,7}=0; % No preemphasis default
   end
   if strcmp(chosen_features(i),'msf_ssc') || strcmp(chosen_features(i),'msf_logfb') 
      func_param{i,1}=chosen_features(i);
      func_param{i,2}=winlen;
      func_param{i,3}=winstep;
      func_param{i,4}='nfilt';
      func_param{i,5}=nfilt; 
      func_param{i,6}='preemph';
      func_param{i,7}=0; %No preemphasis default
      
   end
   if strcmp(chosen_features(i),'msf_powspec')
      func_param{i,1}=chosen_features(i);
      func_param{i,2}=winlen;
      func_param{i,3}=winstep;
      func_param{i,4}='nfft'; 
      func_param{i,5}=512; %nfft default
      func_param{i,6}='variable'; 
      func_param{i,7}=false; %variable frames default
   end
    
end

%Genera los features seleccionados por cada archivo:
speech_features1=cell(length(ind),nfiles1); %Filas clasifica features y las  columnas clasifican or archivos
numberFrames1=zeros(length(ind),nfiles1);
%Set1
for i=1:length(chosen_features)
    for j=1:nfiles1
        [feature,indices]=feval(chosen_features(i), speech_audios1{1,j},speech_audios1{3,j},func_param{i,2},func_param{i,3},func_param{i,4},func_param{i,5},func_param{i,6},func_param{i,7});
        disp(['Se ha ejecutado la funcion: ',chosen_features(i),'. En speech_features es la fila: ',num2str(i)]);
        speech_features1{i,j}=feature; %Metemos nombre archivo
        numberFrames1(i,j)=length(indices(:,1));
    end
end
%Set2
speech_features2=cell(length(ind),nfiles2); %Filas clasifica features y las  columnas clasifican or archivos
numberFrames2=zeros(length(ind),nfiles2);
for i=1:length(chosen_features)
    for j=1:nfiles2
        [feature,indices]=feval(chosen_features(i), speech_audios2{1,j},speech_audios2{3,j},func_param{i,2},func_param{i,3},func_param{i,4},func_param{i,5},func_param{i,6},func_param{i,7});
        disp(['Se ha ejecutado la funcion: ',chosen_features(i),'. En speech_features es la fila: ',num2str(i)]);
        speech_features2{i,j}=feature; %Metemos nombre archivo
        numberFrames2(i,j)=length(indices(:,1));
    end
end



%% Section 4:  Which is the minimum number of frames?

minNFrames1=min(min(numberFrames1));
minNFrames2=min(min(numberFrames2));
minNFrames=min(minNFrames1,minNFrames2);


%% Section 5: Calculating features means matrix. One for each set of speech files.
array_means1=cell(1,length(chosen_features));
array_means2=cell(1,length(chosen_features));
for i=1:length(chosen_features)
    feat=speech_features1(i,:);
    if strcmp(chosen_features(i),'msf_mfcc')
       c=func_param{i,7};
       means1=mean_matrix(minNFrames,c,feat,nfiles1)';
       means2=mean_matrix(minNFrames,c,feat,nfiles2)'; 
       array_means1{1,i}=means1;
       array_means2{1,i}=means2;
    else
       c=func_param{i,5};
       means1=mean_matrix(minNFrames,c,feat,nfiles1)';
       means2=mean_matrix(minNFrames,c,feat,nfiles2)'; 
       array_means1{1,i}=means1;
       array_means2{1,i}=means2;
    end
end

%% Section 6: Matrix means visualization



for i=1:length(chosen_features)
   f=figure('units','normalized','outerposition',[0 0 1 1]);
   subplot(3,1,1);
   pcolor(array_means1{1,i});  c=colorbar; c.Label.String = ['Mean ', chosen_features(i), ' values'];c.Label.Interpreter='none';
   t1=title([Folder1, ' mean matrix. Feature: ', chosen_features(i)]);t1.Interpreter='none';
   xlabel('Frames');ylabel(['Ordinary number of coefficient: ', chosen_features(i)]);
   subplot(3,1,2);
   pcolor(array_means2{1,i}); c=colorbar; c.Label.String = ['Mean ', chosen_features(i), ' values'];c.Label.Interpreter='none';
   t2=title([Folder2, ' mean matrix. Feature: ',chosen_features(i)]);t2.Interpreter='none';
   xlabel('Frames');ylabel(['Ordinary number of coefficient: ', chosen_features(i)]);
   subplot(3,1,3);
   pcolor(abs(array_means2{1,i}-array_means1{1,i})); c=colorbar; c.Label.String = ['Difference mean ', chosen_features(i), ' values'];c.Label.Interpreter='none';
   t3=title(['Comparative mean matrix. Feature: ',chosen_features(i)]);t3.Interpreter='none';
   xlabel('Frames');ylabel(['Ordinary number of coefficient: ', chosen_features(i)]);
   %Saving picture:

   %[year month day hour minute seconds]
   c=clock;
   filename=['../data/EC_study/Outputs/',num2str(c(1)),'-',num2str(c(2)),'-',num2str(c(3)),'_',num2str(c(4)),'_',num2str(c(5)),'_',char(chosen_features(i)),'.png'];
   saveas(f,filename);

end








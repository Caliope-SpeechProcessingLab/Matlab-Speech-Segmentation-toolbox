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


addpath('../features');
addpath('../segments');
addpath('../aux_Func');
addpath('../plots');

%Assigning folder names and paths
fid = fopen('config.txt', 'r'); % opci�n rt para abrir en modo texto
direcciones = textscan(fid,'%s',3,'Delimiter','\n','CommentStyle','%');

dirIn1=direcciones{1,1}{1,1};
dirIn1=char(dirIn1);
k = strfind(dirIn1,'.wav');
Folder1=dirIn1(k+5:end);
dirIn1=dirIn1(11:k+3);
dir1=dir(dirIn1);



dirIn2=direcciones{1,1}{2,1};
dirIn2=char(dirIn2);
k = strfind(dirIn2,'.wav');
Folder2=dirIn2(k+5:end);
dirIn2=dirIn2(11:k+3);
dir2=dir(dirIn2);

 
dirout=direcciones{1,1}{3,1};
dirout=char(dirout);
dirout=dirout(11:end);


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


%% Section 3: Reading feature selection data.

txt_features = textscan(fid,'%s %f',9,'Delimiter','\t','CommentStyle','%');
txt_Arguments = textscan(fid,'%s %f',5,'Delimiter','\t','CommentStyle','%');
txt_visualization=textscan(fid,'%s %f',2,'Delimiter','\t','CommentStyle','%');
txt_coefficient=textscan(fid,'%s %f',2,'Delimiter','\t','CommentStyle','%');

%% Section 4: Storing all feature values in a cell array.

parameters=txt_features{1,2};
features_names=txt_features{1,1};
arguments=txt_Arguments{1,2};


winlen=arguments(1);
winstep=arguments(2);
ncep=arguments(3);
nfilt=arguments(4);
order=arguments(5);

ind=find(parameters==1);
chosen_features=string(features_names(ind));

func_param=cell(length(ind),9);
nfft=2.^(nextpow2(length(speech_audios1{1,1})));
for i=1:length(chosen_features) 
   if strcmp(chosen_features(i),'msf_mfcc')
      func_param{i,1}=chosen_features(i);
      func_param{i,2}=winlen;
      func_param{i,3}=winstep;
      func_param{i,4}='nfilt';
      func_param{i,5}=nfilt;
      func_param{i,6}='ncep';
      func_param{i,7}=ncep;
      func_param{i,8}='nfft';
      func_param{i,9}=nfft;
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
      func_param{i,6}='nfft';
      func_param{i,7}=nfft; %No preemphasis default
      
   end
   if strcmp(chosen_features(i),'msf_powspec')
      func_param{i,1}=chosen_features(i);
      func_param{i,2}=winlen;
      func_param{i,3}=winstep;
      func_param{i,4}='nfft'; 
      func_param{i,5}=nfft; %nfft default
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
        if strcmp(chosen_features(i),'msf_mfcc')
            [feature,indices]=feval(chosen_features(i), speech_audios1{1,j},speech_audios1{3,j},func_param{i,2},func_param{i,3},func_param{i,4},func_param{i,5},func_param{i,6},func_param{i,7},func_param{i,8},func_param{i,9});
            disp(['Function: ',chosen_features(i)],['speech_feature row: ',num2str(i)] );
            speech_features1{i,j}=feature; %Metemos nombre archivo
            numberFrames1(i,j)=length(indices(:,1));
        else
            [feature,indices]=feval(chosen_features(i), speech_audios1{1,j},speech_audios1{3,j},func_param{i,2},func_param{i,3},func_param{i,4},func_param{i,5},func_param{i,6},func_param{i,7});
            disp(['Function: ',chosen_features(i)],['speech_feature row: ',num2str(i)] );
            speech_features1{i,j}=feature; %Metemos nombre archivo
            numberFrames1(i,j)=length(indices(:,1));
        end
    end
end
%Set2
speech_features2=cell(length(ind),nfiles2); %Filas clasifica features y las  columnas clasifican or archivos
numberFrames2=zeros(length(ind),nfiles2);
for i=1:length(chosen_features)
    for j=1:nfiles2
        if strcmp(chosen_features(i),'msf_mfcc')
            [feature,indices]=feval(chosen_features(i), speech_audios2{1,j},speech_audios2{3,j},func_param{i,2},func_param{i,3},func_param{i,4},func_param{i,5},func_param{i,6},func_param{i,7},func_param{i,8},func_param{i,9});
            disp(['Function: ',chosen_features(i) 'speech_feature row: ' num2str(i)]);
            speech_features2{i,j}=feature; %Metemos nombre archivo
            numberFrames2(i,j)=length(indices(:,1));
        else
            [feature,indices]=feval(chosen_features(i), speech_audios2{1,j},speech_audios2{3,j},func_param{i,2},func_param{i,3},func_param{i,4},func_param{i,5},func_param{i,6},func_param{i,7});
            disp(['Function: ',chosen_features(i) 'speech_feature row: ' num2str(i)]);
            speech_features2{i,j}=feature; %Metemos nombre archivo
            numberFrames2(i,j)=length(indices(:,1));
        end
    end
end



%% Section 5:  Which is the minimum number of frames?

minNFrames1=min(min(numberFrames1));
minNFrames2=min(min(numberFrames2));
minNFrames=min(minNFrames1,minNFrames2);


%% Section 6: Calculating features means matrix. One for each set of speech files.
array_means1=cell(1,length(chosen_features));
array_means2=cell(1,length(chosen_features));
for i=1:length(chosen_features)
    
    if strcmp(chosen_features(i),'msf_mfcc')
       c=func_param{i,7};
       feat1=speech_features1(i,:);
       means1=mean_matrix(minNFrames,c,feat1,nfiles1)';
       means1 = (means1 - min(means1(:)))/(max(means1(:)) - min(means1(:))); %Normalize [0,1]
        
       feat2=speech_features2(i,:);
       means2=mean_matrix(minNFrames,c,feat2,nfiles2)'; 
       means2 = (means2 - min(means2(:)))/(max(means2(:)) - min(means2(:))); %Normalize [0,1]
       
       array_means1{1,i}=means1;
       array_means2{1,i}=means2;
       
    else
       c=func_param{i,5};
       feat1=speech_features1(i,:);
       means1=mean_matrix(minNFrames,c,feat1,nfiles1)';
       means1 = (means1 - min(means1(:)))/(max(means1(:)) - min(means1(:))); %Normalize [0,1]
       
       feat2=speech_features2(i,:);
       means2=mean_matrix(minNFrames,c,feat2,nfiles2)'; 
       means2 = (means2 - min(means2(:)))/(max(means2(:)) - min(means2(:))); %Normalize [0,1]
       
       array_means1{1,i}=means1;
       array_means2{1,i}=means2;
       
    end
end

%% Section 7: In case one or a set of coefficient are required to inspect:


ind_inf=txt_coefficient{1,2}(1,1);
ind_sup=txt_coefficient{1,2}(2,1);


meanCoeffFeat=zeros(3,length(chosen_features));
diffMeans=cell(1,length(chosen_features));
if length(ind_inf:ind_sup)>1 %Media de varios coeficientes
    
    for j=1:length(chosen_features)
        diffMeans{1,j}=array_means2{1,j}-array_means1{1,j};
        medCoeff1=mean(array_means2{1,j}(ind_inf:ind_sup,:),2); %media de cada fila de la matriz ya que esas son los coeficientes por todos los frames.
        medCoeff2=mean(array_means1{1,j}(ind_inf:ind_sup,:),2);
        meanCoeffFeat(1,j) =mean(medCoeff1);%El primer mean hace la media de las columnas y el segundo el de ese resultadp
        meanCoeffFeat(2,j) =mean(medCoeff2);
        meanCoeffFeat(3,j) = norm(medCoeff1-medCoeff2); %Disrancia euclidea
    end
else %Cuando es solo la media de un coeficiente
    for j=1:length(chosen_features)
        diffMeans{1,j}=array_means2{1,j}-array_means1{1,j};
        medCoeff1=mean(array_means2{1,j}(ind_inf:ind_sup,:),2); %media de cada fila de la matriz ya que esas son los coeficientes por todos los frames.
        medCoeff2=mean(array_means1{1,j}(ind_inf:ind_sup,:),2);
        meanCoeffFeat(1,j) =medCoeff1;
        meanCoeffFeat(2,j) =medCoeff2;
        meanCoeffFeat(3,j) = medCoeff2-medCoeff1;
    end
end
%Media coeficientes matriz comparacion



%% Section 8: Matrix means visualization



for i=1:length(chosen_features)
    
    strFormat='%s mean matrix. %s. Mean Coeff %d-%d:  %f';
    strFormat1='Comparative mean matrix. Feature: %s. Ec.dist Coeff %d-%d:  %f';
    
    if strcmp(chosen_features,'msf_logfb') %Que es el logfb este elegido
        f=figure('units','normalized','outerposition',[0 0 1 1]);
        
        subplot(3,1,1);
        pcolor(array_means1{1,i});colormap(jet);  c=colorbar; c.Label.String = ['Energy(dB) ', chosen_features(i), ' values'];c.Label.Interpreter='none';
        t1=title(sprintf(strFormat,Folder1,chosen_features(i),ind_inf,ind_sup,meanCoeffFeat(1,i)));t1.Interpreter='none';
        xlabel('Frames');ylabel('Discrete Frequencies');
        
        subplot(3,1,2);
        pcolor(array_means2{1,i});colormap(jet); c=colorbar; c.Label.String = ['Energy(dB) ', chosen_features(i), ' values'];c.Label.Interpreter='none';
        t2=title(sprintf(strFormat,Folder2,chosen_features(i),ind_inf,ind_sup,meanCoeffFeat(2,i)));t2.Interpreter='none';
        xlabel('Frames');ylabel('Discrete Frequencies');
        
        subplot(3,1,3);
        pcolor(diffMeans{1,i});colormap(jet); c=colorbar; c.Label.String = ['Difference mean(dB) ', chosen_features(i), ' values'];c.Label.Interpreter='none';
        lim = caxis; caxis([txt_visualization{1,2}(1,1) txt_visualization{1,2}(2,1)]);
        t3=title(sprintf(strFormat1,chosen_features(i),ind_inf,ind_sup,meanCoeffFeat(3,i)));t3.Interpreter='none';
        xlabel('Frames');ylabel('Discrete Frequencies');
    else
        f=figure('units','normalized','outerposition',[0 0 1 1]);
        
        subplot(3,1,1);
        pcolor(array_means1{1,i}); colormap(jet); c=colorbar; c.Label.String = ['Mean ', chosen_features(i), ' values'];c.Label.Interpreter='none';
        t1=title(sprintf(strFormat,Folder1,chosen_features(i),ind_inf,ind_sup,meanCoeffFeat(1,i)));t1.Interpreter='none';
        xlabel('Frames');ylabel(['Ordinary number of coefficient: ', chosen_features(i)]);
        
        subplot(3,1,2);
        pcolor(array_means2{1,i}); colormap(jet);c=colorbar; c.Label.String = ['Mean ', chosen_features(i), ' values'];c.Label.Interpreter='none';
        t2=title(sprintf(strFormat,Folder2,chosen_features(i),ind_inf,ind_sup,meanCoeffFeat(2,i)));t2.Interpreter='none';
        xlabel('Frames');ylabel(['Ordinary number of coefficient: ', chosen_features(i)]);
        
        subplot(3,1,3);
        pcolor(diffMeans{1,i}); colormap(jet);c=colorbar; c.Label.String = ['Difference mean ', chosen_features(i), ' values'];c.Label.Interpreter='none';
        lim = caxis; caxis([txt_visualization{1,2}(1,1) txt_visualization{1,2}(2,1)]);
        t3=title(sprintf(strFormat1,chosen_features(i),ind_inf,ind_sup,meanCoeffFeat(3,i)));t3.Interpreter='none';
        xlabel('Frames');ylabel(['Ordinary number of coefficient: ', chosen_features(i)]);
        
        %Saving picture:
        
        %[year month day hour minute seconds]
        dirOut=direcciones{1,1}{3,1};
        dirOut=char(dirOut);
        dirOut=dirOut(11:end);
        c=clock;
        filename=[dirout,num2str(c(1)),'-',num2str(c(2)),'-',num2str(c(3)),'_',num2str(c(4)),'_',num2str(c(5)),'_',char(chosen_features(i)),'.png'];
        saveas(f,filename);
    end
end

%% Section 8: Storing in a table, feature for machine learning process.



clear i
clear t1
clear t2
clear t3
clear c
clear f
clear path1
clear path2
clear ext1
clear ext2
clear k



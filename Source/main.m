%--------------------------------------------MAIN-DEPICTION------------------------------------------------------------%
%----------------------------------------------------------------------------------------------------------------------%
%----------------------------------------------------------------------------------------------------------------------%
clear all
addpath('segment');
addpath('aux_Func');
addpath('eval');

%% CONFIGURABLE SETTING VARIABLES:-----------------------------------------------------------------------------------------------------------%

%SETTING string-type variables:

segType=input('Segmentation type ("fixed"/"phased"): ','s'); % specifies type of segmentation.
evalType=input('Evaluation type ("E": euclidean distance/A: arbitrary): ','s'); % specifies type of evaluation. 'e' euclidean distance will be executed.
plotType=input('Plot procedure: ','s'); % specifies type of plot.

%Folder and audio file selection

path='../data/todasJasa_Q/';

% You can use regular expresions so select specific files b*.wav 
fileSelection='b*.wav';

%Obtaining an Struct list of all wav-file. Containing their paths, name,
%and extension.
list = dir([path fileSelection]);
nfiles=length(list);


%% ------------------------------------Storing in a cell array all wav-files data:-------------------------------------------------------------------------------------%
speech_audios=cell(3,nfiles);

for ifile=1:nfiles
    
    filei=fullfile(list(ifile).folder,list(ifile).name);
    [x,Fs]=audioread(filei);
    speech_audios{1,ifile}=x;
    speech_audios{2,ifile}=list(ifile).name;
    speech_audios{3,ifile}=Fs;
    
end

%% ------------------------------------Adjunting Fs to Fs_standard=16000 Hz for all speech files------------------------------------------------------------------------------------------------%
for ifile=1:nfiles
    if speech_audios{3,ifile}>16000
        newFs=16000;
        [xD]=LP_decimation_function(speech_audios{1,ifile},speech_audios{3,ifile},newFs);
        speech_audios{3,ifile}=newFs;
        x=xD;
    end
end
%% ------------------------------------------------------SEGMENTATION--------------------------------------------------------------------------------------------------%

%Cell array where I can store all boundaries values from all segments per wav-files:
boundaries_per_audio=cell(3,nfiles);

if strcmp(segType,'fixed')
    
    for ifile=1:nfiles
        [boundaries,Fs_S]=fixed_segmenter(speech_audios{1,ifile},speech_audios{3,ifile});
        boundaries_per_audio{1,ifile}=boundaries;  %Boundaries are explained on the depiction section.
        boundaries_per_audio{2,ifile}=speech_audios{2,ifile}; %File names
        boundaries_per_audio{3,ifile}=Fs_S;  %Output Frequency sampling after segmentation process 
    end
    
end

if strcmp(segType,'phased')
    
    for ifile=1:nfiles
        
        [boundaries,Fs_S,NF]=phased_segmenter(speech_audios{1,ifile},speech_audios{3,ifile});
        
        boundaries_per_audio{1,ifile}=boundaries; %Boundaries are explained on the depiction section.
        boundaries_per_audio{2,ifile}=speech_audios{2,ifile}; %File names
        boundaries_per_audio{3,ifile}=Fs_S;  %Output Frequency sampling (of boundaries) after segmentation process
        
    end
    
end




%% -------------------------------------------------------EVALUATION----------------------------------------------------------------------------------------------------%

%Cell array where I can store all boundaries values from all segments per wav-files:
ecDist_per_audio=cell(2,nfiles);

if strcmpi(evalType,'e')
    
    for ifile=1:nfiles
        ecDist=ecDist_evaluator(speech_audios{1,ifile},boundaries_per_audio{1,ifile},boundaries_per_audio{3,ifile});
        ecDist_per_audio{1,ifile}=ecDist; %Euclidean distances per file.
        ecDist_per_audio{2,ifile}=boundaries_per_audio{2,ifile}; %File names.
    end
    
end







%% -----------------------------------------------------VISUALIZATION--------------------------------------------------------------------------------------------------%

















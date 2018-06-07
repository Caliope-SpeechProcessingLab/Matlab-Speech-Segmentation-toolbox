%--------------------------------------------MAIN-DEPICTION------------------------------------------------------------%
%----------------------------------------------------------------------------------------------------------------------%
%----------------------------------------------------------------------------------------------------------------------%

addpath('segment');
addpath('aux_Func');

%% CONFIGURABLE SETTING VARIABLES:

%SETTING string-type variables:

% Next 3 lines are questions that the program ask the user.
% 1º string variable (sT) you have to set up, is a segmentation type string, which can be:
%            -'fixed', so it will execute a fixed segmentation.
%            -'phased', so it will execute a phased segmentation.
% 2º string variable (eT) is a evaluation type string, which can be:
%            -'eulidean distance', it will perform a euclidean distance evaluation.
% 3º string variable (draw) is a visualization method string, which can be:
%            - POR DETERMINAR....


sT=input('Segmentation type: ','s');
eT=input('Evaluation method? ','s');
draw=input('visualization procedure: ','s');


%Folder and audio file selection

path='data/todasJasa_Q/';

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
%% ------------------------------------------------------SEGMENTATION--------------------------------------------------------------------------------------------------%

%Cell array where I can store all boundaries values from all segments per wav-files:
boundaries_per_Audio=cell(3,nfiles);

if strcmp(sT,'fixed')
    
    for ifile=1:nfiles
        [boundaries,Fs_S]=fixed_segmenter(speech_audios{1,ifile},speech_audios{3,ifile});
        boundaries_per_Audio{1,ifile}=boundaries;  %Boundaries are explained on the depiction section.
        boundaries_per_Audio{2,ifile}=speech_audios{2,ifile}; %File names
        boundaries_per_Audio{3,ifile}=Fs_S;  %Output Frequency sampling after segmentation process
        
    end
    
end

if strcmp(sT,'phase')
    
    for ifile=1:nfiles
        
        [boundaries,Fs_S,NF]=phased_segmenter(speech_audios{1,ifile},speech_audios{3,ifile});
        
        boundaries_per_Audio{1,ifile}=boundaries; %Boundaries are explained on the depiction section.
        boundaries_per_Audio{2,ifile}=speech_audios{2,ifile}; %File names
        boundaries_per_Audio{3,ifile}=Fs_S;  %Output Frequency sampling after segmentation process
        
    end
    
end




%% -------------------------------------------------------EVALUATION----------------------------------------------------------------------------------------------------%

%Cell array where I can store all boundaries values from all segments per wav-files:
ecDist_per_Audio=cell(2,nfiles);

if strcmp(sE,'euclidean distance')
    
    for ifile=1:nfiles
        ecDist=ecDist_evaluator(boundaries_per_Audio{1,ifile},boundaries_per_Audio{3,ifile});
        ecDist_per_Audio{1,ifile}=ecDist; 
        ecDist_per_Audio{2,ifile}=boundaries_per_Audio{2,ifile}; %File names
    end
    
end







%% -----------------------------------------------------VISUALIZATION--------------------------------------------------------------------------------------------------%

















%------------------------------------------------------MAIN----------------------------------------------------------------------------------%


% Description: main.m
% Note: to understand this description (acronism) it is assumed that you read main documentation of this project refer in...
% Main idea: This script call all block-functions that are employed in this project:
%    -1º: Setting variables: this script provides you configuring the type of segmentation, evaluation and visualization you 
%          may want to use.
%    -2º: Storing in a cell array all speech wav-files: in this section the script store all wav-file you want to analyze.
%    -3º: In case that Fs of original speech file is higher than 16000Hz, then it is reduced to 16000Hz, in order 
%         to reduce computational complexity. This is done by menas of an auxiliar function: "LP_decimation_function.m"
%    -4º: Segmentation: in this step each wav-file is fixed-segmented or phased segmented depending on what the user configured in 1º step. 
%         The output of this segmentation process are segment boundaries which data structure is explained in the main documentation file. 
%         Furthermore, this block gives us the Fs of boundary samples, and the number of filter segmentation coefficients.
%    -5º: Evaluator: in this step, an euclidean distance approach assesment between 2 consecutive segment is perform. The output 
%         of this code block are an array of euclidean distances that represent spectral-energy differences between 2 segments.
%    -6º: Plotting: this block allow to visualize the result in 2 ways:
%                      -Original x-signal with vertical dash-lines where boundary samples are located.
%                      -Original x-signal with vertical dash-lines where boundary samples are located,
%                       besides euclidean distance value down each vertical line.
%
% Version: 0.0.1 
% Copyright 11-06-2018 
% Author: Salvador Florido Llorens   Telecomunication department  (University of Malaga)
% Reviewers: Ignacio Moreno Torres   Spanish department (University of Malaga)
%            Enrique Nava Baro       Telecomunication  department (University of Malaga)



%----------------------------------------------------------------------------------------------------------------------%
%----------------------------------------------------------------------------------------------------------------------%
clear all
addpath('segment');
addpath('aux_Func');
addpath('eval');
addpath('plot');
%% CONFIGURABLE SETTING VARIABLES:-----------------------------------------------------------------------------------------------------------%

%SETTING string-type variables:

segType=input('Segmentation type ("fixed"/"phased"): ','s'); % specifies type of segmentation.
evalType=input('Evaluation type ("E": euclidean distance/A: arbitrary): ','s'); % specifies type of evaluation. 'e' euclidean distance will be executed.
plotType=input('Plot procedure ("Lines"/"LinesE"/"No": ','s'); % specifies type of plot.

%Folder and audio file selection

path='../data/';

% You can use regular expresions so select specific files b*.wav 
fileSelection='b*.wav';

%Obtaining an Struct list of all wav-file. Containing their paths, name,
%and extension.
list = dir([path fileSelection]);
nfiles=length(list);

%Creation of progress bar:
f = waitbar(0,'1','Name','Progress Bar',...
    'CreateCancelBtn','setappdata(gcbf,''canceling'',1)');
setappdata(f,'canceling',0);
percentage=1:(100/(5*nfiles)):100;
i=0;
%% ------------------------------------Storing in a cell array all wav-files data:-------------------------------------------------------------------------------------%
speech_audios=cell(3,nfiles);

for ifile=1:nfiles
    
    filei=fullfile(list(ifile).folder,list(ifile).name);
    [x,Fs]=audioread(filei);
    speech_audios{1,ifile}=x;
    speech_audios{2,ifile}=list(ifile).name;
    speech_audios{3,ifile}=Fs;
    % Check for clicked Cancel button
    if getappdata(f,'canceling')
        break
    end
    % Update waitbar and message
    i=i+1;
    waitbar(percentage(i)/(5*nfiles),f,sprintf(['(',num2str((percentage(i)/(5*nfiles))*100),'%%) Speech audio storing: Processing file ',num2str(ifile)]));
    
end

%% ------------------------------------Adjusting Fs to Fs_standard=16000 Hz for all speech files------------------------------------------------------------------------------------------------%
for ifile=1:nfiles
    if speech_audios{3,ifile}>16000
        newFs=16000;
        [xD]=LP_decimation_function(speech_audios{1,ifile},speech_audios{3,ifile},newFs);
        x=xD;
        speech_audios{1,ifile}=x;
        speech_audios{3,ifile}=newFs;
        Fs=newFs;
    end
    % Check for clicked Cancel button
    if getappdata(f,'canceling')
        break
    end
    % Update waitbar and message
    i=i+1;
    waitbar(percentage(i)/(5*nfiles),f,sprintf(['(',num2str((percentage(i)/(5*nfiles))*100),'%%) Adjusting Fs to 16000Hz: Processing file ',num2str(ifile)]));
end
%% ------------------------------------------------------SEGMENTATION--------------------------------------------------------------------------------------------------%

%Cell array where I can store all boundaries values from all segments per wav-files:
boundaries_per_audio=cell(3,nfiles);

if strcmp(segType,'fixed')
    
    L=(input('window length in ms: '))*(Fs/1000);
    O=(input('window overlap in ms: '))*(Fs/1000);
    for ifile=1:nfiles
        [boundaries,Fs_S]=fixed_segmenter(speech_audios{1,ifile},speech_audios{3,ifile},L,O);
        boundaries_per_audio{1,ifile}=boundaries;  %Boundaries are explained on the depiction section.
        boundaries_per_audio{2,ifile}=speech_audios{2,ifile}; %File names
        boundaries_per_audio{3,ifile}=Fs_S;  %Output Frequency sampling after segmentation process 
        % Check for clicked Cancel button
        if getappdata(f,'canceling')
            break
        end
        % Update waitbar and message
        i=i+1;
        waitbar(percentage(i)/(5*nfiles),f,sprintf(['(',num2str((percentage(i)/(5*nfiles))*100),'%%) Fixed Segmentation: Processing file ',num2str(ifile)]));
    end
   
end

if strcmp(segType,'phased')
    
    for ifile=1:nfiles 
        [boundaries,Fs_S,NF]=phased_segmenter(speech_audios{1,ifile},speech_audios{3,ifile});
        boundaries_per_audio{1,ifile}=boundaries; %Boundaries are explained on the depiction section.
        boundaries_per_audio{2,ifile}=speech_audios{2,ifile}; %File names
        boundaries_per_audio{3,ifile}=Fs_S;  %Output Frequency sampling (of boundaries) after segmentation process 
        % Check for clicked Cancel button
        if getappdata(f,'canceling')
            break
        end
        % Update waitbar and message
        i=i+1;
        waitbar(percentage(i)/(5*nfiles),f,sprintf(['(',num2str((percentage(i)/(5*nfiles))*100),'%%) Phased Segmentation: Processing file ',num2str(ifile)]));
    end
    
end




%% -------------------------------------------------------EVALUATION----------------------------------------------------------------------------------------------------%

%Cell array where I can store all boundaries values from all segments per wav-files:
ecDist_per_audio=cell(3,nfiles);

if strcmpi(evalType,'e')
    
    for ifile=1:nfiles
        [ecDist,x_segments]=ecDist_evaluator(speech_audios{1,ifile},boundaries_per_audio{1,ifile},boundaries_per_audio{3,ifile});
        ecDist_per_audio{1,ifile}=ecDist; %Euclidean distances per file.
        ecDist_per_audio{2,ifile}=boundaries_per_audio{2,ifile}; %File names.
        ecDist_per_audio{3,ifile}=x_segments; %speech signal segments.
        
        %Saving segments of each file:
        file_Segments=ecDist_per_audio{3,ifile};
        target=boundaries_per_audio{2,ifile};
        ind= strfind(target,'.wav');
        save(['../data/all_File_Segments/',target(1,1:ind-1),'_Segments.mat'],'file_Segments');
        % Check for clicked Cancel button
        if getappdata(f,'canceling')
            break
        end
        % Update waitbar and message
        i=i+1;
        waitbar(percentage(i)/(5*nfiles),f,sprintf(['(',num2str((percentage(i)/(5*nfiles))*100),'%%) Euclidean distance evaluation: Processing file ',num2str(ifile)]));        
    end
    
end






%% -----------------------------------------------------VISUALIZATION--------------------------------------------------------------------------------------------------%


if strcmpi(plotType,'Lines')
    for ifile=1:nfiles
        h=plot_boundary_Lines(speech_audios{1,ifile}, boundaries_per_audio{1,ifile}, speech_audios{3,ifile});
        title(['Original signal of silable: ',speech_audios{2,ifile},' | ',segType,' segmentation'],'Interpreter','none');
        saveas(h,fullfile('../data/plotsLines/', ['plotLines_',speech_audios{2,ifile},'.png']));
        % Check for clicked Cancel button
        if getappdata(f,'canceling')
            break
        end
        % Update waitbar and message
        i=i+1;
        waitbar(percentage(i)/(5*nfiles),f,sprintf(['(',num2str((percentage(i)/(5*nfiles))*100),'%%) Plotting Vertical lines: Processing file ',num2str(ifile)]));         
        %In case you want to close figure;
        close all; 
    end 
end


if strcmpi(plotType,'LinesE')
    for ifile=1:nfiles
        h=plot_boundary_LinesE(speech_audios{1,ifile}, boundaries_per_audio{1,ifile}, speech_audios{3,ifile},ecDist_per_audio{1,ifile});
        title(['Original signal of silable: ', speech_audios{2,ifile}, ' | ',segType,' segmentation and Euclidean distance between 2 consecutive segments'],'Interpreter','none');
        saveas(h,fullfile('../data/plotsLinesE/', ['plotLinesE_',speech_audios{2,ifile},'.png']));
        % Check for clicked Cancel button
        if getappdata(f,'canceling')
            break
        end
        % Update waitbar and message
        i=i+1;
        waitbar(percentage(i)/(5*nfiles),f,sprintf(['(',num2str((percentage(i)/(5*nfiles))*100),'%%) Plotting V.Lines with ecDist: Processing file ',num2str(ifile)])); 
        %In case you want to close figure;
        close all;
    end 
end

if strcmpi(plotType,'No')
     
end

delete(f)



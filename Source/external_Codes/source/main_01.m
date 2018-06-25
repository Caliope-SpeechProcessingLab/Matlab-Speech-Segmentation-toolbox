%% --------------------------------------Main------------------------------------------------------------
clear all

addpath('Feature_operator');
addpath('segment');
addpath('aux_Func');
addpath('plot');
%% ---------------------------------Configuration Code----------------------------------------------------

%1: phase segmentation.
%0: fixed segmentation.
var=logical(input('Type of segmentation (1/0): '));

%Folder and audio file selection

path='../data/';

% You can use regular expresions so select specific files b*.wav 
fileSelection='b*.wav';

%Obtaining an Struct list of all wav-file. Containing their paths, name,
%and extension.
list = dir([path fileSelection]);
nfiles=length(list);

%Creation of progress bar:
% f = waitbar(0,'1','Name','Progress Bar',...
%     'CreateCancelBtn','setappdata(gcbf,''canceling'',1)');
% setappdata(f,'canceling',0);
% percentage=1:(100/(5*nfiles)):100;
% i=0;

%% ------------------------------------Storing in a cell array all wav-files data:-------------------------------------------------------------------------------------%
speech_audios=cell(3,nfiles);

for ifile=1:nfiles
    
    filei=fullfile(list(ifile).folder,list(ifile).name);
    [x,Fs]=audioread(filei);
    speech_audios{1,ifile}=x;
    speech_audios{2,ifile}=list(ifile).name;
    speech_audios{3,ifile}=Fs;
    % Check for clicked Cancel button
%     if getappdata(f,'canceling')
%         break
%     end
%     % Update waitbar and message
%     i=i+1;
%     waitbar(percentage(i)/(5*nfiles),f,sprintf(['(',num2str((percentage(i)/(5*nfiles))*100),'%%) Speech audio storing: Processing file ',num2str(ifile)]));
%     
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
%     % Check for clicked Cancel button
%     if getappdata(f,'canceling')
%         break
%     end
%     % Update waitbar and message
%     i=i+1;
%     waitbar(percentage(i)/(5*nfiles),f,sprintf(['(',num2str((percentage(i)/(5*nfiles))*100),'%%) Adjusting Fs to 16000Hz: Processing file ',num2str(ifile)]));
end


%% ------------------------------------Checking Power Spectrum: Periodogram ------------------------------------------------------------%

for ifile=1:nfiles
    
    %Si eliges fija winlen:0.025 seg y winstep:0.01 seg, y nfft:512
    [pspec,indices] = msf_powspec(speech_audios{1,ifile},speech_audios{3,ifile},'variable',var);
    %por defecto 26 filtros, y winlen y winstep igual caso anterior.
    %logfb = msf_logfb(speech_audios{1,ifile},speech_audios{3,ifile},'variable',var);
end















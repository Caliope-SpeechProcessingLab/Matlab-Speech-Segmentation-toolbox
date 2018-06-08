function ecDist=ecDist_evaluator(boundaries,Fs)


%% ---------------------------------------------*FUNCTION DESCRIPTION*---------------------------------------------------------------------------------------------------------%
%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------%
%-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------%


%Euclidean distance evaluator algorithm. V.0.1

    %1�) The algorithm create or load the filter coefficients, for the
    %assesment.
    %2�) The algorithm call a segmentator function (SF). Currently, this
    %SF, can be 2 different functions. One is a fixed segmentation, and
    %another one is based on the korean article (instantenous phase).
    %3�) Once we have all the segments from the original signal into a cell array, 
    %the algorithm calculates euclidean (assesment) distance of 2 consecutive segments.

    %The PROCEDURE for this euclidean distance ASSESMENT is:
    
    %   1) Take one segment and its consecutive. Seg1 and Seg2.
    %   2) Filter those segments along 15 frequency bands.
    %   3) Calculates the energy of each segment band. It give us a
    %   15-Energy vector.
    %   4) Compare the 15-Energy vector of segment 1, with the  15-Energy
    %   vector of segment 2, by means of the euclidean distance.
    
    %----------------Graphic illustration----------------------------------%
    
    %                 15-band-filtered
    %   1|Segment1 ------------------------->  15-Energy vector of Seg1 (Ev1)     
    %   2|Segment2 ------------------------->  15-Energy vector of Seg2 (Ev2)
    %      .                                                ||
    %      .                                Euclidean distance of Ev1 with Ev2
    %      .                                                ||
    %   N|SegmentN                        Value represents espectral differences 
    %                                         between 2 consecutive segments
    
    
%-------------------------Variable description------------------------------%

%Configurable variables:
%
%   -segmentacion_tipo: string variable that indicates which kind of segmentation function you
%                       want to use. In case it contains 'fija', a fixed
%                       segmentation will be executed. In case it contains
%                       'fases', the korean-type segmentation will be
%                       executed.
%
%
% Constant-value variables:
%
%
% Variables within script:
%
%   -nSeg: scalar value that indicates the number of segments.
%   -iniFin: integer-value array of 2 columns and nSeg rows.
%            Those values represent the begining and ending of each segments
%            in samples. There 2 cases where those samples are from
%            different Fs from the original one.
%                  -When is a fixed segmentation, those ini-fin samples
%                  come from the original sample rate.
%                  -When is a phase instantenous segmentation, those
%                  ini-fin samples come from the sample rate used for the
%                  segmentation function. Therefore, it is important to
%                  convert them to the original ones.
%
%    *Storing segments:
%
%   -x_framedF: a matrix of nSeg rows and many columns as the length of the
%               longest-element segment. Only for fixed segmentation.
%   -x_framed: a cell array of nSeg cells, where in each cell there is a segment from the
%              original signal x, with a certain length.
%
% External Functions:
%
%
%   -results: is a matrix that contains 3 columns and nfiles rows. It contains
%             information about the number of segments, its
%             euclidean distance mean, and euclidean distance sum in each wav-file.
%
%
%
%
%
%
%
%
%
%
%
%
% Version: 0.1   Date:04/06/2018
% Copyrigth: Salvador Florido Llorens

%% ------ STEP 1: Check if filter bank coefficients are created. If so, they have to be loaded. ------------------------------------------------------------------------------------------------------%

existe=exist('filtros.mat');
if existe==2
    %CASO EXISTEN LOS FILTROS, LOS CARGAMOS:
    load('filtros.mat');
else
    [filtros,N]=filterMatrix_Loader(16000);
    save('filtros.mat','filtros');
end


%% -------STEP 2: Checking if Fs is greater than 16000Hz before bank filtering process. If so, array signal "x"---------------------------------------------------------------------------------------------------%
%                 is decimated to 16000Hz, by means of calling function "LP_decimation_function".

%   Becareful if Fs<16000 Hz!!!!!!!!!!
if Fs>16000
    newFs=16000;
    [xD]=LP_decimation_function(x,Fs,newFs);
    Fs=newFs;
end
x=xD;

%% -------STEP 3: Signal segment storing process in a cell array: x_segments:

nSeg=length(boundaries(:,1));
x_segments=cell(1,nSeg);

for i=1:nSeg
   x_segments{1,i}=x(boundaries(i,1):boundaries(i,2)); 
end




%% -------STEP 4: each segment is being 15-band filtered, and its 15-band energy is calculated and stored.----------------------------------------------------------------------------------------

nBands=15;
ecDist=zeros(nSeg-1,1);
jEnergiesSeg=zeros(m,15);

%For a certain segment: Filtering and calculating its energy.
for i=1:nSeg %Segment by segment loop.
    for j=1:nBands %Band by band loop.
        
        jBandSeg=(filter(filtros{j},1,x_segments{i}))';
        jEnergiesSeg(i,j)=sum(jBandSeg.^2)./length(jBandSeg);
        
    end
end

%  For a certain segment i, the euclidean distance between its 15-energy vector
%  and the one for i+1 segment is calculated.
for i=1:nSeg-1 %Segment by segment loop.
    
    ecDist(i,1)=euclidean_Distance(jEnergiesSeg(i,:),jEnergiesSeg(i+1,:));
    
end
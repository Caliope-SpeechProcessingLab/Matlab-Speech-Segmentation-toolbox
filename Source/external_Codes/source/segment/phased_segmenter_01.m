function [boundaries,Fs_S,NF,x_segments]=phased_segmenter_01(x,Fs)

%% ------------------------------------------phased_segmenter------------------------------------------------------------------------------------------------------------------------------------

% Description: [boundaries,Fs_S,NF]=phased_segmenter(x,Fs)
% Note: to understand this description (acronism) it is assumed that you read main documentation of this project refer in...
%
% Main idea: this script generates boundaries samples which are the beginning and ending points of segments in signal x. Those boundaries samples are chosen where x-envelope instantenous phase
% changes its value.
%
% Input variables:
%   x: double array of amplitudes values of speech wav-file.
%   Fs: sampling frequency of x-samples.
%
% Output variables:
%   boundaries: the beginning and ending segment samples from the original signal (x). 
%   Fs_S: sampling frequency of those boundaries samples.
%   NF:  number of coefficient required for the filter involved in segmentation.
%
% Programming note: indexes of the instantenous phase array are identical  to the envelopeFiltered ones.
%
% Version: 0.0.1 
% Copyright 11-06-2018 
% Author: Salvador Florido Llorens   Telecomunication department  (University of Malaga)
% Reviewers: Ignacio Moreno Torres   Spanish department (University of Malaga)
%            Enrique Nava Baro       Telecomunication  department (University of Malaga)


%% STEP 1: Calculation of hilbert transform, and envelope of new decimated signal.------------------------------------------------------------

xH = hilbert(x);
xIm=imag(xH);  %Resultado Transformada de hilbert. Calculo parte imaginaria.
envelope=sqrt(x.^2+xIm.^2); %Envelope calculation

%% STEP 2: Designing a Multirate filter for theta band filtering of envelope.---------------------------------------

%Designing the segmentation filter.
%[NF,b]=segmentation_Filter(newFs,bandType);
newFs=64; %Fs of signal before theta band filtering.
[filteredEnvelope,NF]=multiStage_segmentationFilter_01(envelope,Fs,newFs);
%Filtering envelope.
%filteredEnvelope=filter(b,1,envelope);

%% STEP 3: Obtaining instantenous phase from the filtered envelope.---------------------------------------------------------------------------

fE = hilbert(filteredEnvelope);
xImFb=imag(fE);

%Four-Quadrant Inverse Tangent. To obtain phases from the 4 quadrants
fasesFirstBand=atan2(xImFb,filteredEnvelope);    %from [-pi,pi]

%% STEP 4: Obtaining an array that contains the filtered envelope indexes of a certain phase quadrant.----------------------------------------------

quad1=fasesFirstBand>=-pi & fasesFirstBand<=-(pi/2);
quad2=fasesFirstBand>=-(pi/2) & fasesFirstBand<=-0;
quad3=fasesFirstBand>=0 & fasesFirstBand<=(pi/2);
quad4=fasesFirstBand>=(pi/2) & fasesFirstBand<=pi;

segmentedsignal=quad1+2*quad2+3*quad3+4*quad4;

% Median filtering to avoid very small transitions
segmentedsignal=medfilt1(segmentedsignal,5);



i1=[];cnt1=1;
i2=[];cnt2=1;
i3=[];cnt3=1;
i4=[];cnt4=1;

for i=1:length(segmentedsignal)
    if segmentedsignal(i)==1
        i1(cnt1)=i;
        cnt1=cnt1+1;
    end
    if segmentedsignal(i)==2
        i2(cnt2)=i;
        cnt2=cnt2+1;
    end
    if segmentedsignal(i)==3
        i3(cnt3)=i;
        cnt3=cnt3+1;
    end
    if segmentedsignal(i)==4
        i4(cnt4)=i;
        cnt4=cnt4+1;
    end 
end

%% Step 5: Get the begining and ending point of each segment.------------------------------------------------------------------------------------%

transiciones=find(diff(segmentedsignal)~=0);
nSeg=length(transiciones)+1;

inicio=zeros(nSeg,1);
final=zeros(nSeg,1);

for i=1:nSeg
    if i>1 && i~=nSeg
        final(i)=transiciones(i);
        inicio(i)=final(i-1)+1;
    end
    if i==1
        final(i)=transiciones(i);
        inicio(i)=1;
    end
    if i==nSeg
        final(i)=length(filteredEnvelope);
        inicio(i)=final(i-1)+1;
    end
end

boundaries=[inicio final]; %¿Pos-procesado segmentos sin contenido?
%Fs_S=newFs;

%% Step 6: change Fs of boundaries samples back to original input Fs.----------------------------------------------------------------------------------%

conversion_factor=(Fs/newFs);
boundaries=boundaries.*conversion_factor;
[m,n]=size(boundaries);
boundaries(m,n)=length(x);

Fs_S=Fs;

%% Step7: Store speech signal segments from boundaries.------------------------------------------------------
nSeg=length(boundaries(:,1));
x_segments=cell(1,nSeg);

for i=1:nSeg
   x_segments{1,i}=x(boundaries(i,1):boundaries(i,2));
end







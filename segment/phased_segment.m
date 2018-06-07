function [boundaries,Fs_S,NF]=phased_segmenter(x,Fs)

%% Description:------------------------------------------------------------------------------------------------------------------------------------

%Main idea: indexes of the instantenous phase array are identical to the
%envelopeFiltered ones.
%IN WORK
%---------------------------------------------------------------------------------------------------------------------------------------------

%% STEP 1: Resample at 1000 Hz, needed for theta band adcquisition, by means of "LP_decimation_function".---------------------------------------------------------------------------------------------------------%       

newFs=1000;
[xD]=LP_decimation_function(x,Fs,newFs);


%% STEP 2: Calculation of hilbert transform, and envelope of new decimated signal.------------------------------------------------------------

xH = hilbert(xD);
xIm=imag(xH);  %Resultado Transformada de hilbert. Calculo parte imaginaria.
envelope=sqrt(xD.^2+xIm.^2); %Envelope calculation

%% STEP 3: Designing a filter which is going to be used for the segmentation process. And filtering envelope.---------------------------------------

%Designing the segmentation filter.
bandType='theta';
[NF,b]=segmentation_Filter(newFs,bandType);


%Filtering envelope.
filteredEnvelope=filter(b,1,envelope);

%% STEP 4: Obtaining instantenous phase from the filtered envelope.---------------------------------------------------------------------------

fE = hilbert(filteredEnvelope);
xImFb=imag(fE);

%Four-Quadrant Inverse Tangent. To obtain phases from the 4 quadrants
fasesFirstBand=atan2(xImFb,filteredEnvelope);    %from [-pi,pi]

%% STEP 5: Obtaining an array that contains the filtered envelope indexes of a certain phase quadrant.----------------------------------------------

quad1=fasesFirstBand>=-pi & fasesFirstBand<=-(pi/2);
quad2=fasesFirstBand>=-(pi/2) & fasesFirstBand<=-0;
quad3=fasesFirstBand>=0 & fasesFirstBand<=(pi/2);
quad4=fasesFirstBand>=(pi/2) & fasesFirstBand<=pi;

segmentedsignal=quad1+2*quad2+3*quad3+4*quad4;

% Median filtering to avoid very small transitions
segmentedsignal=medfilt1(segmentedsignal,40);
segmentedsignal=round(segmentedsignal,0);


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

%% Step 6: Get the begining and ending point of each segment.------------------------------------------------------------------------------------

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
        final(i)=length(xD);
        inicio(i)=final(i-1)+1;
    end
end

boundaries=[inicio final]; %¿Pos-procesado segmentos sin contenido?
Fs_S=newFs;

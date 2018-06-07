function [boundaries,Fs_S]=fixed_segmenter(x,Fs)

L=input('window length in ms: ');
R=input('window shift in ms: ');

M=length(x);

if R~=0 %Con solapacion
    splitter=1:R:M-L+1;
    inii=splitter';
    fini=splitter'+L-1;
    boundaries=[inii fini];
end
if R==0 %Sin solapacion
    
    splitter=1:L-1:M;   %Clave L-1
    splitter=[splitter M];
    nSeg=length(splitter)-1;
    boundaries=zeros(nSeg,2);
    for k=1:nSeg
        if k==1
            boundaries(k,1:2)=[splitter(1,k) splitter(1,k+1)]; %when k=1
        end
        if k>1 && k<nSeg
            boundaries(k,1:2)=[(boundaries(k-1,2)+1) (splitter(1,k+1)+k-1)];
        end
        if k==nSeg
            boundaries(k,1:2)=[(boundaries(k-1,2)+1) splitter(1,k+1)]; %when k==NSeg
        end
    end
    Fs_S=Fs;
end
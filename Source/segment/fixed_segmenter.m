function [boundaries,Fs_S]=fixed_segmenter(x,Fs,L,O)

R=L-O;
M=length(x);

if R<L %Con solapacion
    splitter=1:R:M-L+1;
    inii=splitter';
    fini=splitter'+L-1;
    boundaries=[inii fini];
    Fs_S=Fs;
end
if R==L %Sin solapacion
    
    splitter=1:L:M-L+1;   %Clave L-1
    inii=splitter';
    fini=splitter'+L-1;
    boundaries=[inii fini];
    Fs_S=Fs;
end
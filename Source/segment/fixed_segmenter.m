function [boundaries,Fs_S]=fixed_segmenter(x,Fs,L,O)

%% -------------------------------------------------------fixed_segmenter.m-------------------------------------------------------------------------------------------------------

% Description: [boundaries,Fs_S]=fixed_segmenter(x,Fs,L,O)
% Note: to understand this description (acronism) it is assumed that you read main documentation of this project refer in...
%
% Main idea: this script generates boundaries samples which are the beginning and ending points of segments in signal x. That boundary sample selection is based on a fixed quentity. 
% Therefore the entire signal is divided in frames of the same length except last one.
%
% Input variables:
%   x: double array of amplitudes values of speech wav-file.
%   Fs: sampling frequency of x-samples.
%   L: window length (samples).
%   O: overloap (samples);
%
% Output variables:
%   boundaries: the beginning and ending segment samples from the original signal (x). 
%   Fs_S: sampling frequency of those boundaries samples.
%   
%
% Programming note: There are 2 cases, when there´s no overlapping and when overlapping is not zero.
%
% Version: 0.0.1 
% Copyright 11-06-2018 
% Author: Salvador Florido Llorens   Telecomunication department  (University of Malaga)
% Reviewers: Ignacio Moreno Torres   Spanish department (University of Malaga)
%            Enrique Nava Baro       Telecomunication  department (University of Malaga)



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
function [coeffs,NF]=segmentation_Filter(Fs,sT)

switch sT
    case 'theta'
        Fp1=4; Fp2=10;
    case 'gamma'
        Fp1=25; Fp2=35;
    case 'customizable'
        Fp1=input('First frequency passband: ');
        Fp2=input('Second freuency passband: ');
end
        

Fst1 = Fp1-3;
Fst2 = Fp2+3;
Ap=3;
Ast1=40;
Ast2=40;
Hf = fdesign.bandpass('Fst1,Fp1,Fp2,Fst2,Ast1,Ap,Ast2',Fst1,Fp1,Fp2,Fst2,Ast1,Ap,Ast2,Fs);

H= design(Hf,'equiripple');
NF=length(H.numerator);
coeffs=H.numerator;
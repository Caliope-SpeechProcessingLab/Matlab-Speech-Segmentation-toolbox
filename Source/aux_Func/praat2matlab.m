
function praatFeat=praat2matlab(praatfilename,matfilename)


fid = fopen(praatfilename, 'r'); % opción rt para abrir en modo texto
caca=(textscan(fid,'%s',4,'Delimiter','\n'))';

for i=1:1
  feat(i,1) = textscan(fid,'%f ',16385,'Delimiter',' ');
  praatFeat(i,1:16385)=feat{i,1};
end

save (matfilename,'praatFeat');


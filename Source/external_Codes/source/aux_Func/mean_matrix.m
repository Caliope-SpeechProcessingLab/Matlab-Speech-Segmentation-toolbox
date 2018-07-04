

function means=mean_matrix(minNFrames,c,speech_features,nfiles)

s=zeros(1,nfiles);
for i=1:minNFrames
    for j=1:c
        for ifile=1:nfiles
            feature=speech_features{1,ifile};
            s(1,ifile)=feature(i,j);
        end
        means(i,j)=mean(s);
    end 
end
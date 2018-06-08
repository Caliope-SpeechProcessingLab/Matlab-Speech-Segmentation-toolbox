function D_ec=euclidean_Distance(x,y)
%Hay que meter los array en 1xN
dimx=size(x);
dimy=size(y);

if dimx(1)==1 && dimy(1)==1
    suma=0;
    if dimx(2)>dimy(2) %Caso x sea mas largo que y
        
        ceros=zeros(1,dimx(2)-dimy(2));
        y=[y ceros];
        for i=1:length(x)
            diff2=(x(i)-y(i)).^2;
            suma=suma+diff2;
        end
        D_ec=sqrt(suma);
    else 
        if dimx(2)<dimy(2) %Caso y sea mas largo que x
            
            ceros=zeros(1,dimy(2)-dimx(2));
            x=[x ceros];
            for i=1:length(x)
                diff2=(x(i)-y(i)).^2;
                suma=suma+diff2;
            end
            D_ec=sqrt(suma);
        end
    end
    if dimx(2)==dimy(2) %Caso tengan mismo tamaño
        for i=1:length(x)
            diff2=(x(i)-y(i)).^2;
            suma=suma+diff2;
        end
        D_ec=sqrt(suma);
    end   
end

if dimx(1)>1 && dimy(1)>1 && dimx(1) == dimy(1) %Caso sean matrices
    suma=0;
    for i=1:length(x(1,:))
        for j=1:length(x(1,:))
            
            diff2=(x(i,j)-y(i,j)).^2;
            suma=suma+diff2;
            
        end
    end
    
    D_ec=sqrt(suma);
end


end


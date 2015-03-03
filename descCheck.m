function [ indices2 ] = descCheck( d, indices, badValueLim )
%WORK IN PROGRESS. Returns the indices which have the desired behvaior of their 4 center
%descriptors. Checks how many of the 4 descriptors squares are point out
%from the center between the 4 squares and if more than badValueLim doesnt
%point outwards this script will remove that indice from being a candidate
%to be a detected marker point.
%   Detailed explanation goes here


willrm = [];
badValue = 0;
for k=1:length(indices)
    for i=[41 49 73 81] %Första raden av 8 i de descriptor rutor i mitten
        d2=single(d); %Gör om d matrisens värden så att de går att räkna med
        
        %x är då man summerar alla pilar med sin vinkel och skala på
        %x-axeln
        %y är samma fast på y-axeln
        x=d2(i,indices(k))-d2(i+4,indices(k))+d2(i+1,indices(k))*1/sqrt(2)-d2(i+3,indices(k))*1/sqrt(2)-d2(i+5,indices(k))*1/sqrt(2)+d2(i+7,indices(k))*1/sqrt(2);
        y=-d2(i+2,indices(k))+d2(i+6,indices(k))-d2(i+1,indices(k))*1/sqrt(2)-d2(i+3,indices(k))*1/sqrt(2)+d2(i+5,indices(k))*1/sqrt(2)+d2(i+7,indices(k))*1/sqrt(2);

        if i == 41
            if ~(x<0 && y>0)
                badValue = badValue +1;
            end

        end
        if i == 49
                if ~(x>0 && y>0)
                badValue = badValue +1;
                end
        end
        
        if i == 73
            if ~(x<0 && y<0)
                badValue = badValue +1;
            end
        end
        
        if i == 81
            if ~(x>0 && y<0)
                badValue = badValue +1;
            end
        end
        if badValue > badValueLim %break loop if we already have enough bad values and remove indice instantly.
            willrm = [willrm +k];
            break
        end
        indices2= indices;
        indices2(willrm) = []; 
    end
    

        
        badValue = 0;
    
end

end


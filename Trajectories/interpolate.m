function [vector]=interpolate(points,indices)
%Interpolate all the 0s in points with indices indices. Returns a vector
%with interpolated 0s.

%define variables
i=1;
start=0;
stop=0;
vector=points;
%go through all indices, last point cannot be interpolated so no use in
%checking that
while i<=length(indices)-1
    %nbr of points that is 0
    nbr=1;
    %start index for the first 0
    start=indices(i);
    j=i;
    %exception when there is only one 0
    if~(indices(j+1)==indices(j)+1)
        stop=indices(i);
        nbr=1;
    else
        %find where the "gap" stops
        while indices(j+1)==indices(j)+1
            
            nbr=nbr+1;
            j=j+1;
            stop=indices(j);
            if(j==length(indices))
                break
            end
        end
    end
    %value to add at each time to get the correct interpolation
    val=(points(stop+1)-points(start-1))/(nbr+1);
    %fill in the gap
    for k=start:stop
        vector(k)=vector(k-1)+val;
    end
    %continue after the gap
    i=stop;
end

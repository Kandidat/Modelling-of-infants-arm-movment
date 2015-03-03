function [ indices ] = grayfilter( lim, r, grayimg, indices, f )
% Check in a square area around a given point to see if the values around
% and on that point are lighter than a specific limit, lim. size of
% square-side is r. Checking the values on the grayscale img "grayimg". f
% parameter is the vector from sift indices parameter are the points to
% check. Returns the indices which are not filtered out.s
%   Detalied explanation goes here
tmpindices=indices;

for k=1:length(indices)
    for i=1:(r+1)
       for j=1:(r+1)
           if (round(f(2,indices(k)))>=length(grayimg(:,1)))
               j=0;
           elseif (round(f(1,indices(k)))>=length(grayimg(1,:)))
               i=0;
           end
           tempval = grayimg(round(f(2,indices(k)))-r+j,round(f(1,indices(k)))-r+i);
        
       end
    end
    if tempval>lim
       tmpindices(k)=999999999;
    end
end
tmp=find(tmpindices<9999999);
indices=tmpindices(tmp);

end


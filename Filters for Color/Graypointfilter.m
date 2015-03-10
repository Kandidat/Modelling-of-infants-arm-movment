function idx=Graypointfilter(I,f,lim);
%--------------------------------------------------------------------------
%Returns the indecies of the keypoints that have a mean-value of pixel 
%neighbourhood with the scale of the keypoint as radius bellow a given
%limit
%REQUREMENTS: function neighbour
%INPUT:
%       I - Is a Grayimage array
%       f = is the keypoint matrix from running I in vl_sift
%       lim = limit of mean-value (0-255)
%
%OUTPUT:
%
%       idx = the columns of f which fulfills the conditions
%--------------------------------------------------------------------------
xy=round(f(1:2,:));

d=ceil(f(3,:));

k=1;
for i = 1:size(f,2)
    
    neigh=Neighbour(I,xy(:,i),d(i));
    if neigh==0
        intensity=0; %probably not necessary, just in case something goes wrong
    else
    intensity=mean(neigh(neigh>0));
    end
    
    %disp(neigh)
    if intensity<lim
        idx(k)=i;
        k=k+1;
    end
end
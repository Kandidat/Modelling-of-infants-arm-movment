function idx = Gradfilter(I,f,p,thresh,numb);
%--------------------------------------------------------------------------
%Filters out keypoints that doesen't satisfie the condition on the
%difference in value between keypointarea and pixels laying at a distance p
%outside the area.
%REQUREMENTS: function neighbour
%INPUT:
%       I - Is a gray-image
%       f = is the keypoint matrix from running I in vl_sift
%       p = dustance outsice the keypoint area (circle) from which pixel
%       should be compared
%       thresh = condition on the magnitude of the difference
%       numb = number of directions that the thresh must be fullfilled (8 directions, multiplicities of pi/4)
%       
%OUTPUT:
%
%       idx = the columns of f which fulfills the conditions
%--------------------------------------------------------------------------
grad=Dgradients(I,f,p);
[m n]=size(f);
j=1;
for i = 1:n
    true=find(grad(:,i)<-thresh);
    
    if length(true)>=numb
        idx(j)=i;
        j=j+1;
    end
end
function idx=ColorfilterHSV(I,f);
%--------------------------------------------------------------------------
%Filters out keypoints that don't meet the requirements of Hue and
%saturation for some blue or red areas. The requirements are set from
%empirical study.
%REQUREMENTS: function neighbour
%INPUT:
%       I - Is an RGB image
%       f = is the keypoint matrix from running I in vl_sift
%       
%OUTPUT:
%
%       idx = the columns of f which fulfills the conditions
%--------------------------------------------------------------------------
I=rgb2hsv(I); %converting image to HSV
xy=round(f(1:2,:)); %extracting the coordinates of the points

d=ceil(f(3,:)); %d is the scale of the keypoint, used as radius of the area
idx=[];
k=1;
for i = 1:size(f,2)
    
    neigh=Neighbour(I,xy(:,i),d(i)); %extracting pixels from keypoint area
    
    H=neigh(:,:,1); %HUE
    S=neigh(:,:,2); %SATURATION
    V=neigh(:,:,3); %VALUE search wikipedia for further explanation of parameters
    
    %Mean value of the different parameters
    Hmean=mean(H(H>0));
    Smean=mean(S(S>0));
    Vmean=mean(V(V>0));
    
    if Hmean>0.55 && Hmean<0.6 %probable range of hue parameter for blue point
        
        if Smean>0.45          
            if Vmean>0.4
            
            idx(k)=i;
            k=k+1;
            end
        end
    elseif  Hmean>0.65 %probable range of hue for red points (max is 1)
        
        if Smean>0.4
            if Vmean>0.4
            
            idx(k)=i;
            k=k+1;
            end
    end
        
    end
end
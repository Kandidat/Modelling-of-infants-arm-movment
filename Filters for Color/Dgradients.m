function grad=Dgradients(I,f,p)
%--------------------------------------------------------------------------
%Returns a matrix with differences of pixel intensity for each keypoint in 
%f. The Rows represents the differenses in 8 directions between pixel at keypoint
%location and a pixel in a direction r*pi/4 at the distance d.
%
%INPUT:
%       I = is a grayimage with keypoints f
%       f = Matrix representeing the sift keypoints
%       p = the distance outside the keypointarea that should be subtracted
%
%OUTPUT:
%       grad = is a matrix with 8 rows representing the differencies for each
%       direction. The directions are multiples of pi/4 (pi/4 to 2pi)
%--------------------------------------------------------------------------


xy=round(f(1:2,:));
[m n]=size(xy);
grad=zeros(8,n);
d=round(f(3,:));
[Im In]=size(I);
% looping over the keypoints to creat 'gradients'
for i = 1:n
    x=xy(1,i);
    y=xy(2,i);
 mainpixel=I(y,x);
 %looping over the directions of each point
    for r = 1:8
        ynew=y+round((p+d(i))*sin(r*pi/4));
        xnew=x+round((p+d(i))*cos(r*pi/4));
        % if statements to ensure dimensions are not exceeded
        if xnew>In
            xnew=In;
        end
        if xnew<1
            xnew=1;
        end
        if ynew>Im
            ynew=Im;
        end
        if ynew<1
            ynew=1;
        end
        %store 'gradient' in matrix
        grad(r,i)=mainpixel-I(ynew,xnew);
    end
end
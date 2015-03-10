function fnew=Filter(I,f)
%--------------------------------------------------------------------------
%Filter returns the filtered set of keypoints fnew given an RGB image with
%corresponding SIFT-keypoints f
%
%REQUIREMENTS:
%ColorfilterHSV.m , Dgradients.m , Gradfilter.m , Graypointfilter , and
%Neighbour.m 
%
%INPUT:
%       I = RGB image
%       f = matrix containing inofrmation of the SIFT-keypoints from that
%       image obtained with vl_sift from the VLFEAT toolbox
%
%OUTPUT:
%       fnew = The filtered out keypoints
%
% I must be an RGB image
%Filters out keypoints...
%Requires bunch of functions...
%Very Matlab! Much WOW! 
%--------------------------------------------------------------------------

Igry=single(rgb2gray(I));
idxg=Graypointfilter(Igry,f,75);
idxc=ColorfilterHSV(I,f);
%The section bellow prevents storing same keypoint twice and merges the
%result from Colorgilter and Graypointfilter
%--------------------------------------------------------------------------
i=ismember(idxg,idxc);

idxg=idxg(i==0);

idx=[idxg idxc];

fnew=f(:,idx);
%--------------------------------------------------------------------------
%Finally Gradfilter is applied to refine set
idx=Gradfilter(Igry,fnew,4,20,6);

fnew=fnew(:,idx);
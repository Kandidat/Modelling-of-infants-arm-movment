function fnew=Filter(I,f)
%--------------------------------------------------------------------------
% I must be an RGB image
%Filters out keypoints...
%Requires bunch of functions...
%Very Matlab! Much WOW! 
%--------------------------------------------------------------------------

Igry=single(rgb2gray(I));
idxg=Graypointfilter(Igry,f,75);
idxc=ColorfilterHSV(I,f);

i=ismember(idxg,idxc);

idxg=idxg(i==0);

idx=[idxg idxc];

fnew=f(:,idx);

idx=Gradfilter(Igry,fnew,4,20,6);

fnew=fnew(:,idx);
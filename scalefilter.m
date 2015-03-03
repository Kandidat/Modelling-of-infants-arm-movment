function [ indices] = scalefilter( min,max, f )
% Returns the indices which are not filtered out. Parameters min and max
% gives the desired intervall of scale values of f to keep. f is the matrix
% from SIFT.
%   Good values of min = 2.5, max = 4.2

indices = find(f(3,:)>max); 
f(3,indices) = 0; 
indices = find(f(3,:)<min); 
f(3,indices) = 0; 
indices = find(f(3,:)>0); 

end


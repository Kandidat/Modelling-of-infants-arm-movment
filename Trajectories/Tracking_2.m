clear variables
%--------------------------------------------------------------------------
%This file is supposed to track keypoints(SIFT) through a number of frames usig 
%vl_ubcmatch to match the keypoints between frames. A match = trajectory.
%The program saves trajectories of continous matches through frames
%
%Authors: Knut and Lukas
%
%--------------------------------------------------------------------------

obj = VideoReader('Infant_1.avi');
n = 10; 
A = read(obj,[1 n]);
F=cell(n,1);
D=cell(n,1);
%--------------------------------------------------------------------------
%The following for-loop is collecting the discriptors and keypoints
%from the loaded frames and storing them in the cell matrices D and F
%--------------------------------------------------------------------------
for i = 1:n
    
I=single(rgb2gray(A(:,:,:,i)));
    
[f,d]=vl_sift(I,'PeakThresh',2,'Octaves',3);

idx=Graypointfilter(I,f,80);
fnew=f(:,idx);
dnew=d(:,idx);
idx=Gradfilter(I,fnew,3,20,6);
fnew=fnew(:,idx);
dnew=dnew(:,idx);

F{i}=fnew;
D{i}=dnew;

end

%--------------------------------------------------------------------------
%Here the array containing all the structures of every trajectory is
%initiated, frame 1 and 2 are being matched and from the matches
%trajectories are being stored in T
%
%The structure contains the fields 'x','y','frame' and 'name', x and y
%field contains the coordinates of the keypoints that have been matched
%which are obtained from the cell array F,
%
%'frame' contains the frames where the matches have been found
%
%'name' is the name of the trajectory (number,obsolete in this case becaus
% the the row in T corresponds to the trajectory number). also containing
% the most recent match
%
%--------------------------------------------------------------------------
%%
[matches,scores]=vl_ubcmatch(D{1},D{2});
for j = 1:size(matches,2)
    
    T(j)=struct('x',[F{1}(1,matches(1,j)) F{2}(1,matches(2,j))],'y',[F{1}(2,matches(1,j)) F{2}(2,matches(2,j))],'frame',[1 2],'name',[j matches(2,j)]);
end
%Matches old is used to se if any of the matched descriptor in the last
%frame alo matches to the next to build a trajectory.
%
%For example descriptor 1 in frame 1 has a match whith descriptor 1 in
%frame 2, does the descriptor in frame 2 match any descriptor in frame 3?
%matches old stores the descriptor(index) from frame 2 to se if it got a
%match in frame 3 and thus building a continuous trajectory
matchesold=[matches(2,:);1:size(matches,2)]; % contains two rows first with the matches(indecies) and second with name on the trajectory
%--------------------------------------------------------------------------
%The following loop finds the trajectories
%--------------------------------------------------------------------------

for j = 2:n-1
    
    [matches,scores]=vl_ubcmatch(D{j},D{j+1});
    i=1;
    matchesnew=zeros(size(matches));
    %step trough evrey match to se if it is a continuing trajectory
    for k = 1:size(matches,2)
    %if any of the new descriptors are found among the old matches the they should
    %continue a trajectory
    if any(matchesold(1,:)==matches(1,k))>0 %any returns a 1 i any element in old is equal to current match being investigated
        %disp('hej')
        p=find(matchesold(1,:)==matches(1,k));% finding which element in old that was equal to current match
        
        if length(p)>1
            if matchesold(2,p(1))&matchesold(2,p(1))>length(T)
                disp('hej')
            end
        end
        
        %Here we store new data into the existing structures in T, note
        %that we get the index from the second row in matches where the
        %trajectory 'name' is stored do access the right structure in T
        %(matchesold(2,p(1))) and then storing the data from F into the
        %structure fields
        
        % 'x' value stored
        T(matchesold(2,p(1))).x(size(T(matchesold(2,p(1))).x,2)+1)=F{j+1}(1,matches(2,k));
        
        % 'y' value stored
        T(matchesold(2,p(1))).y(size(T(matchesold(2,p(1))).y,2)+1)=F{j+1}(2,matches(2,k));
        
        % 'frame' stored
        T(matchesold(2,p(1))).frame(size(T(matchesold(2,p(1))).frame,2)+1)=j+1;
        
        %store trajectory number and matches into matches new which is just
        %a middle step to not overwrite matchesold
        %(matchesnew-->matchesold)
        matchesnew(:,i)=[matches(2,k);matchesold(2,p(1))];
        i=i+1;
    else
        %This is what happens if there are a new keypoint that has been
        %matched
        T(length(T)+1)=struct('x',[F{j}(1,matches(1,k)) F{j+1}(1,matches(2,k))],'y',[F{j}(2,matches(1,k)) F{j+1}(2,matches(2,k))],'frame',[j j+1],'name',[j matches(2,k)]);
        matchesnew(:,i)=[matches(2,k);length(T)+1];
        i=i+1;
    end
    end
    
    matchesold=matchesnew;
    
end
    
for i = 1:length(T)
    plot(T(i).x,T(i).y)
    hold on
    axis([0 720 0 576])
end
    
    
function [vector] = closest(oldpoints,newpoints)
%finds the closest points in newpoints and compares with oldpoints. Returns
%a vector with values from newpoints with the closest values at the same
%postion as in oldpoints.
%

%define variables
diff=zeros(length(oldpoints),length(newpoints));
vector=zeros(size(oldpoints));

%find the prioty for each value in newpoint(lowest diff=higest prio)
for i=1:length(oldpoints)
    for j=1:length(newpoints)
        diff(i,j)=abs(oldpoints(i)-newpoints(j));
    end
end

%put the values at the correct place
while (min(min(diff))<9000)
    
    [row,col]=findrowcol(diff);
    vector(row)=newpoints(col);
    diff(row,:)=9999;
    diff(:,col)=9999;
    
end


% 
% vector=zeros(1,length(oldpoints));
% diff=zeros(length(oldpoints),length(oldpoints));
% pos=zeros(length(oldpoints),length(oldpoints));
% 
% 
% 
% for i=1:length(oldpoints)
%     for j=1:length(newpoints)
%         diff(i,j)=abs(oldpoints(i)-newpoints(j));
%         pos(i,j)=i;
%     end
% end
% diff;
% col=0;
% for i=1:length(newpoints)
%     minv=9999;
%     %     for i=1:length(oldpoints)
%     
%     for j=1:length(newpoints)
%         if(minv>diff(j,i))
%             minv=diff(i,j);
%             col=j;
%             
%             posv=i;
%         end
%     end
%     %     end
%     vector(posv)=newpoints(col);
%     diff(posv,:)=9999;
% end


function [row,col] = findrowcol(A)
%find the row and column for the smallest value in A
min=9999999;
row=0;
col=0;
for i=1:length(A(:,1))
    for j=1:length(A(1,:))
        if(A(i,j)<min)
            row=i;
            col=j;
            min=A(i,j);
        end
    end
end
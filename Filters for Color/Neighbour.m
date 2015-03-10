function neigh=Neighbour(M,p,d);
%--------------------------------------------------------------------------
%Extracts the pixels from the image M up to distance d(pixels) from
%the point p.
%
%INPUT:
%       M - Is an image array
%       p = [X Y] - must be integers is a vector containing the coordinates
%       of the point
%       d = Is the distance point or radius of the area from which pixels
%       are extracted
%
%OUTPUT:
%
%       neigh= Is a square matrix with the pixel from point p in the middle
%       and zeros where the pixels are to far from the center.
%
%--------------------------------------------------------------------------
[mM, nM, dM]=size(M);

fromrow=p(2)-d;
torow=p(2)+d;

fromcol=p(1)-d;
tocol=p(1)+d;
%--------------------------------------------------------------------------
%coditions that must be fulfilled so that the dimensions of M are not
%exceeded
%--------------------------------------------------------------------------
if fromrow<1
    fromrow=1;
end
if torow>mM
        torow=mM;
end

if fromcol<1
    fromcol=1;
end

if tocol>nM
        tocol=nM;
end

neighsquare=M(fromrow:torow,fromcol:tocol,:); %Extracting square around point p
%Cheking distance to middle ponit and sets value to zero if condition is
%not met.
for i = 1:d
    for j = 1:d
    if round(sqrt(((d+1)-i)^2+((d+1)-j)^2))>d %Pythagorean
        %Here Symmetry of the matrix-dimensions i used so that only one
        %fourth of the squre need to be checked.
        neighsquare(i,j,:)=0;
        neighsquare(2*(d+1)-i,j,:)=0;
        neighsquare(i,2*(d+1)-j,:)=0;
        neighsquare(2*(d+1)-i,2*(d+1)-j,:)=0;
    end
    end
end

neigh=neighsquare;
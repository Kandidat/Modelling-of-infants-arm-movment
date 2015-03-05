function [xmin,ymin,xmax,ymax]=direction(X1,X2,r)
%X1 is the previous position. X2 is the current. r is the radius.

grad=X2-X1;

stepsize=sqrt(grad(1)^2+grad(2)^2);

x=X2(1)+grad(1)*stepsize;
y=X2(2)+grad(2)*stepsize;

xmin=x-r;
xmax=x+r;
ymin=y-r;
ymax=y+r;
end

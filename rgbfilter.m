function [indices] = rgbfilter(limit,img,indices,f)
%f(x,y,s,o), pic(y,x,rgb)


limit=limit+1;
tmpindices=indices;
for i=1:length(indices)
    
    x=round(f(2,indices(i)));
    y=round(f(1,indices(i)));
    r=single(img(x,y,1));
    g=single(img(x,y,2));
    b=single(img(x,y,3));
    [r/g,r/b,g/b,g/r,b/r,b/g];
    tmpval=max([r/g,r/b,g/b,g/r,b/r,b/g]);
    if tmpval>limit
        tmpindices(i)=999999999;
    end
end
indices=tmpindices(find(tmpindices<999999999));
end
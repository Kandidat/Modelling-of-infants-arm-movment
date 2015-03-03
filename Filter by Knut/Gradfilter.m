function idx = Gradfilter(I,f,p,thresh,numb);

%p=4;
grad=Dgradients(I,f,p);
[m n]=size(f);
j=1;
for i = 1:n
    true=find(grad(:,i)<-thresh);
    
    if length(true)>=numb
        idx(j)=i;
        j=j+1;
    end
end
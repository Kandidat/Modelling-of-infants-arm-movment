
%run('vlfeat-0.9.20/toolbox/vl_setup')	 %install SIFT



%%
clc
obj=VideoReader('barn1.avi'); %read video

M=10;
xpoints=zeros(30,M);
ypoints=zeros(30,M);
firstframe=1;


img=read(obj,1);
i=rgb2gray(img);
I=single(i);
[f,d] = vl_sift(I, 'Peakthresh',2,'edgethresh',7,'Octaves',4,'Levels',4) ; %SIFT it
ind=Graypointfilter(I,f,80);
f1=f(:,ind);
ind=Gradfilter(I,f1,3,20,6);
xpoints(:,1)=closest(xpoints(:,n-1),f1(1,ind));
ypoints(:,1)=closest(ypoints(:,n-1),f1(2,ind));
for n=firstframe+1:M

img=read(obj,n);
i=rgb2gray(img);
I=single(i);

[f,d] = vl_sift(I, 'Peakthresh',2,'edgethresh',7,'Octaves',4,'Levels',4) ; %SIFT it
ind=Graypointfilter(I,f,80);
f1=f(:,ind);
ind=Gradfilter(I,f1,3,20,6);


xpoints(:,n)=closest(xpoints(:,n-1),f1(1,ind));
ypoints(:,n)=closest(ypoints(:,n-1),f1(2,ind));

end
xpoints
ypoints

for i=1:M
    imshow

%%
nbrPoints=length(matchprev);
xpoints=zeros(nbrPoints,M);
ypoints=zeros(nbrPoints,M);
xpoints(:,1)=fprev(1,matchprev');
ypoints(:,1)=fprev(2,matchprev);

dmissing=0;
fmissing=0;

for n=firstframe+1:M
    
    imgnext=read(obj,n);
    
    inext=rgb2gray(imgnext);
    Inext=single(inext);
    
    [fnext,dnext] = vl_sift(Inext, 'Peakthresh',2,'edgethresh',6,'Octaves',4,'Levels',4) ; %SIFT it
    
    
    
    [matchnext]=vl_ubcmatch(dprev(:,matchprev),dnext)
    
    for i=1:length(matchprev)
        if~(ismember(i,matchnext))
            missing=i;
        end
        
    end
    
    matchnext=matchnext(2,:);
    xadd=fnext(1,matchnext);
    yadd=fnext(2,matchnext);
    if(length(matchnext)<length(matchprev))
        
        
        if(length(dmissing<5))
            dmissing=dprev(:,matchprev(missing));
            fmissing=fprev;
        end
    end
    if(length(xadd)<nbrPoints)
        
        match=vl_ubcmatch(dmissing,dnext);
        if~(isempty(match))
            
            xadd=[xadd fnext(1,match(2,:))];
            yadd=[yadd fnext(2,match(2,:))];
            matchnext=[matchnext match(2,:)];
            dmissing=0;
            fmissing=0;
        end
    end
    xpoints(:,n)=closest(xpoints(:,n-1),xadd);
    ypoints(:,n)=closest(ypoints(:,n-1),yadd);
    iprev=inext;
    Iprev=Inext;
    f1prev=fprev;
    d1prev=dprev;
    match1prev=matchprev;
    fprev=fnext;
    dprev=dnext;
    matchprev=matchnext;
end
xpoints
ypoints
%%
x=xpoints;
y=ypoints;

ind=find(ypoints(1,:)==0);
y(1,:)=interpolate(ypoints(1,:),ind);
x(1,:)=interpolate(xpoints(1,:),ind);
for i=1:3
    figure(1)
    hold on
    plot(x(i,:),y(i,:))
    axis([0 720 0 576])
end
%%

for i=1:M
    img=read(obj,i);
    figure(i)
    imshow(img)
    hold on
    
    plot(x(:,i),y(:,i),'red*')
end




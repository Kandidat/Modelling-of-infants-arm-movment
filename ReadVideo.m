
%run('vlfeat-0.9.20/toolbox/vl_setup')	 %install SIFT


%%
clc
clf
clear all
obj=VideoReader('barn1.avi'); %read video
t=1;
fig1=figure(1);
% fig2=figure(2);
movie=1; %set 1 if movie else 0
n=20; %nbr of frames or which frame if movie=0;
sum1=0;
sum2=0;
while(t>0)
    A=moviein(n);
    %     B=moviein(n);
    for j=1:n
        if(movie==0)
            j=n;
        end
        pic = read(obj, j); %get frame (1 here)
        
        
        i=rgb2gray(pic); %create visible gray picture
        Iprev =single(rgb2gray(pic)); %create gray picture for SIFT
        
        [f,d] = vl_sift(Iprev, 'Peakthresh',2,'edgethresh',6,'Octaves',4,'Levels',4) ; %SIFT it
        indices=1:length(f);
        %         indices=scalefilter(1.8,5.5,f);
        %         indices=grayfilter(70,0,Iprev,indices,f);
        %         indices=descCheck(d,indices,3);
        %         indices=rgbfilter(2,pic,indices,f);
        %         figure(2)
        %         imshow(i);
        %         hold on
        %         plot(f(1,:),f(2,:),'yellow*')
        figure(1)
        imshow(pic); %show picture
        hold on
        
        %         plot(f(1,:),f(2,:),'red*')
        plot(f(1,indices),f(2,indices),'yellow*') %show points from SIFT
        %         figure(2)
        %         imshow(pic)
        if(movie==0)
            break;
        end
        A(:,j)=getframe(fig1);
        %         B(:,j)=getframe(fig2);
    end
    break
end
indices=1:length(f);
indices=scalefilter(2.2,4.5,f);
indices=grayfilter(70,1,Iprev,indices,f);
indices=descCheck(d,indices,3);

%%
clf
clc
obj=VideoReader('barn1.avi'); %read video
img=read(obj,7);
img2=read(obj,7);
i=rgb2gray(img);
Iprev=single(i);
inext=rgb2gray(img2);
Inext=single(inext);


[f,d] = vl_sift(Iprev, 'Peakthresh',2,'edgethresh',6,'Octaves',4,'Levels',4) ; %SIFT it
[fnext1,dnext1] = vl_sift(Inext, 'Peakthresh',2,'edgethresh',6,'Octaves',4,'Levels',4) ; %SIFT it
% indices=1:length(f);
% indices=grayfilter(70,0,I,indices,f);

figure(1)
imshow(i)
hold on
plot(f(1,:),f(2,:),'red*')
point=vl_clickpoint([f(1,:);f(2,:)],3);
figure(2)
imshow(i)
choosen=zeros(size(dnext1));
hold on
plot(f(1,point),f(2,point),'red*')
[match]=vl_ubcmatch(d(:,point),dnext1)

figure(3)
imshow(inext)
hold on
plot(fnext1(1,match(2,:)),fnext1(2,match(2,:)),'red*')
%%
obj=VideoReader('barn1.avi'); %read video

img2=read(obj,8);
i=rgb2gray(img);
Iprev=single(i);
inext=rgb2gray(img2);
Inext=single(inext);


[fnext1,dnext1] = vl_sift(Inext, 'Peakthresh',2,'edgethresh',6,'Octaves',4,'Levels',4) ; %SIFT it
figure(1)
imshow(inext)
hold on
plot(fnext1(1,97),fnext1(2,97),'red*')
figure(2)
imshow(inext)
hold on
plot(fnext1(1,98),fnext1(2,98),'red*')
%%
clc
obj=VideoReader('barn1.avi'); %read video
M=8;
firstframe=6;
imgprev=read(obj,firstframe);
iprev=rgb2gray(imgprev);
Iprev=single(iprev);
[fprev,dprev] = vl_sift(Iprev, 'Peakthresh',2,'edgethresh',7,'Octaves',4,'Levels',4) ; %SIFT it
figure(1)
imshow(iprev)
hold on
plot(fprev(1,:),fprev(2,:),'red*')

matchprev=vl_clickpoint([fprev(1,:);fprev(2,:)],M);
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




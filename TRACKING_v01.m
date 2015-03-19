%--------------------------------------------------------------------------
%PROGARM SKELETON FOR TRACKING ALGORITM
%
%
%
%--------------------------------------------------------------------------

% READ VIDEO


vidObj=cell(3,1);

vidObj{1}=VideoReader('CAM1_cut.mp4');
vidObj{2}=VideoReader('CAM2_cut.mp4');
vidObj{3}=VideoReader('CAM3_cut.mp4');

for i = 1:3;
vidObj{i}.CurrentTime = 30;
end


frames=5;


D=cell(frames,3);
F=cell(frames,3);

%--------------------------------------------------------------------------

%SIFT AND SAVE ALL DESCRIPTORS AND KEYPOINTS
%%
for i = 1:frames 
    
    for n = 1:3
        
        Irgb=readFrame(vidObj{n});
        I=single(rgb2gray(Irgb));
        
        
        [f,d]=vl_sift(I,'PeakThresh',2,'Octaves',3);
        
        [f,d]=Filter(Irgb,f,d);
        
        F{i,n}=f;
        D{i,n}=d;
    end
end
        
%%
%Above section only needs to be runned once
%--------------------------------------------------------------------------

% Plot for cheking result


%     imagesc(I);colormap('gray')
%     h=vl_plotframe(F{i,n});
%     set(h,'color','y','linewidth',1);

%looks good, may be necessary to check all cameras


    
    

%INITIATE TRACKING ALGORITM
MATCHES=cell(frames-1,3);
SCORES=cell(frames-1,3);
MATCHEDF=cell(2*(frames-1),3);

for n = 1:frames-1 %looping to find matches through all frames
    
   
        
    %MATCH DESCRIPTORS FROM FRAME n AND n+1 PLUS STORED DESCRIPTORS
    for i = 1:3 %matches from all 3 cameras
    %PlUS SAVED DESCRIPTORS FROM EARLIER FRAMES!!!    
    [matches,scores]=vl_ubcmatch(D{n,i},D{n+1,i});
    
    %cheking distance between matched keypoints
    %----------------------------------------------------------------------
    xy1=F{n,i}(1:2,matches(1,:));
    xy2=F{n+1,i}(1:2,matches(2,:));
    
    diff=sqrt((xy1(1,:)-xy2(1,:)).^2+(xy1(2,:)-xy2(2,:)).^2);
    
    matches(:,diff>4)=[];
    %----------------------------------------------------------------------
    %Check reasonable direction here...
    %----------------------------------------------------------------------
    %----------------------------------------------------------------------
    
    unmatched=1:length(F{n,i}(1,:));
    
    unmatched(matches(1,:))=[];
    
    MATCHES{n,i}=matches;
    SCORES{n,i}=scores;
    
    MATCHEDF{2*n-1,i}=F{n,i}(:,matches(1,:));
    MATCHEDF{2*n,i}=F{n+1,i}(:,matches(2,:));
    
    %THIS IS WHAT HAPPENS WHEN MATCH IS TRUE
    if n==1 %initiate tracks
        for j = 1:length(matches(1,:))
            
            T(j,i)=struct('x',[F{n,i}(1,matches(1,j)) F{n+1,i}(1,matches(2,j))],'y',[F{n,i}(2,matches(1,j)) F{n+1,i}(2,matches(2,j))],'frame',[n n+1],'match',[matches(2,j)]);
            
        end
    
    end
    end
    %THIS IS WHAT HAPPENS WHEN MATCH IS TRUE
    
    
    %THIS IS WHAT HAPPENS WITH OTHER KEYPOINTS
    

    
    %MATCH = TRUE
    
%     MATCHEDF{}
        
        
end
    
    
    
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
for n = 1:frames 
    
    for i = 1:3
        
        Irgb=readFrame(vidObj{i});
        I=single(rgb2gray(Irgb));
        
        
        [f,d]=vl_sift(I,'PeakThresh',2,'Octaves',3);
        
        [f,d]=Filter(Irgb,f,d);
        
        F{n,i}=f;
        D{n,i}=d;
    end
end
        
%%
%Above section only needs to be run once
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

for i = 1:3 %looping to find matches through all frames
    
   
        
    %MATCH DESCRIPTORS FROM FRAME n AND n+1 PLUS STORED DESCRIPTORS
    for n = 1:frames-1 %matches from all 3 cameras
    %PlUS SAVED DESCRIPTORS FROM EARLIER FRAMES!!!    
    [matches,scores]=vl_ubcmatch(D{n,i},D{n+1,i});
    
    if isempty(dmis)>0
        [matchesmis,scoresmis]=vl_ubcmatch(dmis,D{n+1,i});
        
    end
    
    %cheking distance between matched keypoints
    %----------------------------------------------------------------------
    xy1=F{n,i}(1:2,matches(1,:));
    xy2=F{n+1,i}(1:2,matches(2,:));
    
    diff=sqrt((xy1(1,:)-xy2(1,:)).^2+(xy1(2,:)-xy2(2,:)).^2);
    
    matches(:,diff>4)=[]; %discarding matches that don't meet the criteria
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
    
    
    if n==1 %initiate tracks

        for j = 1:length(matches(1,:))
            
            T(j,i)=struct('x',[F{n,i}(1,matches(1,j)) F{n+1,i}(1,matches(2,j))],'y',[F{n,i}(2,matches(1,j)) F{n+1,i}(2,matches(2,j))],'frame',[n n+1]);
            Tmatch(j,i)=matches(2,j);
        end
        matchesold=[matches(2,:);1:size(matches,2)];
    
    
    else % n>1
        
 %BEHANDLAR GAMLA MATCHNINGAR
 
 %Fortsatta matchningar
 %l�gg till i T
 
 a = ismember(matchesold(1,:),matches(1,:));
 b = ismember(matches(1,:),matchesold(1,:));
 
 contold = matchesold(:,a==1);
 contnew = matches(:,b==1);
 matchesoldtmp=zeros(2,size(contold,2));
 for j = 1:size(contold,2)
     p = find(contnew(1,:)==contold(1,j));
     point = contnew(2,p);
     Tj = contold(2,j);
     x=F{n+1,i}(1,point);
     y=F{n+1,i}(2,point);
     T(Tj,i).x(size(T(Tj,i).x,2)+1)=x;
     T(Tj,i).y(size(T(Tj,i).y,2)+1)=y;
     T(Tj,i).frame(size(T(Tj,i).frame,2)+1)=n+1;
     matchesoldtmp(:,j)=[point;Tj];
     %UPDATE MATCHESOLD
 end
 
 %matchesoldtmp=[];
 %avbrutna matchnigar
 %spara descriptor
 
 disold = matchesold(:,a==0);
 dmis=D{n}(disold(1,:))
 % nya p�b�rjade matchingarmatc
 % l�gg till i T
 
 newnew = matches(:,b==0);
%         for k = 1:length(matchesold(1,:))
%             
%             a = find(matchesold==matcehsold(1,k));
%             
%             if length(a)>=1
%                 % spara forts�ttningen i b�da T
%             else
%                 b = find(matches(1,:)==matchesold(1,k));
%                 if isempty(b)==true
%                     % ingen ny match :'( spara undan descriptor
%                 else
%                     % en unik match spara i r�tt T
%                 end
%             endi

% %BEHANDLAR NYA MATCHNINGAR      
%     
%     end
%     end
    %THIS IS WHAT HAPPENS WHEN MATCH IS TRUE
    
    
    %THIS IS WHAT HAPPENS WITH OTHER KEYPOINTS
    

    
    %MATCH = TRUE
    
%     MATCHEDF{}
matchesold=matchesoldtmp;
    end
    end  
end
    
    
    
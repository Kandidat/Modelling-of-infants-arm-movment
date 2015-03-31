%--------------------------------------------------------------------------
%PROGARM SKELETON FOR TRACKING ALGORITM
%This program mainly constructs the structurearray T containing information
%about tracks. Every row in T corresponds to a track and every column to a
%CAM
%
%
%--------------------------------------------------------------------------

% READ VIDEO


vidObj=cell(3,1);

vidObj{1}=VideoReader('CAM1_cut.mp4');
vidObj{2}=VideoReader('CAM2_cut.mp4');
vidObj{3}=VideoReader('CAM3_cut.mp4');

for i = 1:3;
vidObj{i}.CurrentTime = 50;
end


frames=120;


D=cell(frames,3);
F=cell(frames,3);

%--------------------------------------------------------------------------
%%
%SIFT AND SAVE ALL DESCRIPTORS AND KEYPOINTS
%The most time consuming part of the program
%--------------------------------------------------------------------------
A=zeros(480,640,3,frames);
for n = 1:frames 
    
    for i = 1:1
        
        Irgb=readFrame(vidObj{i});
        A(:,:,:,n)=Irgb;
        I=single(rgb2gray(Irgb));
        
        
        [f,d]=vl_sift(I,'PeakThresh',2,'Octaves',3);
        
        [f,d]=Filter(Irgb,f,d);
       
        F{n,i}=f;
        D{n,i}=d;
    end
end
%Above section only needs to be run once
%--------------------------------------------------------------------------       
%%
%TRACKING ALGORITHM
%--------------------------------------------------------------------------
for i = 1:1 %looping trough every CAM (if i = 1:1 its becaus of testing pourposes

%Defining(reseting) variables
matchesmisoldtmp=[];
matchesmis=[];
matchesmisold=[];
dmis=[];  
   
        
    %MATCH DESCRIPTORS FROM FRAME n AND n+1 PLUS STORED DESCRIPTORS
    for n = 1:frames-1 %looping trough frames
 
    [matches,scores]=vl_ubcmatch(D{n,i},D{n+1,i});
    
    %Match descriptors that went missing
    if isempty(dmis)<1
        [matchesmis,scoresmis]=vl_ubcmatch(dmis,D{n+1,i});
        %Need to check distance
    end
    
    %cheking distance between matched keypoints
    %----------------------------------------------------------------------
    xy1=F{n,i}(1:2,matches(1,:));
    xy2=F{n+1,i}(1:2,matches(2,:));
    
    diff=sqrt((xy1(1,:)-xy2(1,:)).^2+(xy1(2,:)-xy2(2,:)).^2);
    
    matches(:,diff>7)=[]; %discarding matches that don't meet the criteria
    %----------------------------------------------------------------------
    %Check reasonable direction here...
    %----------------------------------------------------------------------
    
    if n==1 %Initiate tracks

        for j = 1:length(matches(1,:))
            
            x=[F{n,i}(1,matches(1,j)) F{n+1,i}(1,matches(2,j))];
            y=[F{n,i}(2,matches(1,j)) F{n+1,i}(2,matches(2,j))];
            frame=[n n+1];
            T(j,i).x=x;
            T(j,i).y=y;
            T(j,i).frame=frame;
            
        end
        matchesold=[matches(2,:);1:size(matches,2)];
    
    
    else % n>1


         a = ismember(matchesold(1,:),matches(1,:));
         b = ismember(matches(1,:),matchesold(1,:));
            
         %Continued tracks from last set of matches
         contold = matchesold(:,a==1);
         contnew = matches(:,b==1);
         
         matchesoldtmp=zeros(2,size(contold,2)); %preallocating
         
         for j = 1:size(contold,2)
             
             p = find(contnew(1,:)==contold(1,j));
             point = contnew(2,p);
             Tj = contold(2,j);
             x=F{n+1,i}(1,point);
             y=F{n+1,i}(2,point);
             T(Tj,i).x(size(T(Tj,i).x,2)+1)=x;
             T(Tj,i).y(size(T(Tj,i).y,2)+1)=y;
             T(Tj,i).frame(size(T(Tj,i).frame,2)+1)=n+1;
             matchesoldtmp(:,j)=[point;Tj]; %temporary storage of matches in frame n+1
             
         end

         %Matches from previously lost tracks (mis is short for missing)
         matchesmisoldtmp=[];
         if isempty(matchesmis)<1 && isempty(matchesmisold)<1
             amis = ismember(matchesmisold(1,:),matchesmis(1,:));
             bmis = ismember(matchesmis(1,:),matchesmisold(1,:));

             contmisold = matchesmisold(:,amis==1);
             contmisnew = matchesmis(:,bmis==1);

             matchesmisoldtmp=zeros(2,size(contmisold,2));
            for q = 1:size(contmisold,2)
                p = find(contmisnew(1,:)==contmisold(1,q));
                point = contmisnew(2,p);
                Tj = contmisold(2,q);
                x=F{n+1,i}(1,point);
                y=F{n+1,i}(2,point);
                T(Tj,i).x(size(T(Tj,i).x,2)+1)=x;
                T(Tj,i).y(size(T(Tj,i).y,2)+1)=y;
                T(Tj,i).frame(size(T(Tj,i).frame,2)+1)=n+1;
                matchesmisoldtmp(:,q)=[point;Tj];
                %disp(Tj)
         
            end
            dmis(:,matchesmis(1,:))=[]; %Erase matches from missing descriptors
            matchesmisold(:,matchesmis(1,:))=[];

         end

             if isempty(dmis)<1

             id=matchesmisold(3,:)>5; 
             
             %if the descriptor as been missing for more than 5 frames erase (end track)
             matchesmisold(:,id)=[];
             dmis(:,id)=[];

             matchesmisold(1,:)=1:size(matchesmisold,2);
             end

         disold = matchesold(:,a==0); %Defining the missing tracks (discontinued matches)
         
         matchesmisold=[matchesmisold ,[[1:size(D{n,i}(:,disold(1,:)),2)]+size(dmis,2);disold(2,:);zeros(1,size(disold(2,:),2))]];
         
         matchesmisold(3,:)=matchesmisold(3,:)+1; %Add to counter for missing frames
         dmis=[dmis, D{n,i}(:,disold(1,:))]; %Missing descriptors

         
         %New matches
         newnew = matches(:,b==0);
         matchesnewoldtmp=[];
         if isempty(newnew)<1
             matchesnewoldtmp=zeros(2,size(newnew,2));
             for q = 1:size(newnew,2)
                 point1=newnew(1,q);
                 point2=newnew(2,q);

                 x1=F{n,i}(1,point1);
                 y1=F{n,i}(2,point1);

                 x2=F{n+1,i}(1,point2);
                 y2=F{n+1,i}(2,point2);
                 Tj=size(T,1)+1;
                 T(Tj,i).x=[x1 x2];
                 T(Tj,i).y=[y1 y2];
                 T(Tj,i).frame=[n n+1];

                 matchesnewoldtmp(:,q)=[point2;Tj];
             end

         end

        %Update matchesold
        matchesold=[matchesoldtmp, matchesmisoldtmp, matchesnewoldtmp];
    end
    end  
end
    
    
    
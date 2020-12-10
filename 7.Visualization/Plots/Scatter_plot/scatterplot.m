colordist=[0,0,1;...
    1,0,0;...
    0,1,0;...
    0,0,0.172413793103448;...
    1,0.103448275862069,0.724137931034483;...
    1,0.827586206896552,0;...
    0,0.344827586206897,0;...
    0.517241379310345,0.517241379310345,1;...
    0.620689655172414,0.310344827586207,0.275862068965517;...
    0,1,0.758620689655172;...
    0,0.517241379310345,0.586206896551724;...
    0,0,0.482758620689655;...
    0.586206896551724,0.827586206896552,0.310344827586207;...
     1,0.5,0.5];% will need to add one more color probably orange
close all
GrayFeats=[1:21,((1:21)+196),((1:21)+(2*196)),((1:21)+(3*196))];
GradFeats=[22:31,((22:31)+196),((22:31)+(2*196)),((22:31)+(3*196))];
HaralickFeats=[32:96,((32:96)+196),((32:96)+(2*196)),((32:96)+(3*196))];
GaborFeats=[97:136,((97:136)+196),((97:136)+(2*196)),((97:136)+(3*196))];
LawsFeats=[137:170,((137:170)+196),((137:170)+(2*196)),((137:170)+(3*196))];
ColFeats=[171:196,((171:196)+196),((171:196)+(2*196)),((171:196)+(3*196))];

ff{1}=GrayFeats;
ff{2}=HaralickFeats;
ff{3}=GradFeats;
ff{4}=LawsFeats;
ff{5}=GaborFeats;
ff{6}=ColFeats;
listmean=mean(Full_to_HalfComp(:,3:end));
    for i=196:-1:1%will need to edit for your full feature list
        
           if ismember(i,ff{1})
            c=colordist(2,:);
            si=75
        end

        if ismember(i,ff{2})
            c=colordist(3,:);
            si=75
        end
        if ismember(i,ff{3})
            c=colordist(1,:);
            si=75
        end
        if ismember(i,ff{4})
            c=colordist(5,:);
            si=75
            
        end
        if ismember(i,ff{5})
            c=colordist(6,:);
            si=75
        end
          if ismember(i,ff{6})
            c=colordist(7,:);
            si=75
        end
         if i==1
            c='k'
            si=75
            
         end
        
                         shape='o'
        figure(100)
        hold on
        s=scatter(Full_to_HalfComp(1,i+2),1,si,c,shape,'filled','MarkerEdgeColor','black')
        s.MarkerEdgeColor='k'
        title('mean-ICC')
        hold off
        
                figure(100)
        hold on
        s=scatter(Full_to_HalfComp(2,i+2),2,si,c,shape,'filled','MarkerEdgeColor','black')
        s.MarkerEdgeColor='k'
        title('mean-ICC')
        hold off
        
                figure(100)
        hold on
        s=scatter(Full_to_HalfComp(3,i+2),3,si,c,shape,'filled','MarkerEdgeColor','black')
        s.MarkerEdgeColor='k'
        title('mean-ICC')
        
        hold off

                figure(200)
        hold on
        s=scatter(Full_to_HalfComp(1,i+196+2),1,si,c,shape,'filled','MarkerEdgeColor','black')
        s.MarkerEdgeColor='k'
        title('var-ICC')
        hold off
        
                figure(200)
        hold on
        s=scatter(Full_to_HalfComp(2,i+196+2),2,si,c,shape,'filled','MarkerEdgeColor','black')
        s.MarkerEdgeColor='k'
        title('var-ICC')
        hold off
        
                figure(200)
        hold on
        s=scatter(Full_to_HalfComp(3,i+196+2),3,si,c,shape,'filled','MarkerEdgeColor','black')
        s.MarkerEdgeColor='k'
        title('var-ICC')
        
        hold off
                figure(300)
        hold on
        s=scatter(Full_to_HalfComp(1,i +2*196+2),1,si,c,shape,'filled','MarkerEdgeColor','black')
        s.MarkerEdgeColor='k'
        title('kurt-ICC')
        hold off
        
                figure(300)
        hold on
        s=scatter(Full_to_HalfComp(2,i+2*196+2),2,si,c,shape,'filled','MarkerEdgeColor','black')
        s.MarkerEdgeColor='k'
        title('kurt-ICC')
        hold off
        
                figure(300)
        hold on
        s=scatter(Full_to_HalfComp(3,i+2*196+2),3,si,c,shape,'filled','MarkerEdgeColor','black')
        s.MarkerEdgeColor='k'
        title('kurt-ICC')
        
        hold off
        
                     figure(400)
        hold on
        s=scatter(Full_to_HalfComp(1,i +3*196+2),1,si,c,shape,'filled','MarkerEdgeColor','black')
        s.MarkerEdgeColor='k'
        title('skew-ICC')
        hold off
        
                figure(400)
        hold on
        s=scatter(Full_to_HalfComp(2,i+3*196+2),2,si,c,shape,'filled','MarkerEdgeColor','black')
        s.MarkerEdgeColor='k'
        title('skew-ICC')
        hold off
        
                figure(400)
        hold on
        s=scatter(Full_to_HalfComp(3,i+3*196+2),3,si,c,shape,'filled','MarkerEdgeColor','black')
        s.MarkerEdgeColor='k'
        title('skew-ICC')
        
        hold off
        
    end
function stackedbarplot(rep_measure,bins,feature_ranges,Leg,GorL)
colors=distinguishable_colors(length(feature_ranges),'k')
bars=[]

for b=1:length(bins)
    for fr=1:length(feature_ranges)
        feat_range=feature_ranges{fr};
        if GorL==1
            bars(b,fr)=length(greaterthancount(rep_measure,feat_range,bins,b));
        else
            bars(b,fr)=length(lessthancount(rep_measure,feat_range,bins,b));
        end
    end   
end
s=sum(bars,2);
bars=bars./s;
colormap(colors)
save('stackedbarplotdata.mat','bars');
bf=bar(bars,'stacked','EdgeColor','black')
xt = get(gca,'XTick');
set(gca,'XTick',xt,'XTickLabel',{'0.998-0.985','0.985-0.973','0.973-0.962','0.962-0.915'});
xlabel('ICC ranges','fontweight','bold');
title('Intraclass Correlation Coefficient - Healthy');
legend(Leg)
end

function temp =greaterthancount(rep_measure,feat_range,bins,b)
if b==1
    temp=find(rep_measure(feat_range)>=bins(b));
else
    temp=find(rep_measure(feat_range)>=bins(b) &rep_measure(feat_range)<bins(b-1));
end
end

function temp=lessthancount(rep_measure,feat_range,bins,b)
if b==1
    temp=find(rep_measure(feat_range)<=bins(b));
else
    temp=find(rep_measure(feat_range)<=bins(b) &rep_measure(feat_range)>bins(b-1));
end
end

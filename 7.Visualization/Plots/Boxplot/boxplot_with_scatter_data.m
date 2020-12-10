%---------------------Boxplot with data scattared-------------------------%
clear;
addpath(genpath('P:\Resampled_results'))
addpath(genpath('O:\Resampled_data\Features'))
addpath(genpath('P:\CT_Rectal'))
addpath(genpath('P:\Resampled_results_2\Feature_subsets'))

% D1 = load('CT_TI_resampled3D_entire_vol_grp1_3foldCV_IS_pruning_mrmr_QDA.mat')
% idx = D1.idx;
% graycolumnindices = [1:21 464:484 927:947 1390:1410];

load('CT_TI_featstack_resampled3D_noprune_grp1.mat');
featstack_full_Train=featstack_TI_full;
featstack_full_Train(isnan(featstack_full_Train))=0;
% featstack_full_Train(:,graycolumnindices)= [];
% featstack_full_Train = featstack_full_Train(:,idx);
labels_1=[labels(1:70),1,labels(72:end)];
load('CT_TI_featstack_resampled3D_noprune_grp2.mat');
featstack_full_Test=featstack_TI_full;
featstack_full_Test(isnan(featstack_full_Test))=0;
% featstack_full_Test(:,graycolumnindices)= [];
%featstack_full_Test = featstack_full_Test(:,idx);
labels_2 = labels;
clear featstack_TI_full* featstack_TI_half* featstack_TI_safire3* featstack_TI_safire4*
[featstack_full_Train_swno,mean_val,mad_val]=sw_outlier_compensation(featstack_full_Train);
featstack_full_Train=simplewhiten(featstack_full_Train,mean_val,mad_val);
featstack_full_Test=simplewhiten(featstack_full_Test,mean_val,mad_val);

wilcoxon_idx = [453,268,864,440]';
mrmr_idx = [440,880,320,221]';
topfea_idx = [807]
a1 = featstack_full_Train((find(labels_1==1)),topfea_idx(1));
a2 = featstack_full_Train((find(labels_1==0)),topfea_idx(1));
% load('CT_featstack_TI_entire_volume_grp2_CV.mat');
a3 = featstack_full_Test((find(labels_2==1)),topfea_idx(1));
a4 = featstack_full_Test((find(labels_2==0)),topfea_idx(1));
a = [a1;a2;a3;a4];
g1 = [zeros(length(a1),1); ones(length(a2),1); 2*ones(length(a3),1);3*ones(length(a4),1)];
boxplot(a,g1,'Notch','off');
%set(gca,'YLim',[-3 3])
set(gca,'XTickLabel', {'Discovery - Diseased','Discovery - Healthy','Testing - Diseased','Testing - Healthy'});
set(gca,'TickLabelInterpreter','none');
set(gca,'fontsize',20);
hold on
[C,~,ic] = unique(g1,'stable');
scatter(ic,a,'k','filled','MarkerFaceAlpha',0.4');
color = ['g','r','g','r'];
h = findobj(gca,'Tag','Box');
 for j=1:length(h)
    patch(get(h(j),'XData'),get(h(j),'YData'),color(j),'FaceAlpha',.2);
 end
ylabel('Feature values','fontweight','bold','FontSize',24)
title('f1','fontweight','bold','FontSize',24)
legend(h([3,4]),{'Diseased','Healthy'})

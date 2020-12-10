addpath(genpath('P:\CT_Rectal\Violinplot-Matlab-master'))
addpath(genpath('P:\Resampled_results_2\Feature_subsets'))
addpath(genpath('O:\Resampled_data\Data\Features'))
addpath(genpath('P:\CT_Rectal'))

clear all;
colors = [10 80 10 80];
fea_number = 252;
names =  {'Discovery (Diseased)','Discovery (Healthy)','Testing (Diseased)','Testing (Healthy)'};
names1 = {'Diseased','Healthy'}
groups={[1,2],[3,4]};
cd('P:\PC_plots\Data_distribution_plots\violin_plots')

load('CT_TI_featstack_resampled3D_noprune_grp1.mat');
featstack_full_Train=featstack_TI_full;
featstack_full_Train(isnan(featstack_full_Train))=0;
labels_grp1 = labels;

load('CT_TI_featstack_resampled3D_noprune_grp2.mat');
featstack_full_Test=featstack_TI_full;
featstack_full_Test(isnan(featstack_full_Test))=0;
labels_grp2 = labels;

[featstack_full_Train_swno,mean_val,mad_val]=simplewhitennooutlier(featstack_full_Train);
featstack_full_Train=simplewhiten(featstack_full_Train,mean_val,mad_val);
featstack_full_Test=simplewhiten(featstack_full_Test,mean_val,mad_val);

dat{1,1} = featstack_full_Train((find(labels_grp1==1)),fea_number);
dat{1,2} = featstack_full_Train((find(labels_grp1==0)),fea_number);
dat{1,3} = featstack_full_Test((find(labels_grp2==1)),fea_number);
dat{1,4} = featstack_full_Test((find(labels_grp2==0)),fea_number);

%-----------------------Removal of outliers-------------------------------%
for j = 1: length(dat)
    data = dat{1,j};
    temp = prctile(data,[5 95],1);
    for i = 1:size(data,2)
      idx{i} = find((data(:,i)<temp(1,i)) | (data(:,i)>temp(2,i))); 
      tempdata = data(:,i);
      tempdata(idx{1,i},:)=[];
      data = tempdata;
    end
   dat1{1,j} = data;
end

g1 = [zeros(length(dat1{1,1}),1); ones(length(dat1{1,2}),1); ... 
     2*ones(length(dat1{1,3}),1);3*ones(length(dat1{1,4}),1)];
a1 = [dat1{1,1};dat1{1,2};dat1{1,3};dat1{1,4}];

cmap = hsv(256);
% cmap(1,:) = [173 216 230]./255; %adjust for light blue
% cmap(2,:) = [173 216 230]./255; 
% %cmap(7,:) = [64 224 208]./255; %adjust for turquoise
% cmap(3,:) = [165 42 42]./255; %adjust for brown
% cmap(4,:) = [165 42 42]./255;
%cmap(4,:) = [255 51 153]./255; %adjust for pink
fprintf('Plotting...')
figure('Color','white');
% h = violin(dat);
h1 = violin(dat1,'facecolor',cmap(colors(1:length(names)),:),'edgecolor','k','facealpha',0.3,'medc','k','xlabel',names)
ylim([-6.5 6.5])
%---------------------------Display the data-----------------------------%
hold on
[C,~,ic] = unique(g1,'stable');
s=scatter(ic,a1,'k','filled','MarkerFaceAlpha',0.4','jitter','on','jitterAmount',0.05);
hold off
%---------------Calculate and include p-value statistic------------------%
[~,pval1] = ttest2(dat{1,1},dat{1,2});
[~,pval2] = ttest2(dat{1,3},dat{1,4});
pval1 = round(pval1,5);
pval2 = round(pval2,4);
H=sigstar(groups,[pval1,pval2]);
set(H,'Color','b')
set(gca,'TickLabelInterpreter','none');
set(gca,'fontsize',20.5);
ylabel('Feature values','fontweight','bold','FontSize',28);
title('f1','fontweight','bold','FontSize',32,'FontAngle','italic')
l = legend(names1{1},'Median',names1{2},'Location','northeastoutside')
fprintf('\nDone...')


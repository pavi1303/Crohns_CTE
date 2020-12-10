
%----------------------------Training results plot----------------------%
clear;
addpath(genpath('P:\PC_plots\AUC_plot'))
cd('P:\PC_plots\AUC_plot');
load('plot_data.mat')
syms fp_1 fp_2 fp_3
F1 = sym('fp_1')
F2 = sym('fp_2')
F3 = sym('fp_3')
AUC_train = [AUC1;AUC2;AUC3];
err_train = [err1;err2;err3];
figure(1)
b = bar(AUC_train,'grouped','BarWidth',1,'FaceColor','flat');
%-----------------------------Color code for training--------------------%
b(1).FaceColor = [0 0 255]./255;%adjust for dark blue
b(2).FaceColor = [255 211 0]./255;%adjust for yellow
b(3).FaceColor = [255 105 180]./255;%adjust for red shade
set(gca,'YLim',[0.4 1])
set(gca,'XTickLabel', {'fp_1','fp_2','fp_3'});
set(gca,'TickLabelInterpreter','none');
set(gca,'fontsize',20);
legend({'Full dose,FBP','Half dose,FBP (50%)','Safire4,IR (50%)'});
xlabel({'Stage of pruning'},'fontweight','bold','FontSize',24);
ylabel({'Area under the curve (AUC)',''},'fontweight','bold','FontSize',24);
title('DISCOVERY SET','fontweight','bold','FontSize',30);
hold on
colormap parula
nbars = size(AUC_train,2);
x=[];
for i=1:nbars
    x = [x;b(i).XEndPoints];
end
errorbar(x',AUC_train,err_train,'k','linestyle','none','HandleVisibility','off')'
hold off


%-----------------------------Color code for testing----------------------%
% b(1).FaceColor = [126 249 255]./255;%adjust for electric blue shade
% b(2).FaceColor = [252 244 163]./255;%adjust for banana color
% b(3).FaceColor = [250 218 221]./255;%adjust for salmon
AUC_test = [AUC4;AUC5;AUC6];
figure(2)
b = bar(AUC_test,'grouped','BarWidth',1,'FaceColor','flat');
%-----------------------------Color code for testing----------------------%
b(1).FaceColor = [126 249 255]./255;%adjust for electric blue shade
b(2).FaceColor = [252 244 163]./255;%adjust for banana color
b(3).FaceColor = [250 218 221]./255;%adjust for salmon
set(gca,'YLim',[0.4 1])
set(gca,'XTickLabel', {'fp_1','fp_2','fp_3'});
set(gca,'TickLabelInterpreter','none');
set(gca,'fontsize',20);
legend({'Full dose,FBP','Half dose,FBP (30%)','Safire4,IR (30%)'});
xlabel({'Stage of pruning'},'fontweight','bold','FontSize',24);
ylabel({'Area under the curve (AUC)',''},'fontweight','bold','FontSize',24);
title('TESTING SET','fontweight','bold','FontSize',30);

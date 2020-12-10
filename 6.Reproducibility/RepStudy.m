function RepStudy(featstack_name)
addpath(genpath('P:\CT_Rectal\CT_Rectal_Code\scripts-master'))
addpath(genpath('P:\Resampled_results_2\Feature_subsets'))
% addpath(genpath('P:\Resampled_results_2\Reproducibility\Only_IS'))
cd('P:\Resampled_results_2\Reproducibility\ICC');
load('CT_TI_featstack_resampled3D_onlyIS_grp1.mat');

% dontuse=[];
% 
% % Holdout=[];
% % Holdout_label=[];
% % 
% % list_TI=[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89]'
% % 
% % newlist_TI=setdiff(list_TI,dontuse);
% %newlist_TI=setdiff(newlist_TI,Holdout);
% 
% pos_list=newlist_TI(newlist_TI<46);

% for i=1:length(pos_list)
% pos_idx(i,1)=find(pos_list(i)==list_TI)
% end
% 
sub_TI_full=featstack_TI_full(find(labels==1),:);
sub_TI_half=featstack_TI_half(find(labels==1),:);
sub_TI_safire3=featstack_TI_safire3(find(labels==1),:);
sub_TI_safire4=featstack_TI_safire4(find(labels==1),:);
% 
% sub_TI_full=simplewhiten(sub_TI_full);
% sub_TI_half=simplewhiten(sub_TI_half);
% sub_TI_safire4=simplewhiten(sub_TI_safire4);

groupstack={sub_TI_full;sub_TI_half;sub_TI_safire3;sub_TI_safire4};

% data1 = featstack_TI_full;
% data1(isnan(data1))=0;
% data1_d = data1(find(labels==1),:);
% load('CT_TI_featstack_resampled3D_noprune_grp2.mat');
% data2 = featstack_TI_full;
% data2(isnan(data2))=0;
% data2_d = data2(find(labels==1),:);

% [data1_sw_no,mean_val,mad_val] = simplewhitennooutlier(data1);
% data1_msw = simplewhiten(data1,mean_val,mad_val);
% data2_msw = simplewhiten(data2,mean_val,mad_val);

% groupstack = {data1_d;data2_d};
reproducibilityChK(groupstack,100,'Rep_3D_resampled_ICC_d.mat')
end
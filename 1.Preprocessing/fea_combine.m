%This combines the data from all the patients within a group to create a
%data matrix with rows representing patients and columns denoting different
%feature values.
addpath(genpath('O:\Resampled_data\Features\Grp2'))
list = [1:74]';
cd('O:\Resampled_data\Features');
D1 = load('CT_3Dfeatstack_grp2.mat');
labels = D1.labels;
for i = 1:length(list)
    load([num2str(i),'-3Dfeats_TI_grp2.mat']);
    
    featstats_TI_full = featstats_TI_full.';
    featstats_TI_full = featstats_TI_full(:).';
    
    featstats_TI_half = featstats_TI_half.';
    featstats_TI_half = featstats_TI_half(:).';
    
    featstats_TI_safire3 = featstats_TI_safire3.';
    featstats_TI_safire3 = featstats_TI_safire3(:).';
    
    featstats_TI_safire4 = featstats_TI_safire4.';
    featstats_TI_safire4 = featstats_TI_safire4(:).';
    
    featstack_TI_full(i,:) = featstats_TI_full;
    featstack_TI_half(i,:) = featstats_TI_half;
    featstack_TI_safire3(i,:) = featstats_TI_safire3;
    featstack_TI_safire4(i,:) = featstats_TI_safire4;
end

statnames = statnames.';
statnames = statnames(:).';

save(['3D_featstack_resampled_grp2.mat'],'featstack_TI_full','featstack_TI_half','featstack_TI_safire3','featstack_TI_safire4','statnames','labels','list');

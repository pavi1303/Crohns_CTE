clear;
addpath(genpath('O:\Resampled_data\Data\Grp1'))
addpath(genpath('O:\Resampled_data\Data_for_heatmap'))
%load('RRPCD001_BH_AX_Res_crp_BF_feats')%loaded in to pull feature names
% statnames_nu=[statnames(1,:),statnames(2,:),statnames(3,:),statnames(4,:)];
%patientlist=[43,55,195,177]
%patientlist={'68','42','72','39'}%patient names
patientlist={'54','35'}%patient names
volstack={};
featlist=[273]% feature number
endpoints=[];
cd('O:\Resampled_data\Data_for_heatmap\Heatmap_results\Single_slice_results\Feature_no_52')

for f=1:1
    %     tempvol=[];
    %     tempmask=[];
    tempfeat=[];
    currmax=0;
    currmin=inf;
    for i=1:length(patientlist)
        patnum=patientlist{i};
        fname=[num2str(patnum),'-3Dfeats_TI_grp1.mat'];%loads patients in make sure to adjust the subscript to match the data
        load(fname);
        feat=featlist(f);
        tempfeat=[tempfeat;featints_TI_full{feat}];
        % This loop basically stacks all the patient images together in one...
        % long vector and then takes note of what the max and min values
        % are as well as where the endpoints of each patient are
        if max(featints_TI_full{feat})>currmax
            currmax=i;
        end
        if min(featints_TI_full{feat})<currmin
            currmin=i;
        end
        endpoint(i,1)=length(tempfeat);
    end
    
    Y = prctile(tempfeat,[1,95])% This removes the outliers
    tempfeat(tempfeat>Y(2))=Y(2);
    tempfeat(tempfeat<Y(1))=Y(1);
    
    rescale_rangedata{f,1}=rescale_range(tempfeat,0,1);%The data is now rescaled all at once. 
    rescale_rangedata{f,2}=currmax;
    rescale_rangedata{f,3}=currmin;
end
% i=2;
% x=12
for f=1:1
    for i=1:length(patientlist)
        patnum=patientlist{i};
        fname=[num2str(patnum),'-TI_mask_grp1_resampled.mat'];
        patimg=[num2str(patnum),'-CTE_grp1_resampled.mat'];
        load(patimg);
        %-----Contrast adjustment
%         levels = unique(vol_full(:));
        kmult = 255/(max(max(vol_full(:))));
        vol_full = kmult*vol_full;
        load(fname);
        mask=TI_mask;
        mask(mask>1)=1;
        [~,~,slices] = ind2sub(size(mask),find(mask==1));
        slices = unique(slices);
        temp1=rescale_rangedata{f,1};
        if i>1
            scaled_feat=temp1(endpoint(i-1)+1:endpoint(i));
        else
            scaled_feat=temp1(1:endpoint(i));
        end
        figure(i)
        feature_map(vol_full(:,:,slices),double(logical(mask(:,:,slices))),scaled_feat);
    end
end

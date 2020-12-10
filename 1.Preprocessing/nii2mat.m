%This function is used to convert the nifti files coming out of 3DSlicer to
%.mat format (Please make sure to rotate and flip the img/mask files
%accordingly. Compare and verify wrt 3DSlicer. 

addpath(genpath('Q:\home\txc531\Resampled_niis'))
% addpath(genpath('Q:\home\txc531\Resampled_nii_masks'))
% addpath(genpath('Q:\home\txc531\Resampled_niis'))
%  cd('P:\Resampled_data\Grp2\CT_images_grp2')
option = 2;
niilist = dir('Q:\home\txc531\Resampled_niis')
niilist = dir('F:\.shortcut-targets-by-id\1XMJRxH2dyi3goZEnPT8yTg-qyuqaV6pJ\Grp1 Resampled')
% addpath(genpath('C:\Users\Pavi\Downloads\57'))
patid=[9];
switch option
    case 1 
        cd('P:\Resampled_data');
        %--------Compare dimensions of image and mask for group1----------%
        %----------------Dimensions of the patient images-----------------%
        for i=1:length(patid)
              patdata = [num2str(patid(1,i)),'-label.nii']
              vol = double(niftiread(patdata));
              vol = rot90(vol,3);
              vol = fliplr(vol);
              pat_img = vol;
              dim_img(i,:) = size(pat_img);
        end
        %---------------Dimensions of the patient masks-----------------%
        for i=1:length(patid)
              patdata = [num2str(patid(1,1)),'-1-label.nii']
              vol = double(niftiread(patdata));
              vol = rot90(vol,3);
              vol = fliplr(vol);
              TI_mask = vol;
              dim_mask(i,:) = size(TI_mask);
        end
        %-----------Check if image and mask are of same size--------------%
        if isequal(dim_img(:,1),dim_mask(:,1))==1
            fprintf('All patients image and mask have been resampled correctly.');
            
        else
            loc = find(dim_img(:,1)~=dim_mask(:,1))
            fprintf('Error in resampling for patient %d\n',loc);
        end
        %------------------------Plot the histogram-----------------------%
        
    case 2
        %------------Read and convert the patient volume files------------%
         for i=1:length(patid)
             patnum = num2str(patid(1,i));
              filepath=[niilist(i).folder,'\',patnum];
              cd(filepath)
               
              patdata = [patnum,'-1.nii']
              vol = double(niftiread(patdata));
              vol = rot90(vol,3);
              vol = fliplr(vol);
              vol_full = vol;
              
              patdata = [patnum,'-2.nii']
              vol = double(niftiread(patdata));
              vol = rot90(vol,3);
              vol = fliplr(vol);
              vol_half = vol;
           
              patdata = [patnum,'-3.nii']
              vol = double(niftiread(patdata));
              vol = rot90(vol,3);
              vol = fliplr(vol);
              vol_safire3 = vol;
               
              patdata = [patnum,'-4.nii']
              vol = double(niftiread(patdata));
              vol = rot90(vol,3);
              vol = fliplr(vol);
              vol_safire4 = vol;
             
              cd('C:\CT_Rectal\CTE_images_grp1')
              
              if exist([patnum,'-','CTE_grp1_resampled.mat'], 'file')
              save([patnum,'-','CTE_grp1_resampled.mat'],'vol_full','vol_half','vol_safire3','vol_safire4','-append')
              else
             save([patnum,'-','CTE_grp1_resampled.mat'],'vol_full','vol_half','vol_safire3','vol_safire4')
              end
         end
         
    case 3
        %-------------Read and convert the patient mask files------------%
         for i=1:length(patid)
             cd('P:\Resampled_data\Grp1\CT_TI_mask_grp1');
              patdata = [num2str(patid(1,i)),'-1-label.nii']
              vol = double(niftiread(patdata));
              vol = rot90(vol,3);
               vol = fliplr(vol);
              TI_mask = vol;
           
              save([num2str(patid(1,i)),'-','TI_mask_grp1_resampled.mat'],'TI_mask')
         end
         
    case 4
               namelist=[1:4:296]';
               maping=[1:74]';
               maping=[namelist,maping];
               kaustav_m=[177,181,189,193,197,209,221,233,241,245,257,261,265,269,273,277,281,285,289,293];
               cd('P:\Resampled_data\Grp2\CT_TI_mask_grp2')
         for i=1:length(namelist)
              patdata = [num2str(maping(i,1)),'-label.nii']
              vol = double(niftiread(patdata));
              vol = rot90(vol,3);
              vol = fliplr(vol);
              TI_mask = vol;
    
             qu=namelist(i);
             check_u=unique(TI_mask);
            
             if  qu>=177 && qu<=293 && ismember(qu,kaustav_m)
        
                   TI_mask(TI_mask==1)=-1;
                   TI_mask(TI_mask==2)=1;
                   TI_mask(TI_mask==-1)=2;   
             else
             end
     
          save([num2str(maping(i,2)),'-TI_mask_grp2_resampled.mat'],'TI_mask')
        end
end
sliceViewer(vol_half);
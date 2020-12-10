%extract features from CT_terminal_ileum
function fail=CTfeatextract_modified
addpath(genpath('P:\CT_Rectal\CT_Rectal_Code\scripts-master'))
% addpath(genpath('P:\Resampled_data\Features'))
addpath(genpath('P:\Resampled_data\Grp1\CT_images_grp1'))
addpath(genpath('O:\Resampled_data\Grp1\CT_TI_mask_grp1'))
addpath(genpath('C:\CT_Rectal\CTE_images_grp1'))
%  global maskoi
fail={};
cd('O:\Resampled_data\Features\Grp1')

useableCT=[9];
%useableCT=[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,55,56,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74];
l=length(useableCT);
% i=1;
%-----------------Find the minimum number of slices-----------------------%
% for q=1:l
%     i=useableCT(q);
%     patmasks=[num2str(i),'-TI_mask.mat'];
%     
%     D1= load(patmasks);
%     TI_mask=D1.TI_mask;
%     TI_mask(TI_mask>=1)=1;
%     [~,~,slices] = ind2sub(size(TI_mask),find(TI_mask==1));
%     slices=unique(slices);
%     slice_count (q) = length(slices); 
% end
% min_slices = min(slice_count);

for q=1:l
    i=useableCT(q);
    patimgs=[num2str(i),'-CTE_grp1_resampled.mat'];
    patmasks=[num2str(i),'-TI_mask_grp1_resampled.mat'];
    try
        D1= load(patmasks)
        %---Feature extraction with the lumen----%
        TI_mask=D1.TI_mask;
%         L_mask=D1.Lumen_mask;
%         TI_mask=L_mask+TI_mask;
        TI_mask(TI_mask>=1)=1;
%-----------------------Find the annotated slices-------------------------%
     [~,~,slices] = ind2sub(size(TI_mask),find(TI_mask==1));
     slices=unique(slices); 
%--------------------------------Find the largest slice-------------------%
%          volscan=sum(sum(TI_mask(:,:,slices)));
%          volscan=squeeze(volscan);
%          largest_slice=find(volscan==max(volscan));
%          largest_slice=slices(largest_slice);
% ----------------------------Range of slices-----------------------------%         
%          slicesrange=largest_slice;
%          topslice=max(slices);
%          botslice=min(slices);
%          min_slices = 5;
%          %----Equal number of slices centered around the largest slice---% 
%  %       rangeslice=[largest_slice-1:largest_slice+1];
%           rangeslice=[largest_slice:largest_slice+min_slices-1];
%          
%          if largest_slice >=botslice
%             rangeslice=[largest_slice:largest_slice+min_slices-1];
%          end
%          
%          if largest_slice == topslice | (largest_slice+min_slices-1) > topslice
%              rangeslice=[largest_slice-min_slices+1:largest_slice];
%          end
%          
%          if largest_slice == topslice-min_slices+1
%              rangeslice = [largest_slice:topslice];
%          end
%          
%          if topslice<(largest_slice+2)
%              shiftd=(largest_slice+2)-topslice;
%              rangeslice=[largest_slice-2-shiftd:topslice];
%          end
%          
%          if botslice>(largest_slice-2)
%             shiftup=botslice-(largest_slice-2);
%             rangeslice=[botslice:largest_slice+2+shiftup]; 
%          end
%          
%          if min_slices == numel(slices)
%              rangeslice=slices;
%          end
  rangeslice = slices;
  slices_TI = rangeslice;
%-----------------Connected Component : Single loop-----------------------%
% d = length(rangeslice);
% for j = 1:d
%     maskoi = TI_mask(:,:,rangeslice(j));
%     CC = bwconncomp(maskoi);
%        if CC.NumObjects==1
%           nhood = maskoi(CC.PixelIdxList{:,1});
%           maskoi = imclose(maskoi,nhood);
%           TI_mask(:,:,rangeslice(j)) = maskoi;
% %        elseif CC.NumObjects == 2
% %            nhood = vertcat(maskoi(CC.PixelIdxList{:,1}),maskoi(CC.PixelIdxList{:,2}));
% %            maskoi = imclose(maskoi,nhood);
% %            TI_mask(:,:,slicesrange(j)) = maskoi;
%         else
%           CC_single_loop_manual(maskoi);
%           TI_mask(:,:,rangeslice(j)) = maskoi;
%        end
% end 

        D2= load(patimgs);
        %vol_full=D2.vol_full;
        vol_half=D2.vol_half;
        vol_safire3=D2.vol_safire3;
        vol_safire4=D2.vol_safire4;
        
        class_options={'raw','gray','gradient','haralick','gabor','laws','collage'};
        ws_options = [3,5,7,9,11]
        
%         [featints_full,featnames,featstats_full,statnames] = extract2DFeatureInfo(vol_full(:,:,slicesfat),maskfat(:,:,slicesfat),class_options,ws_options);
%         [featints_half,featnames,featstats_half,statnames] = extract2DFeatureInfo(vol_half(:,:,slicesfat),maskfat(:,:,slicesfat),class_options,ws_options);
%         [featints_safire3,featnames,featstats_safire3,statnames] = extract2DFeatureInfo(vol_safire3(:,:,slicesfat),maskfat(:,:,slicesfat),class_options,ws_options);
%         [featints_safire4,featnames,featstats_safire4,statnames] = extract2DFeatureInfo(vol_safire4(:,:,slicesfat),maskfat(:,:,slicesfat),class_options,ws_options);
 
        
          %[featints_TI_full,featnames,featstats_TI_full,statnames] = extract3DFeatureInfo(vol_full(:,:,rangeslice),TI_mask(:,:,rangeslice),class_options,ws_options);
          [featints_TI_half,featnames,featstats_TI_half,statnames] = extract3DFeatureInfo(vol_half(:,:,rangeslice),TI_mask(:,:,rangeslice),class_options,ws_options);
          [featints_TI_safire3,featnames,featstats_TI_safire3,statnames] = extract3DFeatureInfo(vol_safire3(:,:,rangeslice),TI_mask(:,:,rangeslice),class_options,ws_options);
          [featints_TI_safire4,featnames,featstats_TI_safire4,statnames] = extract3DFeatureInfo(vol_safire4(:,:,rangeslice),TI_mask(:,:,rangeslice),class_options,ws_options);
        %
        %         [featints_TIp_full,featnames,featstats_TIp_full,statnames] = extract2DFeatureInfo(vol_full(:,:,slices),maskfat(:,:,slices),class_options,ws_options);
        %         [featints_TIp_half,featnames,featstats_TIp_half,statnames] = extract2DFeatureInfo(vol_half(:,:,slices),maskfat(:,:,slices),class_options,ws_options);
        %         [featints_TIp_safire3,featnames,featstats_TIp_safire3,statnames] = extract2DFeatureInfo(vol_safire3(:,:,slices),maskfat(:,:,slices),class_options,ws_options);
        %         [featints_TIp_safire4,featnames,featstats_TIp_safire4,statnames] = extract2DFeatureInfo(vol_safire4(:,:,slices),maskfat(:,:,slices),class_options,ws_options);
        %
%         slicesTI=topslice;
%         m=matfile([num2str(i),'-3Dfeats_TI_grp1.mat'],'Writable',true)
        %%%%%%%%%%%%%%%%%%%%%%%
%                 m.featints_full=featints_full;
%                 m.featints_half=featints_half;
%                 m.featints_safire3=featints_safire3;
%                 m.featints_safire4=featints_safire4;
%                 %%%%%%%%%%%%%%%%%%%%%%%
%                 m.featstats_full=featstats_full;
%                 m.featstats_half=featstats_half;
%                 m.featstats_safire3=featstats_safire3;
%                 m.featstats_safire4=featstats_safire4;
        %%%%%%%%%%%%%%%%%%%%%%%
       % m.featints_TI_full=featints_TI_full;
%         m.featints_TI_half=featints_TI_half;
%         m.featints_TI_safire3=featints_TI_safire3;
%         m.featints_TI_safire4=featints_TI_safire4;
        %%%%%%%%%%%%%%%%%%%%%%%
      %  m.featstats_TI_full=featstats_TI_full;
%         m.featstats_TI_half=featstats_TI_half;
%         m.featstats_TI_safire3=featstats_TI_safire3;
%         m.featstats_TI_safire4=featstats_TI_safire4;
%         %%%%%%%%%%%%%%%%%%%%%%%
        %                 %%%%%%%%%%%%%%%%%%%%%%%
        %         m.featints_TIp_full=featints_TIp_full;
        %         m.featints_TIp_half=featints_TIp_half;
        %         m.featints_TIp_safire3=featints_TIp_safire3;
        %         m.featints_TIp_safire4=featints_TIp_safire4;
        %         %%%%%%%%%%%%%%%%%%%%%%%
        %         m.featstats_TIp_full=featstats_TIp_full;
        %         m.featstats_TIp_half=featstats_TIp_half;
        %         m.featstats_TIp_safire3=featstats_TIp_safire3;
        %         m.featstats_TIp_safire4=featstats_TIp_safire4;
        %         %%%%%%%%%%%%%%%%%%%%%%%
%         
%         m.featnames=featnames;
%         m.statnames=statnames;
% %         m.slicesfat=slicesfat;
%      %   m.slicesTI=slices_TI;
% %         m.slices = slices;
%         m.slices_TI = rangeslice;

%         matfile([num2str(i),'-3Dfeats_TI_grp1.mat'],'Writable',false)
%         
         if exist([num2str(i),'-3Dfeats_TI_grp1.mat'], 'file')
              save([num2str(i),'-3Dfeats_TI_grp1.mat'],'featints_TI_half','featints_TI_safire3','featints_TI_safire4','featstats_TI_half','featstats_TI_safire3','featstats_TI_safire4','-append')
         else
             save([num2str(i),'-3Dfeats_TI_grp1.mat'],'featints_TI_half','featints_TI_safire3','featints_TI_safire4','featstats_TI_half','featstats_TI_safire3','featstats_TI_safire4','featnames','statnames','slices','slices_TI')
         end
    catch
        patimgs
    end
end
end

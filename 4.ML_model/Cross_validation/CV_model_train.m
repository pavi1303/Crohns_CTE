%CV testing
%objective: Using the training and testing splits generated in DisStudyFat
%I will run CV with the testing data being taken from the a different recon
%or dosage.
clear
addpath(genpath('W:\CT_Rectal'))
addpath(genpath('W:\Final_resampled_results\Featstack_subsets'))
addpath(genpath('W:\My_code'))

dontuse = 71;
fselmeth='wilcoxon';
pruning=1;
num_top_feats=6;
pruning_stage = ["NO", "ICC", "IS", "IS_ICC"];
for pset = 1:4
    pruning_level = pruning_stage(1,pset);
    switch pruning_level
        case 'NO'
            load('CT_TI_featstack_3Dresampled_nopruning_grp1.mat');
            cd('W:\Final_resampled_results\AUC_results\Reformatted\Cross_training\1.No_pruning');
        case 'ICC'
            load('CT_TI_featstack_3Dresampled_ICCpruning_grp1.mat');
            cd('W:\Final_resampled_results\AUC_results\Reformatted\Cross_training\2.ICC_pruning');
        case 'IS'
            load('CT_TI_featstack_3Dresampled_ISpruning_grp1.mat');
            cd('W:\Final_resampled_results\AUC_results\Reformatted\Cross_training\3.IS_pruning');
        case 'IS_ICC'
            load('CT_TI_featstack_3Dresampled_IS_ICCpruning_grp1.mat');
            cd('W:\Final_resampled_results\AUC_results\Reformatted\Cross_training\IS_ICC_pruning');
    end
    %-----NaN check---------------------%
    HO_AUC={};
    fea_cell={};
    HO_AUC1=[];
    HO_AUC2=[];
    HO_AUC3=[];
    try
        featstack_full=featstack_TI_full;
        featstack_half=featstack_TI_half;
        featstack_safire4=featstack_TI_safire4;
        
        featstack_full(isnan(featstack_TI_full))=0;
        featstack_half(isnan(featstack_TI_half))=0;
        featstack_safire4(isnan(featstack_TI_safire4))=0;
    catch
        featstack_TI_full(isnan(featstack_TI_full))=0;
        featstack_TI_half(isnan(featstack_TI_half))=0;
        featstack_TI_safire4(isnan(featstack_TI_safire4))=0;
    end
    
    featstack_full(isnan(featstack_full))=0;
    featstack_half(isnan(featstack_half))=0;
    featstack_safire4(isnan(featstack_safire4))=0;
    
    load('CTsubsets_lmn3.mat')%subset
    pat_id = (1:90)';
    newlist=setdiff(pat_id,dontuse);
    
    labels = labels(:,newlist);
    
    trainingdata=featstack_full(newlist,:);
    testingdata1=featstack_full(newlist,:);
    testingdata2=featstack_half(newlist,:);
    testingdata3=featstack_safire4(newlist,:);
    
    for iter=1:100
        trainingsplit=subsets(iter).training;
        testingsplit=subsets(iter).testing;
        for fset=1:3
            fea=[];
            training_set=trainingdata(trainingsplit{fset},:);
            testing_set1=testingdata1(testingsplit{fset},:);
            testing_set2=testingdata2(testingsplit{fset},:);
            testing_set3=testingdata3(testingsplit{fset},:);
            
            training_labels=labels(trainingsplit{fset});
            testing_labels=labels(testingsplit{fset});
            
            options = {'threshmeth','euclidean'};
            foldlabels{fset} = testing_labels;
            
            [training_set_swno,mean_val,mad_val]=sw_outlier_compensation(training_set);
            training_set=simplewhiten(training_set,mean_val,mad_val);
            testing_set1=simplewhiten(testing_set1,mean_val,mad_val);
            testing_set2=simplewhiten(testing_set2,mean_val,mad_val);
            testing_set3=simplewhiten(testing_set3,mean_val,mad_val);
            
            if pruning==0
                set_candiF=(1:length(training_set));
            else
                set_candiF=pick_best_uncorrelated_features(training_set,training_labels);
            end
            
            
            if strcmp(fselmeth,'mrmr')
                
                training_set_d = discretize(training_set(:,set_candiF), [-inf -1 1 inf]);
                fea = mrmr_mid_d(training_set_d,training_labels,num_top_feats); % MRMR
                fea = fea';
                fea=set_candiF(fea);
                
            else
                
                [IDX, ~] = rankfeatures(training_set(:,set_candiF)',training_labels,'criterion','wilcoxon','CCWeighting', 1);
                if length(find(IDX==1))>1 && size(data_set,2)>20 %occurs if CCWeighting is too high and not many features to choose from or if too few (<20) features in data_set
                    warning('Too many correlated features found. Only %i features chosen. Reduce CCWeighting in call to rankfeatures() to correct.',length(IDX)-length(find(IDX==1)));
                    fea = set_candiF(IDX(1:length(IDX)-length(find(IDX==1))));
                else
                    fea = set_candiF(IDX(1:num_top_feats));
                end
            end
            
            [temp_stats1_sw,~] = Classify_wrapper('RANDOMFOREST', training_set(:,fea) , testing_set1(:,fea), training_labels(:), testing_labels(:), options);
            [temp_stats2_sw,~] = Classify_wrapper('RANDOMFOREST', training_set(:,fea) , testing_set2(:,fea), training_labels(:), testing_labels(:), options);
            [temp_stats3_sw,~] = Classify_wrapper('RANDOMFOREST', training_set(:,fea) , testing_set3(:,fea), training_labels(:), testing_labels(:), options);
            
            stats1(iter,fset)=temp_stats1_sw;
            stats2(iter,fset)=temp_stats2_sw;
            stats3(iter,fset)=temp_stats1_sw;
            
            foldpredictions1_sw{fset} =  temp_stats1_sw.prediction;
            foldpredictions2_sw{fset} =  temp_stats2_sw.prediction;
            foldpredictions3_sw{fset} =  temp_stats3_sw.prediction;
            
            HO_AUC1(iter,fset)=temp_stats1_sw.AUC;
            HO_AUC2(iter,fset)=temp_stats2_sw.AUC;
            HO_AUC3(iter,fset)=temp_stats3_sw.AUC;
            
            fea_store{iter,fset}=fea;
            
            clear training_set* testing_set*
        end
        [FPR,TPR,~,AUC1_sw(iter,:),OPTROCPT] = perfcurve(foldlabels, foldpredictions1_sw, 1,'XVals', [0:0.02:1]);
        [FPR,TPR,T,AUC2_sw(iter,:),OPTROCPT] = perfcurve(foldlabels, foldpredictions2_sw, 1,'XVals', [0:0.02:1]);
        [FPR,TPR,T,AUC3_sw(iter,:),OPTROCPT] = perfcurve(foldlabels, foldpredictions3_sw, 1,'XVals', [0:0.02:1]);
    end
    featlist=fea_store(:,1:3);
    featlist=cell2mat(featlist);
    beta(:,1)=unique(featlist);
    beta(:,2)=count(featlist);
    beta=sortrows(beta,2,'descend');
    beta(:,2)=beta(:,2)/300;
    
    HO_AUC{gset,1}=mean(mean(AUC1_sw));
    HO_AUC{gset,2}=mean(mean(AUC2_sw));
    HO_AUC{gset,3}=mean(mean(AUC3_sw));
    HO_AUC{gset,4}=mean(std(AUC1_sw));
    HO_AUC{gset,5}=mean(std(AUC2_sw));
    HO_AUC{gset,6}=mean(std(AUC3_sw));
end

temp1=fea_cell{1,2};
top_fea=statnames(temp1(1:num_top_feats,1));
top_fea=top_fea';

%save(['CT_TI_resampled3D_entire_vol_grp1_IS_ICC_pruning_',num2str(num_top_feats),'_',fselmeth,'_','QDA.mat'],'fea_cell','HO_AUC','top_fea','HO_AUC1','HO_AUC2','HO_AUC3','stats1','stats2','stats3');
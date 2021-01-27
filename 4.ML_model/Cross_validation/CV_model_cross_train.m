
addpath(genpath('W:\CT_Rectal'))
addpath(genpath('W:\Final_resampled_results\Featstack_subsets'))
addpath(genpath('W:\My_code'))
addpath(genpath('W:\Final_resampled_results\AUC_results\fea_variables\wilcoxon\4.IS_ICC_pruning'))
cd('W:\Final_resampled_results');
dontuse = [71];
fselmeth='wilcoxon';
num_top_feats = 10;

for pruning_level = 1:4
    switch pruning_level
        case 1
            load('CT_TI_featstack_3Dresampled_nopruning_grp1.mat');
            top_fea = [283,421,408,794,802,252,797,810,265,266];%nopruning_wilcoxon
        case 2
            load('CT_TI_featstack_3Dresampled_ICCpruning_grp1.mat');
            top_fea = [204,175,242,561,283,563,976,223,59,986];%ICC_wilcoxon
        case 3
            load('CT_TI_featstack_3Dresampled_ISpruning_grp1.mat');
            top_fea = [634,635,214,1166,66,67,60,255,640,201];%IS_wilcoxon
        case 4
            load('CT_TI_featstack_3Dresampled_IS_ICCpruning_grp1.mat');
            top_fea = [800,145,179,462,49,48,164,810,789,151];%IS_ICC_wilcoxon
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
    pat_id = [1:90]';
    newlist=setdiff(pat_id,dontuse);
    
    labels = labels(:,newlist);
    trainingdata=featstack_safire4(newlist,:);
    testingdata1=featstack_full(newlist,:);
    testingdata2=featstack_half(newlist,:);
    testingdata3=featstack_safire4(newlist,:);
    
    for iter=1:100
        trainingsplit=subsets(iter).training;
        testingsplit=subsets(iter).testing;
        for fset=1:3
            training_set=trainingdata(trainingsplit{fset},:);
            testing_set1=testingdata1(testingsplit{fset},:);
            testing_set2=testingdata2(testingsplit{fset},:);
            testing_set3=testingdata3(testingsplit{fset},:);
            
            training_labels=labels(trainingsplit{fset});
            testing_labels=labels(testingsplit{fset});
            
            options = {'threshmeth','euclidean'};
            foldlabels{fset} = testing_labels;
            
            iter
            fset
            [training_set_swno,mean_val,mad_val]=sw_outlier_compensation(training_set);
            training_set=simplewhiten(training_set,mean_val,mad_val);
            testing_set1=simplewhiten(testing_set1,mean_val,mad_val);
            testing_set2=simplewhiten(testing_set2,mean_val,mad_val);
            testing_set3=simplewhiten(testing_set3,mean_val,mad_val);
            
            [temp_stats1_sw,~] = Classify_wrapper('RANDOMFOREST', training_set(:,fea) , ...
                testing_set1(:,fea), training_labels(:), testing_labels(:), options);
            [temp_stats2_sw,~] = Classify_wrapper('RANDOMFOREST', training_set(:,fea) , ...
                testing_set2(:,fea), training_labels(:), testing_labels(:), options);
            [temp_stats3_sw,~] = Classify_wrapper('RANDOMFOREST', training_set(:,fea) , ...
                testing_set3(:,fea), training_labels(:), testing_labels(:), options);
            
            stats1(iter,fset)=temp_stats1_sw;
            stats2(iter,fset)=temp_stats2_sw;
            stats3(iter,fset)=temp_stats1_sw;
            
            foldpredictions1_sw{fset} =  temp_stats1_sw.prediction;
            foldpredictions2_sw{fset} =  temp_stats2_sw.prediction;
            foldpredictions3_sw{fset} =  temp_stats3_sw.prediction;
            
            HO_AUC1(iter,fset)=temp_stats1_sw.AUC;
            HO_AUC2(iter,fset)=temp_stats2_sw.AUC;
            HO_AUC3(iter,fset)=temp_stats3_sw.AUC;
            
            clear training_set* testing_set*
        end
        
        [FPR,TPR,~,AUC1_sw(iter,:),OPTROCPT] = perfcurve(foldlabels, foldpredictions1_sw, 1,'XVals', [0:0.02:1]);
        [FPR,TPR,T,AUC2_sw(iter,:),OPTROCPT] = perfcurve(foldlabels, foldpredictions2_sw, 1,'XVals', [0:0.02:1]);
        [FPR,TPR,T,AUC3_sw(iter,:),OPTROCPT] = perfcurve(foldlabels, foldpredictions3_sw, 1,'XVals', [0:0.02:1]);
        
    end
    
    HO_AUC{gset,1}=mean(mean(AUC1_sw));
    HO_AUC{gset,2}=mean(mean(AUC2_sw));
    HO_AUC{gset,3}=mean(mean(AUC3_sw));
    HO_AUC{gset,4}=mean(std(AUC1_sw));
    HO_AUC{gset,5}=mean(std(AUC2_sw));
    HO_AUC{gset,6}=mean(std(AUC3_sw));    
end

%save(['CT_TI_resampled3D_entire_vol_grp1_IS_ICCpruning_S4_',num2str(num_top_feats),'_',fselmeth,'_','Randomforest.mat'],'fea_cell','HO_AUC','top_fea','HO_AUC1','HO_AUC2','HO_AUC3','stats1','stats2','stats3');
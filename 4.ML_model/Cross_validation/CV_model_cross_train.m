
addpath(genpath('W:\CT_Rectal'))
addpath(genpath('W:\Final_resampled_results\Featstack_subsets'))
addpath(genpath('W:\My_code'))
addpath(genpath('W:\Final_resampled_results\AUC_results\fea_variables\wilcoxon\4.IS_ICC_pruning'))
cd('W:\Final_resampled_results');
dontuse = [71];
fselmeth='wilcoxon';
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


load('CTsubsets_lmn3.mat')%replace this with the needed subset

list_dat=[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90]';
newlist=setdiff(list_dat,dontuse);

HO_AUC={};
fea_cell={};
for gset=1:1
    clear alpha* beta*
    switch gset
        case 1
            
            labels = labels(:,newlist);
            
            trainingdata=featstack_safire4(newlist,:);
            testingdata1=featstack_full(newlist,:);
            testingdata2=featstack_half(newlist,:);
            testingdata3=featstack_safire4(newlist,:);
            
        case 2
            
       
    end
    HO_AUC1=[];
    HO_AUC2=[];
    HO_AUC3=[];
    %     fea_store={};
    for iter=1:100
        trainingsplit=subsets(iter).training;
        testingsplit=subsets(iter).testing;
        for fset=1:3
            %             fea=[];
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
            
            % fea = [283,421,408,794,802,252,797,810,265,266];%nopruning_wilcoxon
            %fea = [204,175,242,561,283,563,976,223,59,986];%ICC_wilcoxon
            %fea = [634,635,214,1166,66,67,60,255,640,201];%IS_wilcoxon
            %fea = [800,145,179,462,49,48,164,810,789,151];%IS_ICC_wilcoxon
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

    clear AUC* temp* beta
end
%save(['CT_TI_resampled3D_entire_vol_grp1_IS_ICCpruning_S4_',num2str(num_top_feats),'_',fselmeth,'_','Randomforest.mat'],'fea_cell','HO_AUC','top_fea','HO_AUC1','HO_AUC2','HO_AUC3','stats1','stats2','stats3');
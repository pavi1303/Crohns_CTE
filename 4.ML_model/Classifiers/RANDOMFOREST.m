function [methodstring,stats] = RANDOMFOREST( training_set , testing_set, training_labels, testing_labels, options )
% The function was originally written by George Lee @2009
% Last updated: @11-21-2018

% options: (...,Name, Value,..) pairs
%  'threshmeth': 'euclidean' (default) or 'matlab'
%  and then all other TreeBagger Name-Value pairs
%  (i.e. 'NumTrees',...)

methodstring = 'RANDOMFOREST';

%Define required Name-Value pair arguments
idx = find(strcmpi(options,'threshmeth'));
if isempty(idx), threshmeth = 'euclidean'; else threshmeth = options{idx+1}; end
options(idx:idx+1) = []; options = squeeze(options);

idx = find(strcmpi(options,'NumTrees'));
if isempty(idx), NumTrees = 51; else NumTrees = options{idx+1}; end
options(idx:idx+1) = []; options = squeeze(options);

% Prepare
unq_tra_lab = unique(training_labels);
if numel(unq_tra_lab) ~= 2
    error('Only 2 labels allowed');
else
    idx1 = ismember(training_labels,unq_tra_lab(1));
    idx2 = ismember(training_labels,unq_tra_lab(2));
    training_labels(idx1) = 0;
    training_labels(idx2) = 1;
    idx1 = ismember(testing_labels,unq_tra_lab(1));
    idx2 = ismember(testing_labels,unq_tra_lab(2));
    testing_labels(idx1) = 0;
    testing_labels(idx2) = 1;
end


Mdl = TreeBagger(NumTrees,training_set,training_labels, options{:});
[~,probs,~] = predict(Mdl,testing_set);



% c(1,2) is the coefficient info for comparing class 1 to class 2
targetclass = 2; %2nd column of probs is where positives re
targetclass_name = 1; %1 = positives
predictions = single(probs(:,targetclass));
stats.prediction = predictions;

if exist('testing_labels','var') && numel(unique(testing_labels)) > 1
    [FPR,TPR,T,AUC,OPTROCPT,~,~] = perfcurve(testing_labels,predictions,targetclass_name,'XVals', [0:0.02:1]);  % calculate AUC. 'perfcurve' can also calculate sens, spec etc. to plot the ROC curve.
   
    if strcmp(threshmeth,'euclidean')
        [~, optim_idx] = determine_threshold_euclidean_distance(FPR,TPR,T);
    elseif strcmp(threshmeth,'matlab')
        optim_idx = find(FPR == OPTROCPT(1) & TPR == OPTROCPT(2));
    else
        error('Invalid "threshmeth" string option.');
    end
    
    stats.AUC = AUC;
    stats.optThresh = T(optim_idx);
    stats.thresholdmethod = threshmeth;
    stats.decision = stats.prediction >= stats.optThresh;
    stats.tp = length(find(stats.decision(testing_labels==targetclass_name)==targetclass_name)); 
    stats.tn = length(find(stats.decision(testing_labels~=targetclass_name)~=targetclass_name)); 
    stats.fp = length(find(stats.decision(testing_labels~=targetclass_name)==targetclass_name)); 
    stats.fn = length(find(stats.decision(testing_labels==targetclass_name)~=targetclass_name)); 
    stats.acc = (stats.tp+stats.tn)/(stats.tp+stats.tn+stats.fp+stats.fn);
    stats.ppv = stats.tp/(stats.tp+stats.fp);
    stats.sens = stats.tp/(stats.tp+stats.fn);
    stats.spec = stats.tn/(stats.fp+stats.tn);
    Pre = ((stats.tp+stats.fp)*(stats.tp+stats.fn) + (stats.tn+stats.fn)*(stats.tn+stats.fp)) / (stats.tp+stats.tn+stats.fp+stats.fn)^2;
    stats.kappa = (stats.acc - Pre) / (1 - Pre);        
    stats.Fscore = 2*stats.tp/(2*stats.tp+stats.fp+stats.fn);
    stats.OPTROCPT = OPTROCPT;


end

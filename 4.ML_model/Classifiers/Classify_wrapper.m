function [stats, methodstring,Mdl] = Classify_wrapper(method, training_set, testing_set, training_labels, testing_labels, options)
% Wrapper function to call any one of CCIPD's implemented classifier methods

% previously, all of this was implementable:
%       if ismember(lower(method),{'baggedc45','svm','onevsone_baggedc45','baggedc45_notraining','baggedc45_notraining_multiclass','baggedc45_multiclass','nbayes','nbayes_notraining','qda','lda'})
% now:
if nargin < 6
    options = {};
end

if ismember(method,{'LDA','QDA','SVM','RANDOMFOREST'})
    [methodstring,stats]=feval(method, training_set, testing_set, training_labels, testing_labels, options);
else
    error('Unsupported classification method');
end
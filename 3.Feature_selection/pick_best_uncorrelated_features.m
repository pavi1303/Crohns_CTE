function set_candiF=pick_best_uncorrelated_features(data,classes,idx_pool,num_features,correlation_factor,correlation_metric)
% Eliminate correlated features from large feature set giving priority to
% significant features based on ranksum test
%
% Compare with: rankfeatures() in MATLAB using the CCWeighting parameter
%
% INPUTS:
%   data = MxN feature matrix with M observations and N variables
%   classes = Mx1 vector of class labels corresponding to observations in data
%   num_features = maximum size of uncorrelated feature set to be returned ([DEFAULT: returns entire set of uncorrelated features]
%   idx_pool = indices to include in feature pool (i.e. for per-class feature selection). [DEFAULT: all features]
%   correlation_factor = minimum correlation between features to trim [DEFAULT: 0.6]
%   correlation_metric = 'pearson' (parametric) or 'spearman' (nonparametric) [Default: 'spearman']
% 
% OUTPUTS:
%   set_candiF = vector of sortd feature indices of those features which were uncorrelated yet most discriminative
%
% Original Author: Nate Braman, 2017
% Modified by: Jacob Antunes, 2018
% 

%% CHECK INPUTS
if isa(classes,'cell'), error('CLASSES must be a non-cell array with labels 1 and -1.'); end
classes = double(classes);
classes(classes==0) = -1;
if any(~xor(classes == 1, classes == -1)), error('CLASSES must be 1 and -1'); end
if size(data,1)~=length(classes), error('CLASSES must contain same number of labels as observations in DATA'); end

%% DEFAULTS

if exist('idx_pool','var')~=1 || isempty(idx_pool)
    idx_pool = 1:size(data,2); 
end
if exist('num_features','var')~=1 || isempty(num_features)
    num_features = length(idx_pool); 
end

%if the user hasn't specified a number of features desired, we don't need to throw a warning.
if num_features == length(idx_pool)
    warning_numfeatures = false;
else
    warning_numfeatures = true;
end

if exist('correlation_factor','var')~=1 || isempty(correlation_factor)
    correlation_factor=0.6;
end
if exist('correlation_metric','var')~=1 || isempty(correlation_metric)
    correlation_metric='Spearman';
end

%% PRELIM CHECK: GET RID OF BAD FEATURES
idxs2rem = [];

%Remove any features with nans (non-optional)
[~,c] = ind2sub(size(data),find(isnan(data)));
idxs2rem = unique(c);
        
% data must not contain too few unique values (#unique must be >= 10% of observations)
for i = 1:size(data,2)
    if length(unique(data(:,i)))<=floor(0.1*size(data,1))
        idxs2rem = cat(1,idxs2rem, i);
    end
end
idx_pool(ismember(idx_pool,unique(idxs2rem))) = []; %list of feature still to look through

%% KEEP DATA ORGANIZED BY P-VALS SO THAT WE GIVE PREFERENCE TOWARDS MORE DISCRIMINATIVE FEATURES

pos = find(classes==1);
neg = find(classes==-1);

for i = 1:length(idx_pool)
    if strcmp(lower(correlation_metric),'pearson')
            [~,pvals(i)] = ttest2(data(pos,idx_pool(i)),data(neg,idx_pool(i)));
    elseif strcmp(lower(correlation_metric),'spearman')
            pvals(i) = ranksum(data(pos,idx_pool(i)),data(neg,idx_pool(i)));
    else
        error('Invalid CORRELATION_METRIC');
    end
end
% [~,idxSort] = sort(pvals,'ascend');
[~,keepIdx] = min(pvals);

set_candiF(1) = idx_pool(keepIdx); %keep the most discriminative feature
[RHO]=corr(data(:,idx_pool),'Type',correlation_metric); %how correlated are the rest of the features with this feature?
correlated = find(abs(RHO(keepIdx,:))>correlation_factor); %identify the features which are correlated
idx_pool(correlated) = []; %remove these features from our pool [NOTE: This will also remove the current feature of interest]
pvals(correlated) = [];

%% ITERATE
while length(set_candiF)<num_features && ~isempty(idx_pool) %and now repeat this scheme for the rest of the feature pool... 
    
    [~,keepIdx] = min(pvals);

    set_candiF = [set_candiF, idx_pool(keepIdx)]; %keep the next most discriminative feature
    [RHO]=corr(data(:,idx_pool),'Type',correlation_metric); %how correlated are the rest of the features with this feature?
    correlated = find(abs(RHO(keepIdx,:))>correlation_factor); %identify the features which are correlated
    idx_pool(correlated) = []; %remove these features from our pool [NOTE: This will also remove the current feature of interest]
    pvals(correlated) = [];

end

if warning_numfeatures && length(set_candiF)<num_features
    warning(sprintf('Too many correlated features. Only able to return %i num_features.',length(set_candiF)));
end 
set_candiF = sort(set_candiF);

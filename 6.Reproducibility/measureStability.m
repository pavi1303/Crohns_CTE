% Calcultes intra- and inter-dataset stability
% Inputs:
% data: Cell array where each cell contains a matrix of feature values from a specific site
% rows of the data are patients, columns are feature values
% nIter: Number of random splits to perform in calculating instability
% outputDir: Where to save results (note, saves all variables, not just
% scores).  Will save 'stability.mat' to this location

function [interDifScore intraDifScore,H] = measureStability(data,nIter,outputDir,fname,alpha)


% If no save directory is given
if(nargin < 3)
    outputDir = [];
    fname = 'stability.mat';
end
if(nargin < 4)
    fname = 'stability.mat';
end


% Number of features is number of columns
featCount = length(data{1}(1,:));

%% Intra-dataset stability (Latent instability score)
% Randomly splits a dataset in half, compares features for significance
% across splits.  Tests "noisyness" of data.  Measures "expected"
% instability that would be seen without inter-dataset effects that is, if
% dataset variation did not affect features.
% Performed seperately for each dataset

% Recomended to load pre-computed LI scores after having run once and saved
% results
% load('path to intraDifScore');

% store tally of feature differences across random splits
intraDifTally = cell(1,length(data));

% To store final normalized scores
intraDifScore = cell(1,length(data));

for(k = 1:length(data))
    
    % Initalize to matrix of zeros with length = number of features
    intraDifTally{k} = zeros(1,featCount);
    
    % split dataset and tally features different
    for(i = 1:nIter)
        
        if(mod(i,10) == 0)
            fprintf('LI Iteration %d \n',i)
        end
        
        % randomly split dataset
        B=randperm(length(data{k}(:,1)));
        set1 = B(1:floor(length(B)/2));
        set2 = B((floor(length(B)/2) + 1):length(B));
        
        H = zeros(1,featCount);
        
        % Compare every feature across halves
        for(ii = 1:featCount)
            
            [P H(ii)] = ranksum(data{k}(set1,ii),data{k}(set2,ii),'alpha',alpha);
            
        end
        
        intraDifTally{k} = intraDifTally{k} + H;
    end
    
    % normalize scores
    intraDifScore{k} = intraDifTally{k} / nIter;
end

% Recomended to save intraDifScore to avoid running each time
% save('filepath','intraDifScore');

%% Inter-dataset stability (Preperation-induced instability score)
% Measures observed instability between datasets
% Tests a feature across every possible pairwise comparion of datasets

% Tallies feature differences between datasets
interDifTally = zeros(1,featCount);
%

% New subsampling method
for(i = 1:featCount)
    fprintf('Inter-Dif feature %d \n',i)
    for(ii = 1:length(data))
        for(r = (ii+1):length(data))
            
            % Store result of each subset comparison
            H = zeros(1,nIter);
            
            % split dataset and tally features different
            for(z = 1:nIter)
                
                % use 3/4 of each dataset per iteration
                B1=datasample(1:size(data{r},1),round(length(data{r}(:,1)) * 3/4),'replace',false);
                B2=datasample(1:size(data{ii},1),round(length(data{ii}(:,1)) * 3/4),'replace',false);
                datar=data{r}(B1,i);
                dataii=data{ii}(B2,i);
%                 [datar,mean_vec,mad_vec]=simplewhiten(datar);
%                 [dataii]=simplewhiten(dataii,mean_vec,mad_vec);
                
                % Compare feature across subsets
                [P,H(z)] = ranksum(dataii,datar,'alpha',alpha);
            end
            
            interDifTally(i) = interDifTally(i) +  mean(H);
        end
    end

end

% normalize scores
interDifScore= interDifTally / nchoosek(length(data),2);


end
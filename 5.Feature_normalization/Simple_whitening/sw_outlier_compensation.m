function [whiteneddata,mean_vec,mad_vec,outfreq,idx] = simplewhitennooutlier(data)
datanoout={};

% if nargin>2
%     temp = bsxfun(@minus,data,mean_vec);			%subtract means
%     
% elseif nargin>1
%     fprintf('Error Missing mean_vec or mad_vec')
% return 
   temp1 = prctile(data,[5 95],1); %Find 5th and 95 percentile feature-wise
   for i=1:length(data)
      idx{i} = find((data(:,i)<temp1(1,i)) | (data(:,i)>temp1(2,i))); %Find the indices of the outliers feature-wise
      tempdata = data(:,i);
      tempdata(idx{1,i},:)=[];
      tempmean = mean(tempdata);
      tempmad = mad(tempdata);
      datanoout{i} = tempdata;
      mean_vec(i) = tempmean;
      mad_vec(i) = tempmad;
   end
   temp = cellfun(@minus,datanoout,num2cell(mean_vec),'UniformOutput',false);
%used cellfun because the number of outliers can be different for each
%feature

if sum(mad_vec)>=0								%checking for any MAD=0
    idx1 = find(mad_vec==0);
    mad_vec(idx1) = 1;                        
end

%Find the number of outliers patient-wise
for i = 1:size(data,1)
    for j = 1:size(idx,2)
        count(i,j) = sum(idx{1,j}==i);
    end
end
countpw= sum(count,2);
[out1,idx1]=sort(countpw,'descend');
out1=out1/size(data,2);
outfreq = horzcat(idx1,out1);         

whiteneddata = cellfun(@rdivide,temp,num2cell(mad_vec),'UniformOutput',false);
end%divide by MAD
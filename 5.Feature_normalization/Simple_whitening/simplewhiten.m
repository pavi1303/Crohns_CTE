function [whiteneddata,mean_vec,mad_vec] = simplewhiten(data,mean_vec,mad_vec)
%function whiteneddata = simplewhiten(data)
%Whitening the data: Mean=0,MAD=1 on a per-feature basis
%Data should be N x D
%Accounts for cases where MAD=0 too
%Satish Viswanath, Mar 2010

if nargin>2
    temp = bsxfun(@minus,data,mean_vec);			%subtract means
    
elseif nargin>1
    fprintf('Error Missing mean_vec or mad_vec')
    return 
else
    mean_vec = mean(data,1);
    temp = bsxfun(@minus,data,mean_vec);
    mad_vec = mad(data,1);
end

if sum(mad(data,1))>=0								%checking for any MAD=0
    idx = find(mad(data,1)==0);
    mad_vec(idx) = 1;                               %#ok<FNDSB>
end
whiteneddata = bsxfun(@rdivide,temp,mad_vec);		%divide by MAD


end
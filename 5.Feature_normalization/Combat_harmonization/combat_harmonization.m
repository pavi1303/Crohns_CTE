 %-------------------COMBAT HARMONIZATION----------------------%
    addpath(genpath('P:\CT_Rectal'))
    cd('P:\CT_Rectal\My_trial_2\Largest_TI\ComBat\Data\Non-parametric')
    
    load('CTfeatstack_largest_TI.mat');
    featstack_TI_full(isnan(featstack_TI_full))=0;
    featstack_TI_half(isnan(featstack_TI_half))=0;
    featstack_TI_safire3(isnan(featstack_TI_safire3))=0;
    featstack_TI_safire4(isnan(featstack_TI_safire4))=0;
    
    labels1 = labels;
    data1 = {featstack_TI_full;featstack_TI_half;featstack_TI_safire3;featstack_TI_safire4}';
    batch1 = repelem(1,size(data1,1));
       
    load('CTfeatstack_largest_TI_grp2_all.mat');
    featstack_TI_full(isnan(featstack_TI_full))=0;
    featstack_TI_half(isnan(featstack_TI_half))=0;
    featstack_TI_safire3(isnan(featstack_TI_safire3))=0;
    featstack_TI_safire4(isnan(featstack_TI_safire4))=0;
    
    labels2 = labels;
    data2 = {featstack_TI_full;featstack_TI_half;featstack_TI_safire3;featstack_TI_safire4}';
    batch2 = repelem(2,size(data2,1));
    
    batch = horzcat(batch1,batch2);
    mod = horzcat(labels1,labels2)';
    
     dat = vertcat(data1,data2)';
    for k = 1: length(data1)
    dat = vertcat(data1{k},data2{k})';
    
    %Find the S.D feature-wise and remove features that have same values
    %across different patients. 
    [sds] = std(dat')';
    wh = find(sds==0);
    [ns,ms] = size(wh);
    if ns>0
        error('Error. There are rows with constant values across samples. Remove these rows and rerun ComBat.')
    end
    %Find the number of batches and then encoding a dummy variable to it. 
    batchmod = categorical(batch);
    batchmod = dummyvar({batchmod});
	n_batch = size(batchmod,2);
	levels = unique(batch);
	fprintf('[combat] Found %d batches\n', n_batch);

    %Find the number of samples in each batch and the total number of
    %samples in all the batches
	batches = cell(0);
	for i=1:n_batch
		batches{i}=find(batch == levels(i));
	end
	n_batches = cellfun(@length,batches);
	n_array = sum(n_batches);

	% Creating design matrix and removing intercept:
    %Under what circumstances do you have to neglect the intercetpt, like
    %when does the information provided by the intercept is not so useful?
    %Since intercept is nothing but the mean value of the y when all the
    %dependent variables are zero and it doesn't happen here, intercept has
    %no intrinsic meaning and hence removed?
	design = [batchmod mod];
	intercept = ones(1,n_array)';
	wh = cellfun(@(x) isequal(x,intercept),num2cell(design,1));
	bad = find(wh==1);
	design(:,bad)=[];


	fprintf('[combat] Adjusting for %d covariate(s) of covariate level(s)\n',size(design,2)-size(batchmod,2))
	% Check if the design is confounded
    %To check if the colums/rows (i.e the batches and covariates of
    %interest are linearly independednt ant thus don't introduce bias 
	if rank(design)<size(design,2)
		nn = size(design,2);
	    if nn==(n_batch+1) 
	      error('Error. The covariate is confounded with batch. Remove the covariate and rerun ComBat.')
	    end
	    if nn>(n_batch+1)
	      temp = design(:,(n_batch+1):nn);
	      if rank(temp) < size(temp,2)
	        error('Error. The covariates are confounded. Please remove one or more of the covariates so the design is not confounded.')
	      else 
	        error('Error. At least one covariate is confounded with batch. Please remove confounded covariates and rerun ComBat.')
	      end
	    end
    end
    
	fprintf('[combat] Standardizing Data across features\n')
    
	%Standarization Model
    %Estimate of the parameter 
	B_hat = inv(design'*design)*design'*dat';
    %Not able to get what is this grand mean and stand mean? 
    grand_mean = (n_batches/n_array)*B_hat(1:n_batch,:);
    %Isn't this the residual standard error? sum((y-Xb)^2)
	var_pooled = ((dat-(design*B_hat)').^2)*repmat(1/n_array,n_array,1);
	stand_mean = grand_mean'*repmat(1,1,n_array);

	if not(isempty(design))
		tmp = design;
		tmp(:,1:n_batch) = 0;
		stand_mean = stand_mean+(tmp*B_hat)';
    end	
    %THis is the standardized data (data - mean)/S.D
    %It is assumed to follow the normal distribution
	s_data = (dat-stand_mean)./(sqrt(var_pooled)*repmat(1,1,n_array));

	%Get regression batch effect parameters
    %Gamma and delta represent the batch effect parameter
    %Estimation is using method of moments
	fprintf('[combat] Fitting L/S model and finding priors\n')
	batch_design = design(:,1:n_batch);
	gamma_hat = inv(batch_design'*batch_design)*batch_design'*s_data';
	%ssumption 2 - S.D follows inverse gamma distribution
    delta_hat = [];
	for i=1:n_batch
		indices = batches{i};
		delta_hat = [delta_hat; var(s_data(:,indices)')];
    end
    %How is the variance generally calculated? Is it around the mean because
    %the supplementary involves calculating it around the mean. 
	%Find parametric priors:
    %Gamma bar and t2 represent the estimates of the mean and SD of the
    %data (assumed to follow normal distribution)
	gamma_bar = mean(gamma_hat');
	t2 = var(gamma_hat');
	delta_hat_cell = num2cell(delta_hat,2);
    %a prior and b prior are the moments (estimates).
    %a prior - mean and b prior - variance
	a_prior=[]; b_prior=[];
	for i=1:n_batch
		a_prior=[a_prior aprior(delta_hat_cell{i})];
		b_prior=[b_prior bprior(delta_hat_cell{i})];
	end

if method == 1	
        fprintf('[combat] Finding parametric adjustments\n')
        gamma_star =[]; delta_star=[];
        for i=1:n_batch
            indices = batches{i};
            temp = itSol(s_data(:,indices),gamma_hat(i,:),delta_hat(i,:),gamma_bar(i),t2(i),a_prior(i),b_prior(i), 0.001);
            gamma_star = [gamma_star; temp(1,:)];
            delta_star = [delta_star; temp(2,:)];
        end
else	    
        gamma_star =[]; delta_star=[];
        fprintf('[combat] Finding non-parametric adjustments\n')
        for i=1:n_batch
            indices = batches{i};
            temp = inteprior(s_data(:,indices),gamma_hat(i,:),delta_hat(i,:));
            gamma_star = [gamma_star; temp(1,:)];
            delta_star = [delta_star; temp(2,:)];
        end
end
	    
	fprintf('[combat] Adjusting the Data\n')
	bayesdata = s_data;
	j = 1;
	for i=1:n_batch
		indices = batches{i};
		bayesdata(:,indices) = (bayesdata(:,indices)-(batch_design(indices,:)*gamma_star)')./(sqrt(delta_star(j,:))'*repmat(1,1,n_batches(i)));
		j = j+1;
	end
	bayesdata = (bayesdata.*(sqrt(var_pooled)*repmat(1,1,n_array)))+stand_mean;
    data_combat {k} = bayesdata;
    end
    for i = 1: length(data_combat)
    data = data_combat{i};
    featstack_TI_tra{i} = data(:,1:89)'
    featstack_TI_val {i} = data(:,90:163)'
end

%  featstack_TI_full = featstack_TI_tra{1};
%  featstack_TI_half = featstack_TI_tra{2};
%  featstack_TI_safire3 = featstack_TI_tra{3};
%  featstack_TI_safire4 = featstack_TI_tra{4};
%  labels=labels1;

featstack_TI_full = featstack_TI_val{1};
featstack_TI_half = featstack_TI_val{2};
featstack_TI_safire3 = featstack_TI_val{3};
featstack_TI_safire4 = featstack_TI_val{4};
labels = labels2;

% save(['CT_combat_harmonization_data.mat'],'dat','batch','mod','data_combat','design','s_data');
 %save(['CT_featstack_largest_TI_combat_grp1_nonpara.mat'],'featstack_TI_full','featstack_TI_half','featstack_TI_safire3','featstack_TI_safire4','labels','statnames');
%save(['CT_featstack_largest_TI_combat_grp2_nonpara.mat'],'featstack_TI_full','featstack_TI_half','featstack_TI_safire3','featstack_TI_safire4','labels','statnames');
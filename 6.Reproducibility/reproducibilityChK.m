function reproducibilityChK(groupstack,iteration,fname)
addpath(genpath('F:\CT_Rectal\CT_Rectal_Code\scripts-master'))
addpath(genpath('F:\CT_Rectal'))

q=(length(groupstack(:,1)):-1:1)
ps=nchoosek(q,2);
l1=size(ps,1);
ICC_final=[];
ICC_final_layer=[];
CVm_final=[];
nu_CVm_final=[];
iccset=1;
iteration=100;
%%%%%%%%%ICC%%%%%%%%%%%%%%%%%%%%%%%

for i=1:l1
    g1=groupstack{ps(i,1),1};
    g2=groupstack{ps(i,2),1};

    for iter=1:iteration
        sel1=randperm(size(g1,1),ceil(size(g1,1)*.75));
        sel2=randperm(size(g2,1),ceil(size(g2,1)*.75));
        g1sub=[g1(sel1,:)];
        g2sub=[g2(sel1,:)];
        for j=1:size(g1,2)
            comb=[g1sub(:,j),g2sub(:,j)];
           [r(iter,j), LB(iter,j), UB(iter,j), F(iter,j), df1(iter,j), df2(iter,j), p(iter,j)]= ICC(comb,'A-1',0.05,0);
        end
    end
    ICC_final=[ICC_final;r];
    ICC_final_layer(i,:)=mean(ICC_final,1);
end
ICC_final_mean=mean(ICC_final,1);

for i=1:l1
    g1=groupstack{ps(i,1),1};
    g2=groupstack{ps(i,2),1};

    for iter=1:iteration
        sel1=randperm(size(g1,1),ceil(size(g1,1)*.75));
        sel2=randperm(size(g2,1),ceil(size(g2,1)*.75));
        pair=[g1(sel1,:);g2(sel1,:)];
        for j=1:size(g1,2)
                meanofpair=mean(pair(:,j));
                numer=((meanofpair')*cov(pair(:,j))*meanofpair);
                denom=((meanofpair')*meanofpair)^2;
                Temp_CVm(iter,j)=(numer/denom)^(1/2);
                nunumer=std(pair);
                nudenom=abs(mean(pair));
                nu_Temp_CVm(iter,j)=(nunumer/nudenom);
        end
    end
    CVm_final=[CVm_final;Temp_CVm];
    nu_CVm_final=[nu_CVm_final;nu_Temp_CVm];
end
COV_InterPair_mean=(mean(CVm_final));
COV_InterPair=log(COV_InterPair_mean);

nu_COV_InterPair_mean=(mean(nu_CVm_final));
nu_COV_InterPair=log(nu_COV_InterPair_mean);

save(fname,'ICC_final_mean','ICC_final','ICC_final_layer','COV_InterPair','COV_InterPair_mean','nu_COV_InterPair','nu_COV_InterPair_mean')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Instability measure%%%%%%%%%%%%%%%%%%%%%%%%

alpha=nchoosek(q,2);

Dirname='F:\CT_Rectal\My_trial_2\Reproducibility\Unwhitened';
istest=1;

if istest==1
    for f=1:size(alpha,1)
        [alpha(f,1),alpha(f,2)]
        a1=groupstack{alpha(f,1),1};
        a2=groupstack{alpha(f,2),1};
        permed_nor{f}={a1;a2};
        data_01=permed_nor{f};
        fname2=['Int_pw',num2str(alpha(f,1)),'_',num2str(alpha(f,2)),'.mat']
        [interDiftemp, intraDiftemp,H]=measureStability(data_01,iteration,Dirname,fname2,.05/iteration);
        clear data_01
        Score_pw_sw(f,:)=[interDiftemp,alpha(f,1),alpha(f,2)];
        %H_out_sw(f,:)=H;
    end
    instabScore_sw=mean(Score_pw_sw(:,1:end-2));
    save(fname','instabScore_sw','Score_pw_sw','-append')
end
end

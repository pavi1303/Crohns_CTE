addpath(genpath('F:\CT_Rectal\CT_Rectal_Code\scripts-master'))
addpath(genpath('F:\CT_Rectal'))
ICC_h=ICC_final_mean;
graycolumnindices = [1:21 197:217 393:413 589:609];
ICC_h(:,graycolumnindices)=[];
y=prctile(ICC_h,[100 90 80 70 50]);
bin_values = [y(2:5)];
gorl = 1;
feature_family_range = {[1:10 176:185 351:360 526:535],[11:75 186:250 361:425 536:600],[76:115 251:290 426:465 601:640],[116:149 291:324 466:499 641:674],[150:175 325:350 500:525 675:700]};
legend = {'Haralick','Gradient','Laws','Gabor','COLIAGe'};
stackedbarplot(ICC_h,bin_values,feature_family_range,legend,gorl);

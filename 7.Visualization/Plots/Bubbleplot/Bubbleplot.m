graycolumnindices=[1:21 197:217 393:413 589:609];
haralickcolumnindices=[32:96 228:292 424:488 620:684]
lawscolumnindices=[22:31 218:227 414:423 610:619];
gaborcolumnindices=[137:170 333:366 529:562 725:758];
gradientcolumnindicies=[97:136 293:332 489:528 685:724];
coliagecolumnindices=[171:196 367:392 563:588 759:784];

g=horzcat(zeros(length(ICC_mean(graycolumnindices)),1)',ones(length(ICC_mean(haralickcolumnindices)),1)',2*ones(length(ICC_mean(lawscolumnindices)),1)',3*ones(length(ICC_mean(gaborcolumnindices)),1)',4*ones(length(ICC_mean(gradientcolumnindicies)),1)',5*ones(length(ICC_mean(coliagecolumnindices)),1)');
var1=horzcat(ICC_mean(graycolumnindices),ICC_mean(haralickcolumnindices),ICC_mean(lawscolumnindices),ICC_mean(gaborcolumnindices),ICC_mean(gradientcolumnindicies),ICC_mean(coliagecolumnindices));
var2=horzcat(IS_mean(graycolumnindices),IS_mean(haralickcolumnindices),IS_mean(lawscolumnindices),IS_mean(gaborcolumnindices),IS_mean(gradientcolumnindicies),IS_mean(coliagecolumnindices));
res=gscatter(var2,var1,g,'rgbkym',[],[25 25 25 25 25 25],'on');
legend('Gray','Haralick','Laws','Gabor','Gradient','COLIAGe');
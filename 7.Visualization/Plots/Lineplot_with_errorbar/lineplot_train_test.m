
%%%%%%%%%%%%%%----------------DISCOVERY SET----------------%%%%%%%%%
%------------------------Wilcoxon feature selection----------------------%
Top_fea = linspace(6,10,5)
figure;
p1 = errorbar(Top_fea,AUC_train_wilcoxon(1,1:5),AUC_train_wilcoxon(1,6:10),'--or','MarkerSize',10,'MarkerEdgeColor','red','MarkerFaceColor','red','LineWidth',2)
hold on
p2 = errorbar(Top_fea,AUC_train_wilcoxon(2,1:5),AUC_train_wilcoxon(2,6:10),'-ob','MarkerSize',10,'MarkerEdgeColor','blue','MarkerFaceColor','blue','LineWidth',2)
hold on
grid on
grid minor
xlim([5 11])
ylim([0 1.1])
title('Discovery set : Wilcoxon (3D features) - Only IS pruning','FontSize',30)
xlabel('Number of top features','FontSize',20)
ylabel('Area Under the Curve (AUC)','FontSize',20)
legend('QDA - Full dose','Randomforest - Full dose','Location','southeast','FontSize',20)


%%%%%%%%%%%%%%----------------DISCOVERY SET----------------%%%%%%%%%
%------------------------mrmr feature selection----------------------%
figure;
p1 = errorbar(Top_fea,AUC_train_mrmr(1,1:5),AUC_train_mrmr(1,6:10),'--or','MarkerSize',10,'MarkerEdgeColor','red','MarkerFaceColor','red','LineWidth',2)
hold on
p2 = errorbar(Top_fea,AUC_train_mrmr(2,1:5),AUC_train_mrmr(2,6:10),'-ob','MarkerSize',10,'MarkerEdgeColor','blue','MarkerFaceColor','blue','LineWidth',2)
hold on
grid on
grid minor
xlim([5 11])
ylim([0 1.1])
title('Discovery set : mrmr(3D features) - Only IS pruning','FontSize',30)
xlabel('Number of top features','FontSize',20)
ylabel('Area Under the Curve (AUC)','FontSize',20)
legend('QDA - Full dose','Randomforest - Full dose','Location','southeast','FontSize',20)

%%%%%%%%%%%%%%---------------------TESTING SET--------------------%%%%%%%%%
%------------------------wilcoxon feature selection----------------------%
figure;
p1 = plot(Top_fea,AUC_test_wilcoxon(1,1:5),'--or','MarkerSize',10,'MarkerEdgeColor','red','MarkerFaceColor','red','LineWidth',2)
hold on
p2 = plot(Top_fea,AUC_test_wilcoxon(2,1:5),'-ob','MarkerSize',10,'MarkerEdgeColor','blue','MarkerFaceColor','blue','LineWidth',2)
hold on
grid on
grid minor
xlim([5 11])
ylim([0 1.1])
title('Testing set : mrmr(3D features) - Only IS pruning','FontSize',30)
xlabel('Number of top features','FontSize',20)
ylabel('Area Under the Curve (AUC)','FontSize',20)
legend('QDA - Full dose','Randomforest - Full dose','Location','southeast','FontSize',20)

%--------------------------mrmr feature selection-------------------------%
figure;
p1 = plot(Top_fea,AUC_test_mrmr(1,1:5),'--or','MarkerSize',10,'MarkerEdgeColor','red','MarkerFaceColor','red','LineWidth',2)
hold on
p2 = plot(Top_fea,AUC_test_mrmr(2,1:5),'-ob','MarkerSize',10,'MarkerEdgeColor','blue','MarkerFaceColor','blue','LineWidth',2)
hold on
grid on
grid minor
xlim([5 11])
ylim([0 1.1])
title('Testing set : mrmr(3D features) - Only IS pruning','FontSize',30)
xlabel('Number of top features','FontSize',20)
ylabel('Area Under the Curve (AUC)','FontSize',20)
legend('QDA - Full dose','Randomforest - Full dose','Location','southeast','FontSize',20)
function SVM_2feat_Evaluation()

%1. Accuracies
load('MatrixData/brokenToothData.mat', 'brokenToothData');
load('MatrixData/healthyData.mat', 'healthyData');
testBins = [1,2,3,4,5,6,7,8,9,10,15,20,25,30, 40,60,120];
trainingSamples = 7;
mixed = false;
%accuracy results of the SVM
%second row crossvalidation acc
%third line off training set error
accuracies = zeros(2, length(testBins));

precision = zeros(1, length(testBins));
recall = zeros(1, length(testBins));
specificity = zeros(1, length(testBins));
confusionMatr = cell(1, length(testBins));

rng('default');
for i = 1:length(testBins)
    bins = testBins(i);    
    [trainingFeatures, trainingLabels, testFeatures, testLabels, SVMModel] = twoFeatureSVM(bins, trainingSamples,mixed);
    %do crossvalidation to estimate model accuracy
    cvdSVM = crossval(SVMModel, 'Holdout', 0.3);
    cvTrainError = kfoldLoss(cvdSVM);
    SVMaccuracy = 1 - cvTrainError;
    accuracies(1,i) = SVMaccuracy;
    offTrainingError = loss(SVMModel, testFeatures, testLabels);
    accuracies(2,i) = 1 - offTrainingError;
    [recall(1,i), precision(1,i), specificity(1,i), confusionMatr{i}] = ModelEvaluater(SVMModel, testFeatures, testLabels);
end

figure;
plot(testBins,recall(1,:),'b-o');
hold on;
%plot(xv,yv2, 'k-+');
plot(testBins,precision(1,:),'k-s')
hold on;
plot(testBins, specificity(1,:), 'm-v');
xlabel('Number of bins in time domain', 'Fontsize', 16);
xticks(testBins);
%set(gca, 'XTickLabel',testBins) 
ylabel('Measure', 'Fontsize', 16);
ylim([min(min(accuracies)) - 0.1,1.1]);
grid on;
lgd = legend('Recall', 'Precision', 'Specificity');
lgd.FontSize = 14;
title('SVM (2 features) 70% Training data, not mixed', 'Fontweight', 'bold', 'Fontsize', 18);
savefig('figures/SVM/twoFeatPrecRecNotMixed')

figure;
confusionchart(confusionMatr{15},["healthy","broken"]);
title('SVM (2features) Confusionmatrix 40 bins not mixed');
savefig('figures/SVM/confusionMatrs2bins');

figure;
%plot(xv,yv1, 'b-o');
plot(testBins,accuracies(1,:),'b-o');
hold on;
%plot(xv,yv2, 'k-+');
plot(testBins,accuracies(2,:),'k-+', 'Linewidth', 1.5)
xlabel('Number of bins in time domain', 'Fontsize', 16);
xticks(testBins);
%set(gca, 'XTickLabel',testBins) 
ylabel('Accuracy', 'Fontsize', 16);
ylim([min(min(accuracies)) - 0.1,1.1]);
grid on;
lgd = legend('10 fold, 30% Holdout CrossValidation accuracy', 'Test set accuracy');
lgd.FontSize = 14;
title('SVM (2 features) 70% Training data, not mixed', 'Fontweight', 'bold', 'Fontsize', 18);
savefig('figures/SVM/twoFeatNotMixedEval');

mixed = true;
accuracies = vertcat(testBins, zeros(2, length(testBins)));

precision = zeros(1, length(testBins));
recall = zeros(1, length(testBins));
specificity = zeros(1, length(testBins));
confusionMatr = cell(1, length(testBins));

rng('default');
for i = 1:length(testBins)
    bins = testBins(i);    
    [trainingFeatures, trainingLabels, testFeatures, testLabels, SVMModel] = twoFeatureSVM(bins, trainingSamples,mixed);
    %do crossvalidation to estimate model accuracy
    cvdSVM = crossval(SVMModel, 'Holdout', 0.3);
    cvTrainError = kfoldLoss(cvdSVM);
    SVMaccuracy = 1 - cvTrainError;
    accuracies(2,i) = SVMaccuracy;
    offTrainingError = loss(SVMModel, testFeatures, testLabels);
    accuracies(3,i) = 1 - offTrainingError;
    [recall(1,i), precision(1,i), specificity(1,i), confusionMatr{i}] = ModelEvaluater(SVMModel, testFeatures, testLabels);
end

figure;
plot(testBins,recall(1,:),'b-o');
hold on;
plot(testBins,precision(1,:),'k-s')
hold on;
plot(testBins, specificity(1,:), 'm-v');
xlabel('Number of bins in time domain', 'Fontsize', 16);
xticks(testBins);
%set(gca, 'XTickLabel',testBins) 
ylabel('Measure', 'Fontsize', 16);
ylim([min(min(accuracies)) - 0.1,1.1]);
grid on;
lgd = legend('Recall', 'Precision', 'Specificity');
lgd.FontSize = 14;
title('SVM (2 features) 70% Training data, mixed', 'Fontweight', 'bold', 'Fontsize', 18);
savefig('figures/SVM/twoFeatPrecRecNotNoTMixed')

figure;
confusionchart(confusionMatr{15},["healthy","broken"]);
title('SVM (2features) Confusionmatrix 40 bins mixed');
savefig('figures/SVM/confusionMatrs40bins');

figure;
plot(testBins,accuracies(2,:),'b-o');
hold on;
plot(testBins,accuracies(3,:),'k-+',  'Linewidth', 1.5)
xlabel('Number bins in time domain', 'Fontsize', 16);
xticks(testBins);
ylabel('Accuracy', 'Fontsize', 16);
ylim([min(min(accuracies)) - 0.1,1.1]);
grid on;
lgd = legend('10 fold, 30% Holdout CrossValidation accuracy', 'Test set accuracy');
lgd.FontSize = 14;
title('SVM (2 features) 70% Training data, mixed', 'Fontweight', 'bold', 'Fontsize', 18);
savefig('figures/SVM/twoFeatMixedEval');


%2. ROC-curve
trainingSamples = 10;
mixed = false;
testBins = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 15, 20, 25, 30, 40, 60, 120];
AUCValues = zeros(1, length(testBins));
colours = {'k-o', 'k-s', 'k-v', 'k*','m-o', 'm-s', 'm-v', 'm*', 'b-o', 'b-s', 'b-v', 'b*',  'g-o', 'g-s', 'g-v', 'g*', 'c-o', 'c-s', 'c-v', 'c*'} ;
rng('default');
figure;
for i = 1:length(testBins)
    bins = testBins(i);
    [trainingFeatures, trainingLabels, testFeatures, testLabels, SVMModel] = twoFeatureSVM(bins, trainingSamples,mixed);
    %compute the posterior probabilities
    SVMModel = fitPosterior(SVMModel);
    [~,score_svm] = resubPredict(SVMModel);
    [Xsvm,Ysvm,Tsvm,AUCsvm] = perfcurve(trainingLabels,score_svm(:,2),1);
    AUCValues(1,i) = AUCsvm;
    plot(Xsvm,Ysvm,colours{i},'Markersize', 11);
    hold on;
end
%plot(Xsvm,Ysvm, 'Markersize', 18);
xlabel('False positive rate','Fontsize', 16);
ylabel('True positive rate', 'Fontsize', 16);
lgd = legend('1','2','3', '4', '5', '6','7','8','9','10','15','25', '30','40','60','120');
lgd.FontSize = 12;
grid on
title('ROC Curve SVM (two features) for different bin Sizes', 'Fontweight', 'bold', 'Fontsize', 18);
savefig('figures/SVM/twoFeatROC');

figure;
plot(testBins, AUCValues, 'b-^');
xticks(testBins);
xlabel('Number of bins', 'Fontsize', 16);
ylabel('Area under Curve', 'Fontsize', 16);
ylim([min(AUCValues) - 0.05, 1.05]);
title('AUC SVM (2 features) for different bin Sizes', 'Fontweight', 'bold', 'Fontsize', 18);
grid on
end


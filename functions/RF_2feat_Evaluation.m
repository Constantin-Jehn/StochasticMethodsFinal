function RF_2feat_Evaluation()

%1. Accuracies
load('MatrixData/brokenToothData.mat', 'brokenToothData');
load('MatrixData/healthyData.mat', 'healthyData');
testBins = [1,2,3,4,5,6,7,8,9,10,15,20,25,30, 40,60,120];
trainingSamples = 7;
mixed = false;
%accuracy results of the RF
%second row crossvalidation acc
%third line off training set error
accuracy = zeros(1, length(testBins));
precision = zeros(1, length(testBins));
recall = zeros(1, length(testBins));
specificity = zeros(1, length(testBins));
confusionMatr = cell(1, length(testBins));
rng('default');
for i = 1:length(testBins)
    bins = testBins(i);    
    [trainingFeatures, trainingLabels, testFeatures, testLabels, RFModel] = randomForest(bins, trainingSamples,mixed);
    %do crossvalidation to estimate model accuracy
    
    [TestPred, TestPredScores] = predict(RFModel,testFeatures);
    predictions = str2double(TestPred)
    
    truePositive = sum( (testLabels == 1) & (predictions == 1));
    falseNegative = sum( (testLabels == 1) & (predictions ==0));

    trueNegative = sum ( (testLabels == 0) & (predictions ==0));
    falsePositive = sum ( (testLabels == 0) & (predictions == 1));
    
    recall(1,i) = truePositive / (truePositive + falseNegative);
    precision(1,i) = truePositive / (truePositive + falsePositive);
    accuracy(1,i) = (truePositive + trueNegative)/(truePositive + trueNegative + falsePositive + falseNegative);

    specificity(1,i) = trueNegative/(trueNegative + falsePositive);

    confusionMatr{i} = confusionmat(testLabels, predictions);
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
ylim([0.5,1.1]);
grid on;
legend('Recall', 'Precision', 'Specificity');
title('RF (2 features) 70% Training data, not mixed', 'Fontweight', 'bold', 'Fontsize', 18);
savefig('figures/RF/twoFeatPrecRecNotMixed')

figure;
confusionchart(confusionMatr{2},["healthy","broken"]);
title('RF (2features) Confusionmatrix 2 bins not mixed');
savefig('figures/RF/confusionMatrs2bins');

figure;
%plot(xv,yv1, 'b-o');
plot(testBins,accuracy(1,:),'b-o');
hold on;
%plot(xv,yv2, 'k-+');
xlabel('Number of bins in time domain', 'Fontsize', 16);
xticks(testBins);
%set(gca, 'XTickLabel',testBins) 
ylabel('Test Accuracy', 'Fontsize', 16);
ylim([0.75,1.1]);
grid on;
legend('10 fold, 30% Holdout CrossValidation error');
title('RF (2 features) 70% Training data, not mixed', 'Fontweight', 'bold', 'Fontsize', 18);
savefig('figures/RF/twoFeatNotMixedEval');

mixed = true;
accuracy = zeros(1, length(testBins));
precision = zeros(1, length(testBins));
recall = zeros(1, length(testBins));
specificity = zeros(1, length(testBins));
confusionMatr = cell(1, length(testBins));

rng('default');
for i = 1:length(testBins)
    bins = testBins(i);    
    [trainingFeatures, trainingLabels, testFeatures, testLabels, RFModel] = randomForest(bins, trainingSamples,mixed);
    %do crossvalidation to estimate model accuracy
    
    [TestPred, TestPredScores] = predict(RFModel,testFeatures);
    predictions = str2double(TestPred)
    
    truePositive = sum( (testLabels == 1) & (predictions == 1));
    falseNegative = sum( (testLabels == 1) & (predictions ==0));

    trueNegative = sum ( (testLabels == 0) & (predictions ==0));
    falsePositive = sum ( (testLabels == 0) & (predictions == 1));
    
    recall(1,i) = truePositive / (truePositive + falseNegative);
    precision(1,i) = truePositive / (truePositive + falsePositive);
    accuracy(1,i) = (truePositive + trueNegative)/(truePositive + trueNegative + falsePositive + falseNegative);

    specificity(1,i) = trueNegative/(trueNegative + falsePositive);

    confusionMatr{i} = confusionmat(testLabels, predictions);
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
ylim([0.5,1.1]);
grid on;
legend('Recall', 'Precision', 'Specificity');
title('RF (2 features) 70% Training data, mixed', 'Fontweight', 'bold', 'Fontsize', 18);
savefig('figures/RF/twoFeatPrecRecMixed')

figure;
confusionchart(confusionMatr{2},["healthy","broken"]);
title('RF (2features) Confusionmatrix 2 bins mixed');
savefig('figures/RF/confusionMatrs2binsMixed');

figure;
%plot(xv,yv1, 'b-o');
plot(testBins,accuracy(1,:),'b-o');
hold on;
%plot(xv,yv2, 'k-+');
xlabel('Number of bins in time domain', 'Fontsize', 16);
xticks(testBins);
%set(gca, 'XTickLabel',testBins) 
ylabel('Test Accuracy', 'Fontsize', 16);
ylim([0.75,1.1]);
grid on;
legend('10 fold, 30% Holdout CrossValidation error');
title('RF (2 features) 70% Training data, mixed', 'Fontweight', 'bold', 'Fontsize', 18);
savefig('figures/RF/twoFeatMixedEval');

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
    [trainingFeatures, trainingLabels, testFeatures, testLabels, RFModel] = randomForest(bins, trainingSamples,mixed);
    %compute the posterior probabilities
    [Yfit,score_RF] = predict(RFModel,trainingFeatures);
    [XRF,YRF,TRF,AUCRF] = perfcurve(trainingLabels,score_RF(:,2),1);
    AUCValues(1,i) = AUCRF;
    plot(XRF,YRF,colours{i},'Markersize', 11);
    hold on;
end
%plot(XRF,YRF, 'Markersize', 18);
xlabel('False positive rate','Fontsize', 16);
ylabel('True positive rate', 'Fontsize', 16);
legend('1','2','3', '4', '5', '6','7','8','9','10','15','25', '30','40','60','120');
grid on
title('ROC Curve RF (two features) for different bin Sizes', 'Fontweight', 'bold', 'Fontsize', 18);
savefig('figures/RF/twoFeatROC');

figure;
plot(testBins, AUCValues, 'b-^');
xticks(testBins);
xlabel('Number of bins', 'Fontsize', 16);
ylabel('Area under Curve', 'Fontsize', 16);
ylim([min(AUCValues) - 0.05, 1.05]);
title('AUC RF (2 features) for different bin Sizes', 'Fontweight', 'bold', 'Fontsize', 18);
grid on
end



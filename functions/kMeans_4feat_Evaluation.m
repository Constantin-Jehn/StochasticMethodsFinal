function kMeans_4feat_Evaluation()

%1. Accuracies
load('MatrixData/brokenToothData.mat', 'brokenToothData');
load('MatrixData/healthyData.mat', 'healthyData');
testBins = [1,2,3,4,5,6,7,8,9,10,15,20,25,30,40,60,120];
trainingSamples = 7;
mixed = false;
%accuracy results of the SVM
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
    [trainingFeatures, trainingLabels, testFeatures, testLabels,idx,C] = kMeans_4feat(bins,trainingSamples,mixed);

    [~,predictions] = pdist2(C,testFeatures,'euclidean','Smallest',1);
    predictions = (predictions - 1).';
    truePositive = sum( (testLabels == 1) & (predictions == 1));
    falseNegative = sum( (testLabels == 1) & (predictions ==0));

    trueNegative = sum ( (testLabels == 0) & (predictions ==0));
    falsePositive = sum ( (testLabels == 0) & (predictions == 1));
    accuracy(1,i) = (truePositive + trueNegative)/(truePositive + trueNegative + falsePositive + falseNegative);
    recall(1,i) = truePositive / (truePositive + falseNegative);
    precision(1,i) = truePositive / (truePositive + falsePositive);

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
%ylim([min(min(accuracies)) - 0.1,1.1]);
grid on;
legend('Recall', 'Precision', 'Specificity');
title('kMeans (4 features) 70% Training data, not mixed', 'Fontweight', 'bold', 'Fontsize', 18);
savefig('figures/kMeans/PrecRecNotMixed_4feat')

figure;
%plot(xv,yv1, 'b-o');
plot(testBins,accuracy(1,:),'b-o');
hold on;
%plot(xv,yv2, 'k-+');
xlabel('Number of bins in time domain', 'Fontsize', 16);
xticks(testBins);
%set(gca, 'XTickLabel',testBins) 
ylabel('Test Accuracy', 'Fontsize', 16);
grid on;
title('kMeans (4 features) 70% Training data, not mixed', 'Fontweight', 'bold', 'Fontsize', 18);
savefig('figures/kMeans/NotMixedEval_4feat');

figure;
confusionchart(confusionMatr{2},["healthy","broken"]);
title('kMeans (4 features) Confusionmatrix 2 bins not mixed');
savefig('figures/kMeans/confusionMatrs2bins_4feat');



mixed = true;
accuracy = zeros(1, length(testBins));
precision = zeros(1, length(testBins));
recall = zeros(1, length(testBins));
specificity = zeros(1, length(testBins));
confusionMatr = cell(1, length(testBins));

for i = 1:length(testBins)
    bins = testBins(i);    
    [trainingFeatures, trainingLabels, testFeatures, testLabels,idx,C] = kMeans_4feat(bins,trainingSamples,mixed);

    [~,predictions] = pdist2(C,testFeatures,'euclidean','Smallest',1);
    predictions = (predictions - 1).';
    truePositive = sum( (testLabels == 1) & (predictions == 1));
    falseNegative = sum( (testLabels == 1) & (predictions ==0));

    trueNegative = sum ( (testLabels == 0) & (predictions ==0));
    falsePositive = sum ( (testLabels == 0) & (predictions == 1));
    accuracy(1,i) = (truePositive + trueNegative)/(truePositive + trueNegative + falsePositive + falseNegative);
    recall(1,i) = truePositive / (truePositive + falseNegative);
    precision(1,i) = truePositive / (truePositive + falsePositive);

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
%ylim([min(min(accuracies)) - 0.1,1.1]);
grid on;
legend('Recall', 'Precision', 'Specificity');
title('kMeans (4 features) 70% Training data, mixed', 'Fontweight', 'bold', 'Fontsize', 18);
savefig('figures/kMeans/PrecRecMixed_4feat')

figure;
%plot(xv,yv1, 'b-o');
plot(testBins,accuracy(1,:),'b-o');
hold on;
%plot(xv,yv2, 'k-+');
xlabel('Number of bins in time domain', 'Fontsize', 16);
xticks(testBins);
%set(gca, 'XTickLabel',testBins) 
ylabel('Test Accuracy', 'Fontsize', 16);
ylim([min(min(accuracy)) - 0.1,1.1]);
grid on;
title('kMeans (4 features) 70% Training data, mixed', 'Fontweight', 'bold', 'Fontsize', 18);
savefig('figures/kMeans/MixedEval_4feat');

figure;
confusionchart(confusionMatr{2},["healthy","broken"]);
title('kMeans (4 features) Confusionmatrix 2 bins mixed');
savefig('figures/kMeans/confusionMatrs2binsMixed_4feat');



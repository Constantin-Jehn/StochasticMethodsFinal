function thresholdingEvaluation()

clear all;
clc;
%Evaluation of Thresholding, by applying identified rule to 3 picks of 60
%second time bins (other random seed than training)
% in training we have identified 0.246 as threshold

addpath('functions');
addpath('MatrixData');
addpath('figures');

load('MatrixData/brokenToothData.mat', 'brokenToothData');
load('MatrixData/healthyData.mat', 'healthyData');

entireData = true;
seconds = 60;
%random Seeds for testing
bins = round(3600/seconds);
%get all 60 bins to make avoid overlap between "train" and "test"
[healthyEntire, brokenEntire] = randomSplitter(healthyData, brokenToothData, bins, 1, false, entireData);
healthyMeansTr = zeros(1,10*20);
brokenMeansTr = zeros(1,10*20);
%random indices for training and test

%70/30 split: 20 for "training' 8 for testing
total = 28;
rng(1);
r = randperm(total);

%Generate "training data"
for i = 1: 20
    healthy = healthyEntire(:,r(i));
    broken = brokenEntire(:,r(i));
    features2s = fftFeaturesthresholding(healthy, broken);
    meanValues = features2s(:,1);
    for j =1:10
        healthyMeansTr(1,j+(i-1)*10) = meanValues{j}(1,3);
        brokenMeansTr(1,j+(i-1)*10) = meanValues{j}(2,3);
    end    
end
nbins = 30;
figure;
histogram(healthyMeansTr, nbins, 'FaceColor', [0, 0.5, 0], 'FaceAlpha',0.7);
hold on;
histogram(brokenMeansTr, nbins, 'FaceColor', 'r', 'FaceAlpha',0.7);
hold on;
line([0.244, 0.244], ylim, 'LineWidth', 2, 'Color', 'k');
%line([0.244, 0.244], ylim, 'LineWidth', 2, 'Color', 'k');
xlabel('Mean, Sensor 1, bin2', 'Fontsize', 16);
ylabel('Number of samples', 'Fontsize', 16);
legend('Healthy gearboxes','Broken gearboxes', 'Fontsize', 16 );
title('Thresholding training', 'Fontweight', 'bold', 'Fontsize', 18);
saveas(gca,'figures\thresholding/training.png');
%identify 0.244 as threshold

%Generate "test data"
healthyMeansTe = zeros(1,10*8);
brokenMeansTe = zeros(1,10*8);
for i = 1:8
    %take the remainning splits
    healthy = healthyEntire(:,r(20+i));
    broken = brokenEntire(:,r(20 + i));
    features2s = fftFeaturesthresholding(healthy, broken);
    meanValues = features2s(:,1);
    for j =1:10
        healthyMeansTe(1,j+(i-1)*10) = meanValues{j}(1,3);
        brokenMeansTe(1,j+(i-1)*10) = meanValues{j}(2,3);
    end    
end
nbins = 30;
figure;
histogram(healthyMeansTe, nbins, 'FaceColor', [0, 0.5, 0], 'FaceAlpha',0.7);
hold on;
histogram(brokenMeansTe, nbins, 'FaceColor', 'r', 'FaceAlpha',0.7);
hold on;
line([0.244, 0.244], ylim, 'LineWidth', 2, 'Color', 'k');
xlabel('Mean, Sensor 1, bin2', 'Fontsize', 16);
ylabel('Number of samples', 'Fontsize', 16);
legend('Healthy gearboxes','Broken gearboxes', 'Fontsize', 16);
title('Thresholding testing', 'Fontweight', 'bold', 'Fontsize', 18);
saveas(gca,'figures\thresholding/test.png');

%create matrix to evaluate: first row ground truth, second row
%predicition 0:healthy, 1: broken
evaluation = zeros(2,160);
evaluation(1,1:80) = 0;
evaluation(2,1:80) = healthyMeansTe < 0.244;
evaluation(1,81:160) = 1;
evaluation(2,81:160) = brokenMeansTe < 0.244;

%calc performance measures

truePositive = sum( (evaluation(1,:) == 1) & (evaluation(2,:) == 1));
falseNegative = sum( (evaluation(1,:) == 1) & (evaluation(2,:) == 0));
trueNegative = sum( (evaluation(1,:) == 0) & (evaluation(2,:) == 0));
falsePositive = sum( (evaluation(1,:) == 0) & (evaluation(2,:) == 1));

accuracy = sum(evaluation(1,:) == evaluation(2,:)) / 160;
recall = truePositive / (truePositive + falseNegative);
precision = truePositive / (truePositive + falsePositive);
specificity = trueNegative/(trueNegative + falsePositive);

figure;
X = categorical({'Accuracy','Recall','Precision', 'Specificity'});
X = reordercats(X,{'Accuracy','Recall','Precision', 'Specificity'});
Y = [accuracy, recall, precision, specificity];
b = bar(X,Y);
ylim([0.9 1.01]);
grid on;
for i1=1:numel(Y)
    text(X(i1),Y(i1),num2str(Y(i1),'%0.2f'),...
               'HorizontalAlignment','center',...
               'VerticalAlignment','bottom')
end
title('Thresholding Performance on test data', 'Fontweight', 'bold', 'Fontsize', 18);
saveas(gca,'figures\thresholding/evaluation.png');

end







    



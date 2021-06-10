function SVM_2feat_visualization(bins)
addpath('functions');

load('MatrixData/brokenToothData.mat', 'brokenToothData');
load('MatrixData/healthyData.mat', 'healthyData');

trainingSamples = 7;
minutes = int64(60/bins);
[trainingFeatures, trainingLabels, testFeatures, testLabels, SVMModel] = twoFeatureSVM(bins,trainingSamples,false);
testPredictions = predict(SVMModel, testFeatures);

% plot the result
d = 0.02; % Step size of the grid
[x1Grid,x2Grid] = meshgrid(min(trainingFeatures(:,1)):d:max(trainingFeatures(:,1)),...
    min(trainingFeatures(:,2)):d:max(trainingFeatures(:,2)));
xGrid = [x1Grid(:),x2Grid(:)];        % The grid
[~,scores1] = predict(SVMModel,xGrid); % The scores
%get support vectors
sv = SVMModel.SupportVectors;
figure
gscatter(trainingFeatures(:,1),trainingFeatures(:,2),trainingLabels , 'gr');
hold on
plot(sv(:,1),sv(:,2),'ko', 'MarkerSize', 10);
hold on
%decision boundary
contour(x1Grid,x2Grid,reshape(scores1(:,2),size(x1Grid)),[0 0],'k');
hold on 
gscatter(testFeatures(:,1), testFeatures(:,2), testLabels, 'gr', '+' , 20);
gscatter(testFeatures(:,1), testFeatures(:,2), testPredictions, 'gr', 'o', 20)
lgd = legend('Training:healthy','Trainining:broken','Support Vector', 'decision boundary', 'Test: heathy', 'Test: broken', 'Prediction: healthy', 'Prediction: broken')
lgd.FontSize = 12
title(strcat('SVM (2 features) ', int2str(bins),' bins'), 'Fontweight', 'bold', 'Fontsize', 16);
xlim([min(cat(1,trainingFeatures(:,1), testFeatures(:,1))) , max(cat(1,trainingFeatures(:,1), testFeatures(:,1)))]);
ylim([min(cat(1,trainingFeatures(:,2), testFeatures(:,2))) , max(cat(1,trainingFeatures(:,2), testFeatures(:,2)))]);
xlabel('Mean Sensor 1 bin 2 (normalized)', 'Fontsize', 16);
ylabel('Mean Sensor 2 bin 2 (normalized)', 'Fontsize', 16);
grid on;
hold off
savefig('figures/SVM/twoFeat40bins');

%do crossvalidation to estimate model accuracy
cvdSVM = crossval(SVMModel, 'Holdout', 0.3);
cvTrainError = kfoldLoss(cvdSVM);
SVMaccuracy = 1 - cvTrainError;
disp('Cross Validation accuracy: ');
disp(SVMaccuracy);

offTrainingError = loss(SVMModel, testFeatures, testLabels);
disp('Off Training Accuracy: ');
disp(1 - offTrainingError);
end
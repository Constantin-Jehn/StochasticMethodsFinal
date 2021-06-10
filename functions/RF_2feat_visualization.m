function RF_2feat_visualization(bins)
addpath('functions');

load('MatrixData/brokenToothData.mat', 'brokenToothData');
load('MatrixData/healthyData.mat', 'healthyData');

trainingSamples = 7;
[trainingFeatures, trainingLabels, testFeatures, testLabels, RFModel] = randomForest(bins,trainingSamples,false);
testPredictions = str2double(predict(RFModel, testFeatures));
gscatter(trainingFeatures(:,1),trainingFeatures(:,2),trainingLabels , 'gr');
hold on

gscatter(testFeatures(:,1),testFeatures(:,2),testPredictions,'bgm','ooo')
xlabel("Mean sensor 1, bin 2");
ylabel("Mean sensor 2, bin 2");
legend('Healthy gearbox','Broken gearbox','Test data classified as healthy','Test data classified as broken', 'Location','southeast')

view(RFModel.Trees{2},'Mode','graph')





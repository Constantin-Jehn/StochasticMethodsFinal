function [trainingFeatures, trainingLabels, testFeatures, testLabels,idx,C] = kMeans_4feat(bins,trainingSamples,mixed)



load('MatrixData/brokenToothData.mat', 'brokenToothData');
load('MatrixData/healthyData.mat', 'healthyData');

testSamples = 10 - trainingSamples;


%splitting into time bins
[heRandSplit, broRandSplit] = randomSplitter(healthyData, brokenToothData, bins, 10, false,false);
%splitting test and training set
[heTrainingData,heTestData, broTrainingData, broTestData] = basicSplitting(heRandSplit, broRandSplit, trainingSamples,testSamples);

%2.Extract features, second try: Mean (Sensor 1 bin 2, Sensor 2 bin2),
%Kurtosis(Sensor1 bin 1, Sensor 1 bin1)

trainingFeatures = zeros(trainingSamples*2,4);
%initialize with -1 to get error if it was not properly written later
trainingLabels = (-1)*ones(trainingSamples*2,1);
testFeatures = zeros(testSamples*2,4);
testLabels = (-1)*ones(testSamples*2,1);

%construct X,Y for training SVM
for i=1:trainingSamples
    featHel = basicFFTfeatures(heTrainingData{i});
    %Sensor 1: 2. freq band
    trainingFeatures(2*i-1,1) = featHel{1}(2);
    trainingFeatures(2*i-1,2) = featHel{1}(5);
    %Kurtosis
    trainingFeatures(2*i-1,3) = featHel{4}(1);
    trainingFeatures(2*i-1,4) = featHel{4}(2);
    % Label 0 --> Healthy
    trainingLabels(2*i-1) = 0;
    
    featBro = basicFFTfeatures(broTrainingData{i});
    trainingFeatures(2*i,1) = featBro{1}(2);
    trainingFeatures(2*i,2) = featBro{1}(5);
    %Kurtosis
    trainingFeatures(2*i,3) = featBro{4}(1);
    trainingFeatures(2*i,4) = featBro{4}(2);
    %Label 1 --> Broken
    trainingLabels(2*i) = 1;
end

%construct X,Y for testing SVM
for i = 1:testSamples
    featHel = basicFFTfeatures(heTestData{i});
    %Sensor 1: 2. freq band
    testFeatures(2*i-1,1) = featHel{1}(2);
    testFeatures(2*i-1,2) = featHel{1}(5);
    %Kurtosis
    testFeatures(2*i-1,3) = featHel{4}(1);
    testFeatures(2*i-1,4) = featHel{4}(2);
    % Label 0 --> Healthy
    testLabels(2*i-1) = 0;
    
    featBro = basicFFTfeatures(broTestData{i});
    testFeatures(2*i,1) = featBro{1}(2);
    testFeatures(2*i,2) = featBro{1}(5);
    %Kurtosis
    testFeatures(2*i,3) = featBro{4}(1);
    testFeatures(2*i,4) = featBro{4}(2);
    %Label 1 --> Broken
    testLabels(2*i) = 1;
end

%3.fit the model and predict labels
trainingFeatures = normalize(trainingFeatures);
testFeatures = normalize(testFeatures);
opts = statset('Display','final');
[idx,C] = kmeans(trainingFeatures,2,...
    'Replicates',5,'Options',opts);



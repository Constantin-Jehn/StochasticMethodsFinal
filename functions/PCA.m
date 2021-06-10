function PCA()

load('MatrixData/brokenToothData.mat', 'brokenToothData');
load('MatrixData/healthyData.mat', 'healthyData');
mixed = false;
bins = 2;
trainingSamples = 7;
testSamples = 10 - trainingSamples;
%1. dataSplitting
%splitting into time bins with different random seeds
[heRandSplit, broRandSplit] = randomSplitter(healthyData, brokenToothData, bins, 1, mixed, true);
%splitting test and training set
heTrainingData = cell(trainingSamples,bins);
broTrainingData = cell(trainingSamples,bins);
broTestData = cell(testSamples,bins);
heTestData = cell(testSamples,bins);

for i=1:bins
    [heTrainingData(:,i) ,heTestData(:,i), broTrainingData(:,i), broTestData(:,i)] = basicSplitting(heRandSplit(:,i), broRandSplit(:,i), trainingSamples, testSamples);
end

%2.Extract features
trainingFeatures = zeros(trainingSamples*2*bins,20);
%initialize with -1 to get error if it was not properly written later
trainingLabels = (-1)*ones(trainingSamples*2*bins,1);
testFeatures = zeros(testSamples*2*bins,20);
testLabels = (-1)*ones(testSamples*2*bins,1);

%construct X,Y for PCA --> do PCA only on training data
for i=1:trainingSamples
    for j=1:bins
        featHel = basicFFTfeatures(heTrainingData{i,j});
        %Sensor 1: 2. freq band
        trainingFeatures(2*i*j-1,1:5) = featHel{1};
        trainingFeatures(2*i*j-1,6:10) = featHel{2};
        trainingFeatures(2*i*j-1,11:15) = featHel{3};
        trainingFeatures(2*i*j-1,16:20) = featHel{4};
        % Label 0 --> Healthy
        trainingLabels(2*i*j-1) = 0;

        featBro = basicFFTfeatures(broTrainingData{i,j});
        trainingFeatures(2*i*j,1:5) = featBro{1};
        trainingFeatures(2*i*j,6:10) = featBro{2};
        trainingFeatures(2*i*j,11:15) = featBro{3};
        trainingFeatures(2*i*j,16:20) = featBro{4};
        %Label 1 --> Broken
        trainingLabels(2*i*j) = 1;
    end
end


trainingFeatures = trainingFeatures - mean(trainingFeatures);
[coeff, score, latent, ~, explained] = pca(trainingFeatures);
bar(explained);
%the first principle component
PCA1mean = coeff(1:5,1);
PCA1RMS = coeff(6:10,1);
PCA1Std = coeff(11:15,1);
PCA1Kurt = coeff(16:20,1);
semilogy(PCA1mean, 'b-*');
hold on;
semilogy(PCA1RMS, 'k-o', 'Markersize', 10);
hold on;
semilogy(PCA1Std, 'm-v', 'Markersize', 10);
hold on;
semilogy(PCA1Kurt, 'r-^', 'Markersize', 10);
hold on;
xlabel('bin Number', 'Fontsize', 16)
ylabel('Weight in Principle component', 'Fontsize', 16);
lgd = legend('Mean','RMS','Std','Kurtosis');
lgd.FontSize = 14;
title('PCA 1', 'Fontweight', 'bold', 'Fontsize', 18);
savefig('figures/PCA');
%-> Kurtosis of Sensor 1 bin 1 and 2 are interesting

end


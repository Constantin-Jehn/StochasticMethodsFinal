function thresholdingAnalysis()

clear all;
clc;
%Training step of Thresholding by visual inspection

addpath('functions');
addpath('MatrixData');

load('MatrixData/brokenToothData.mat', 'brokenToothData');
load('MatrixData/healthyData.mat', 'healthyData');

%create 3 batches 2s, 5s, 8s,
%Analyse amount necessary time
seconds = [2 3 5 7 10];
loading = 5;
randomSeed = 10;
%frequency analysis
%EDA for very short time frames
% for i=1:length(seconds)
%     bins = round( 3600/seconds(i) );
%     [healthy, broken] = randomSplitter(healthyData, brokenToothData, bins, randomSeed, false, false);
%     load10He = healthy{loading};
%     load10Bro = broken{loading};
%     figFFT = thresholdFFT(load10He, load10Bro, seconds(i));
%     features2s = fftFeaturesthresholding(healthy, broken);
%     meanValues = features2s(:,1);
%     healthyMeans = zeros(2,10);
%     brokenMeans = zeros(2,10);
% 
% %extract the so far most interesting means
%     for j =1:10
%         healthyMeans(1,j) = meanValues{j}(1,3);
%         healthyMeans(2,j) = meanValues{j}(1,5);
%         brokenMeans(1,j) = meanValues{j}(2,3);
%         brokenMeans(2,j) = meanValues{j}(2,5);
%     end
%     mSize = 50;
%     figure;
%     scatter(brokenMeans(1,:),brokenMeans(2,:),mSize,'r');
%     hold on;
%     scatter(healthyMeans(1,:),healthyMeans(2,:),mSize,[0, 0.5, 0]);
%     hold on;
%     xlabel('Mean, Sensor 1, bin2');
%     ylabel('Mean, Sensor 2, bin2');
%     legend('Broken Tooth','Healthy Gearbox', 'Location', 'northwest');
%     grid on
%     title(strcat(int2str(seconds(i)), ' Seconds'));
%     
% end
%3 or 10 seconds seem very reasonable
%Further analysis over some random Seeds to se variance
seconds = [ 15 20 30 60];
randomSeeds = 1:20;
for i=1:length(seconds)
    bins = round( 3600/seconds(i) );
    mSize = 50;
    figure;
    for k=1:length(randomSeeds)
        %picks random bins of the given data
        [healthy, broken] = randomSplitter(healthyData, brokenToothData, bins, randomSeeds(k), false, false);
        features2s = fftFeaturesthresholding(healthy, broken);
        meanValues = features2s(:,1);
        healthyMeans = zeros(2,10);
        brokenMeans = zeros(2,10);

    %extract the so far most interesting means
        for j =1:10
            healthyMeans(1,j) = meanValues{j}(1,3);
            healthyMeans(2,j) = meanValues{j}(1,5);
            brokenMeans(1,j) = meanValues{j}(2,3);
            brokenMeans(2,j) = meanValues{j}(2,5);
        end
        
        scatter(brokenMeans(1,:),brokenMeans(2,:),mSize,'r');
        hold on;
        scatter(healthyMeans(1,:),healthyMeans(2,:),mSize,[0, 0.5, 0]);
        hold on;
        xlabel('Mean, Sensor 1, bin2');
        ylabel('Mean, Sensor 2, bin2');
        legend('Broken Tooth','Healthy Gearbox', 'Location', 'northwest');
        grid on
        title(strcat(int2str(seconds(i)), ' Seconds'));
        saveas(gca,strcat('figures/thresholding/',int2str(seconds(i)),'.png'));
    end
    %by visual inspection --> taking 60 seconds time frame, threshold 0.246
    %in axis Mean, Sensor 1, bin2
    
end




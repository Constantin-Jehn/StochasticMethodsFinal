function visualizeData()
clear all;
clc;
addpath('functions');
addpath('MatrixData');
% load('MatrixData/brokenToothData.mat', 'brokenToothData');
% load('MatrixData/healthyData.mat', 'healthyData');


load('MatrixData/features.mat', 'features');
healthyX = zeros(1,10);
healthyY = zeros(1,10);
brokenX = zeros(1,10);
brokenY = zeros(1,10);

mSize = 50;

for i=1:10
   healthyX(1,i) = features{i,1}(1,2);
   healthyY(1,i) = features{i,1}(1,5);
   brokenX(1,i) = features{i,1}(2,2);
   brokenY(1,i) = features{i,1}(2,5);
end

figure;
scatter(brokenX,brokenY,mSize,'r');
hold on;
scatter(healthyX,healthyY,mSize,[0, 0.5, 0]);
hold on;
xlabel('Mean, Sensor 1, bin2');
ylabel('Mean, Sensor 2, bin2');
legend('Broken Tooth','Healthy Gearbox', 'Location', 'northwest');
grid on
title('Entire data')

figure;

for i=1:10
    bins = 10;
    features = randomizedFFTFeatures(bins);
    healthyX = zeros(1,10);
    healthyY = zeros(1,10);
    brokenX = zeros(1,10);
    brokenY = zeros(1,10);

    for j=1:10
       healthyX(1,j) = features{j,1}(1,2);
       healthyY(1,j) = features{j,1}(1,5);
       
       brokenX(1,j) = features{j,1}(2,2);
       brokenY(1,j) = features{j,1}(2,5);
    end
    scatter(brokenX,brokenY,mSize,'r' );
    hold on;
    scatter(healthyX,healthyY,mSize,[0, 0.5, 0]);
    hold on;
end

xlabel('Mean, Sensor 1, bin2');
ylabel('Mean, Sensor 2, bin2');
legend('Broken Tooth','Healthy Gearbox', 'Location', 'northwest');
grid on
title(strcat('Randomized data over ', int2str(bins),' bins in time domain'));

%3d plot
figure;
for i=1:10
    bins = 1;
    features = randomizedFFTFeatures(bins);
    healthyX = zeros(1,10);
    healthyY = zeros(1,10);
    healthyZ = zeros(1,10);
    brokenX = zeros(1,10);
    brokenY = zeros(1,10);
    brokenZ = zeros(1,10);
    for j=1:10
       healthyX(1,j) = features{j,1}(1,2);
       healthyY(1,j) = features{j,1}(1,5);
       healthyZ(1,j) = features{j,3}(1,2);
       brokenX(1,j) = features{j,1}(2,2);
       brokenY(1,j) = features{j,1}(2,5);
       brokenZ(1,j) = features{j,3}(2,2);
    end
    scatter3(brokenX,brokenY,brokenZ,mSize,'r' );
    hold on;
    scatter3(healthyX,healthyY,healthyZ,mSize,[0, 0.5, 0]);
    hold on;
end

xlabel('Mean, Sensor 1, bin2');
ylabel('Mean, Sensor 2, bin2');
zlabel('Std, Sensor 1, bin 2');
legend('Broken Tooth','Healthy Gearbox', 'Location', 'northwest');
grid on
title(strcat('Randomized data over ', int2str(bins),' bins in time domain'));
%to see if features make sense compare to fft
validateFFTMean(8);
end


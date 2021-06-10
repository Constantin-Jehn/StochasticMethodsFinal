function readInData()
clear all;
clc;

addpath('RawData/BrokenTooth Data');
myDir = 'RawData/BrokenTooth Data';

%read Data of broke Teeth
brokenFiles = dir(fullfile(myDir));
brokenToothData = cell(10,1);
%skip fist to "files" as they are empty
for k = 3:length(brokenFiles)
    brokenToothData{k-2} = table2array(readtable(brokenFiles(k).name));
end

%repeat for Healthy Data
addpath('RawData/Healthy Data');
myDir = 'RawData/Healthy Data';

healthyFiles = dir(fullfile(myDir));
healthyData = cell(10,1);
for k = 3:length(healthyFiles)
    healthyData{k-2} = table2array(readtable(healthyFiles(k).name));
end

%save Data as Matrix
save('MatrixData/brokenToothData.mat', 'brokenToothData');
save('MatrixData/healthyData.mat', 'healthyData');
end


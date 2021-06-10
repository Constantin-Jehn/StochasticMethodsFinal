function spectrogramFig = sensorSpectrogram(loading, sensor)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes hereload('MatrixData/brokenToothData.mat', 'brokenToothData');
load('MatrixData/brokenToothData.mat', 'brokenToothData');
load('MatrixData/healthyData.mat', 'healthyData');

vibrHe = healthyData{loading}(:,sensor);
vibrBro = brokenToothData{loading}(:,sensor);

specHe = spectrogram(vibrHe);
specBro = spectrogram(vibrBro);
fs = 30;
spectrogramFig = figure
subplot(1,2,1)
spectrogram(vibrHe, 128, 64, 128 ,fs,  'yaxis')
colormap bone
title('Healthy Gearboxes')
subplot(1,2,2)
spectrogram(vibrBro, 128, 64, 128,fs, 'yaxis')
colormap bone
title('Broken Tooth')
savefig(strcat('figures/spectrogram/Loading', int2str(loading),'Sensor',int2str(sensor)));
end


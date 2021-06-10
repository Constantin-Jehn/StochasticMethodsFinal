function validateFFTMean(loading)
%validate FFT mean calculation
load('MatrixData/features.mat','features');


sensorsFFT(loading);
%verify mean values
fftBro = features{loading,1}(2,:);
fftHe = features{loading,1}(1,:);


figure;
subplot(2,1,1)
plot(fftHe(1:3),'g')
hold on
plot(fftBro(1:3),'r')
legend('Healthy Gearbox', 'Broken Tooth');
xlabel('bin');
ylabel('mean of absolute value');
title('Sensor 1');
subplot(2,1,2)
plot(fftHe(4:5),'g')
hold on
plot(fftBro(4:5),'r')
legend('Healthy Gearbox', 'Broken Tooth');
xlabel('bin');
ylabel('mean of absolute value');
title('Sensor 2');
sgtitle(strcat('Loading', int2str((loading-1)*10),'%'));



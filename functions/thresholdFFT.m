function figFFT = thresholdFFT(healthyData, brokenData, seconds)
%plots FFTs for all Sensors of a specified loading
%the loading data is taken as input 


%load --> loading 10 - 90, He --> Healthy
load10He = healthyData;
load10Bro = brokenData;

% load10He = load10He(1:18000);
% load10Bro = load10Bro(1:18000);

%set up parameters for FFT
Fs = 30;
T = 1/Fs;
figFFT = figure;
for k=1:4
    %create subplot and select sensor k
    subplot(2,2,k);
    vibrHe = load10He(:,k);
    vibrBro = load10Bro(:,k);
    %bring data to sam length (shorter)
    
    L = min(length(vibrHe), length(vibrBro));
    %L = 18000;
    vibrHe = vibrHe(1:L);
    vibrBro = vibrBro(1:L);
    
    t = (0:L-1)*T;
    %compute FFT
    fftHe = fft(vibrHe);
    fftBro = fft(vibrBro);
    %P2 for two-sided P1 for one-sided FFT (symmetry & Nyqist theorem!)
    %healthy data
    P2He = abs(fftHe/L);
    P1He = P2He(1:L/2+1);
    P1He(2:end-1) = 2*P1He(2:end-1);
    %broken data
    P2Bro = abs(fftBro/L);
    P1Bro = P2Bro(1:L/2+1);
    P1Bro(2:end-1) = 2*P1Bro(2:end-1);
    %define frequency domain
    f = Fs*(0:(L/2))/L;
    plot(f,P1He, 'g', 'Displayname', 'Healthy Gerbox');
%     h = area(f,P1He, 'FaceColor', 'g', 'EdgeColor', 'none', 'Displayname', 'Healthy Gerbox');
%     h.FaceAlpha = 1;
    hold on;
    a = plot(f, P1Bro, 'r', 'Displayname', 'Broken Tooth');
    a.LineWidth = 0.0001;
    a.LineStyle = ':';

%     a = area(f,P1Bro, 'FaceColor','r', 'EdgeColor', 'none','Displayname', 'Broken Tooth' );
%     a.FaceAlpha = 0.75;
    xlabel('f(Hz)');
    ylabel('|P1(f)|');
    title(strcat('Sensor ', int2str(k)), 'FontSize', 16);
end
Lgnd = legend('show', 'FontSize', 14);
% Lgnd.Position(1) = 0.01;
% Lgnd.Position(2) = 0.43;
sgtitle(strcat(int2str(seconds), ' seconds of Data'), 'FontSize', 18, 'fontweight', 'bold');
%savefig(strcat('figures/fft/Loading', int2str(loading)));
end


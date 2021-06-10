function [features] =  fftFeaturesthresholding(healthyData, brokenToothData)
%Calculates fftFeatures for a data input
%load data
% load('MatrixData/brokenToothData.mat', 'brokenToothData');
% load('MatrixData/healthyData.mat', 'healthyData');
%do Fast Fourier Transform

%number of bins the frequency band is split (for easy cutting)
freqBins = 15;
sensors = 2;
maxBins = 3;

brokenMeanFFT = cell(10,1);
brokenRMSFFT = cell(10,1);
brokenKurtFFT = cell(10,1);
brokenStdFFT = cell(10,1);

healthyMeanFFT = cell(10,1);
healthyRMSFFT = cell(10,1);
healthyKurtFFT = cell(10,1);
healtyStdFFT = cell(10,1);

%datastructure {10-> loading 4 --> features}
features = cell(10,4);

%set up parameters for FFT
Fs = 30;
T = 1/Fs;
%loadings
for k=1:10
    %extract data of load k:
    loadHe = healthyData{k};
    loadBro = brokenToothData{k};
   
    %datamatrix
    
    %initialize matrices for current load
    Means = zeros(2,5);
    RMS = zeros(2,5);
    Kurt = zeros(2,5);
    Std = zeros(2,5);
    
 
    %Sensors --> use only the first two
    for i=1:2
        %extract data of current sensor
        vibrHe = loadHe(:,i);
        vibrBro = loadBro(:,i);
        
        %bring data to same length (shorter)
        L = min(length(vibrHe), length(vibrBro));
        vibrHe = vibrHe(1:L);
        vibrBro = vibrBro(1:L);
        t = (0:L-1)*T;
        
        %compute FFT
        fftHe = fft(vibrHe);
        fftBro = fft(vibrBro);
        %P2 for two-sided P1 for one-sided FFT (symmetry & Nyqist theorem!)
        %healthy data
        P2He = abs(fftHe/L);
        P1He = P2He(int64(1:L/2+1));
        P1He(2:end-1) = 2*P1He(2:end-1);
        %broken data
        P2Bro = abs(fftBro/L);
        P1Bro = P2Bro(int64(1:L/2+1));
        P1Bro(2:end-1) = 2*P1Bro(2:end-1);
        %split into frequency bins:
        L = length(P1He);
        r = rem(L,freqBins);
        %one bin corresponds to 1 Hz
        binSize =  (L + (freqBins -r))/freqBins;
        %binSize = int64(binSize);
        %compute features in the bins:       
        
        switch i
            case 1
                %Sensor 1 [0,5],[5,9],[9,15]
                binsHe = {P1He(1:int64(5*binSize)), P1He(int64(5*binSize):int64(9*binSize)), P1He(int64(9*binSize):end)};
                binsBro = {P1Bro(1: int64(5*binSize) ), P1Bro(int64(5*binSize) : int64(9*binSize) ), P1Bro(int64(9*binSize) :end)};
                for j =1:3
                    %Healthy data --> first index 1
                    %bin = P1He(j*binSize - (binSize -1):j*binSize);
                    bin = binsHe{j};
                    Means(1,j) = mean(bin);
                    RMS(1,j) = sqrt(sum(abs(bin.^2))/binSize);
                    Kurt(1,j) = kurtosis(bin);
                    Std(1,j) = std(bin);
                    %broken data --> first index 2
                    bin = binsBro{j};
                    Means(2,j) = mean(bin);
                    RMS(2,j) = sqrt(sum(abs(bin.^2))/binSize);
                    Kurt(2,j) = kurtosis(bin);
                    Std(2,j) = std(bin);
                end
                
            case 2
            %Sensor 2 [0,9],[9,15]
                binsHe = {P1He(1:9*binSize), P1He(9*binSize:end)};
                binsBro = {P1Bro(1:9*binSize), P1Bro(9*binSize:end)};
                for j =1:2
                    %Healthy data --> first indes 1
                    %bin = P1He(j*binSize - (binSize -1):j*binSize);
                    bin = binsHe{j};
                    Means(1,3 + j) = mean(bin);
                    RMS(1,3 + j) = sqrt(sum(abs(bin.^2))/binSize);
                    Kurt(1,3 + j) = kurtosis(bin);
                    Std(1,3 + j) = std(bin);
                    %broken data
                    bin = binsBro{j};
                    Means(i,3+ j) = mean(bin);
                    RMS(i,3 + j) = sqrt(sum(abs(bin.^2))/binSize);
                    Kurt(i,3 + j) = kurtosis(bin);
                    Std(i,3 + j) = std(bin);
                end                
        end
    end
    %save all sensors in the cell
    
 features{k,1} = Means;
 features{k,2} = RMS;
 features{k,3} = Std;
 features{k,4} = Kurt;
 
end
%save('MatrixData/features.mat','features');
end



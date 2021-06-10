function [features] = basicFFTfeatures(vibrationData)
%return the features of on single load time series

%number of bins the frequency band is split
freqBins = 15;
%datastructure {10-> loading 4 --> features}
features = cell(1,4);
%set up parameters for FFT
Fs = 30;
load = vibrationData;
%datamatrix
%initialize matrices for different features
Means = zeros(1,5);
RMS = zeros(1,5);
Kurt = zeros(1,5);
Std = zeros(1,5);

%Sensors --> use only the first two
for i=1:2
    %extract data of current sensor
    vibr = load(:,i);

    %bring data to same length (shorter)
    L = length(vibr);

    %compute FFT
    fftHe = fft(vibr);
    %P2 for two-sided P1 for one-sided FFT (symmetry & Nyqist theorem!)
    %divide by L for normalization
    P2 = abs(fftHe/L);
    P1 = P2(1:int64(L/2+1));
    P1(2:end-1) = 2*P1(2:end-1);
    %split into frequency bins:
    L = length(P1);
    r = rem(L,freqBins);
    %one bin corresponds to 1 Hz
    binSize =  (L + (freqBins -r))/freqBins;
    %binSize = int64(binSize);
    %compute features in the bins:       

    switch i
        case 1
            %Sensor 1 [0,5],[5,9],[9,15]
            bins = {P1(1:int64(5*binSize)), P1(int64(5*binSize):int64(9*binSize)), P1(int64(9*binSize):end)};
            for j =1:3
                %bin = P1He(j*binSize - (binSize -1):j*binSize);
                bin = bins{j};
                Means(1,j) = mean(bin);
                RMS(1,j) = sqrt(sum(abs(bin.^2))/binSize);
                Kurt(1,j) = kurtosis(bin);
                Std(1,j) = std(bin);
            end

        case 2
        %Sensor 2 [0,9],[9,15]
            bins = {P1(1:9*binSize), P1(9*binSize:end)};
            for j =1:2
                %bin = P1He(j*binSize - (binSize -1):j*binSize);
                bin = bins{j};
                Means(1,3 + j) = mean(bin);
                RMS(1,3 + j) = sqrt(sum(abs(bin.^2))/binSize);
                Kurt(1,3 + j) = kurtosis(bin);
                Std(1,3 + j) = std(bin);
            end                
    end
end
%save all sensors in the cell
    
 features{1,1} = Means;
 features{1,2} = RMS;
 features{1,3} = Std;
 features{1,4} = Kurt;
end


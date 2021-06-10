function [healthyRandomSplit, brokenRandomSplit] = randomSplitter(healthyData, brokenToothData, bins, seed, mixed, entireData)
%splits vibrations data into bins, and returns random parts of the time
% mix indicates wheter all data should be taken from same random bin 
% mix = false --> all from same bin
% mix = true --> each bin for each loading and Sensor is random
%entire data: return the whole split data
%data
switch entireData
    case false
        rng(seed);
        if ~ mixed
            index = randi(bins);
        end
        %initialize output cell
        healthyRandomSplit = cell(10,1);
        brokenRandomSplit = cell(10,1);
        %loadings
        for k=1:10
            %get current loading
            loadHe = healthyData{k};
            loadBro = brokenToothData{k};
            %calculate necessary length of array
            vibrHe = loadHe(:,1);
            vibrBro = loadBro(:,1);
            vibrHe = reshape( vibrHe(1 : end - rem(length(vibrHe),bins)),bins,[]);
            vibrBro = reshape(vibrBro(1:end - rem(length(vibrBro),bins)), bins , []);
            lHe = size(vibrHe,2);
            lBro = size(vibrBro,2);
            %initialize matrix
            dataHe = zeros(4,lHe);
            dataBro = zeros(4,lBro);

            %Sensors
            for j=1:4
                vibrHe = loadHe(:,j);
                vibrBro = loadBro(:,j);
                vibrHe = reshape( vibrHe(1 : end - rem(length(vibrHe),bins)),bins,[]);
                vibrBro = reshape(vibrBro(1:end - rem(length(vibrBro),bins)), bins , []);
                switch mixed
                    case false
                        vibrHe = vibrHe(index,:);
                        vibrBro = vibrBro(index,:);
                    case true
                        index = randi(bins);
                        vibrHe = vibrHe(index,:);
                        vibrBro = vibrBro(index,:);
                end


                dataHe(j,:) = vibrHe;
                dataBro(j,:) = vibrBro;
            end
            healthyRandomSplit{k} = transpose(dataHe);
            brokenRandomSplit{k} = transpose(dataBro);
        end
    case true
        %initialize output cell
        healthyRandomSplit = cell(10,bins);
        brokenRandomSplit = cell(10,bins);
        %loadings
        for k=1:10
            %get current loading
            loadHe = healthyData{k};
            loadBro = brokenToothData{k};
            %calculate necessary length of array
            vibrHe = loadHe(:,1);
            vibrBro = loadBro(:,1);
            vibrHe = reshape( vibrHe(1 : end - rem(length(vibrHe),bins)),bins,[]);
            vibrBro = reshape(vibrBro(1:end - rem(length(vibrBro),bins)), bins , []);
            lHe = size(vibrHe,2);
            lBro = size(vibrBro,2);
            %initialize matrix

            %iterate over bins
            for index = 1:bins
                dataHe = zeros(4,lHe);
                dataBro = zeros(4,lBro);
                %Sensors
                for j=1:4
                    vibrHe = loadHe(:,j);
                    vibrBro = loadBro(:,j);
                    vibrHe = reshape( vibrHe(1 : end - rem(length(vibrHe),bins)),bins,[]);
                    vibrBro = reshape(vibrBro(1:end - rem(length(vibrBro),bins)), bins , []);
                    switch mixed
                        case false
                            vibrHe = vibrHe(index,:);
                            vibrBro = vibrBro(index,:);
                        case true
                            index = randi(bins);
                            vibrHe = vibrHe(index,:);
                            vibrBro = vibrBro(index,:);
                    end


                    dataHe(j,:) = vibrHe;
                    dataBro(j,:) = vibrBro;
                end
                healthyRandomSplit{k,index} = transpose(dataHe);
                brokenRandomSplit{k,index} = transpose(dataBro);
            end
        end
        
end

end


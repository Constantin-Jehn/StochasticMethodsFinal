function [heTrData, heTeData, brTrData, brTeData] = basicSplitting(healthyData, brokenToothData, trainingSamples, testSamples)

trS = trainingSamples;
teS = testSamples;
total = trS + teS;

%1. split data into test and Training
%1.a Healthy data
%for reproducibility

rng(1);
r = randperm(total);
%Training indices
heTrInd = r(1:trS);
heTeInd = r(trS+1:end);
heTrData = cell(trS,1);
heTeData = cell(total-trS,1);
c = 1;

%Assign the data in the random indices to the Test/Training data
for i = heTrInd
    heTrData{c} = healthyData{i};
    c=c+1;
end
c=1;
for i = heTeInd
    heTeData{c} = healthyData{i};
    c = c+1;
end

%1.b Broken Tooth Data
%for reproducibility
rng(2);
r = randperm(10);
%Training indices
brTrInd = r(1:trS);
brTeInd = r(trS+1:end);
brTrData = cell(trS,1);
brTeData = cell(total-trS,1);
c = 1;
for i = brTrInd
    brTrData{c} = brokenToothData{i};
    c=c+1;
end
c=1;
for i = brTeInd
    brTeData{c} = brokenToothData{i};
    c = c+1;
end

end


function kMeans_2feat_visualization(bins);
addpath('functions');

trainingSamples = 7;
mixed = false;
[trainingFeatures, trainingLabels, testFeatures, testLabels,idx,C] = kMeans(bins,trainingSamples,mixed);

figure;
plot(trainingFeatures(idx==1,1),trainingFeatures(idx==1,2),'r.','MarkerSize',12)
hold on
plot(trainingFeatures(idx==2,1),trainingFeatures(idx==2,2),'b.','MarkerSize',12)
hold on

plot(C(:,1),C(:,2),'kx',...
     'MarkerSize',15,'LineWidth',3) 
legend('Cluster 1','Cluster 2','Centroids',...
       'Location','NW')
xlabel("Mean sensor 1, bin 2");
ylabel("Mean sensor 2, bin 2");

[~,idx_test] = pdist2(C,testFeatures,'euclidean','Smallest',1);
gscatter(testFeatures(:,1),testFeatures(:,2),idx_test,'bgm','ooo')
legend('Healthy cluster','Broken cluster','Cluster Centroids', ...
    'Data classified to healthy cluster','Data classified to broken cluster')
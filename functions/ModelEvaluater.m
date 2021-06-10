function [recall, precision, specificity, confusionMatrix] = Modelevaluater(classifier,testFeatures, testLabels)
%returns recal, precision, sensitivity and confution matrix for a
%classifier
%testLabel 1 = positive

predictions = predict(classifier, testFeatures);
truePositive = sum( (testLabels == 1) & (predictions == 1));
falseNegative = sum( (testLabels == 1) & (predictions ==0));

trueNegative = sum ( (testLabels == 0) & (predictions ==0));
falsePositive = sum ( (testLabels == 0) & (predictions == 1));

recall = truePositive / (truePositive + falseNegative);
precision = truePositive / (truePositive + falsePositive);

specificity = trueNegative/(trueNegative + falsePositive);

confusionMatrix = confusionmat(testLabels, predictions);
end


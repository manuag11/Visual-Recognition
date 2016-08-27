[trainingFeatures trainingLabels]=calculate_features_and_labels('train_images',100);
classifier = fitcecoc(trainingFeatures, trainingLabels);
[testFeatures testLabels]=calculate_features_and_labels('test_images',20);
predictedLabels = predict(classifier, testFeatures);
confMat = confusionmat(testLabels, predictedLabels);
for i=1:size(confMat,1)
    sum=0;
    for j=1:size(confMat,2)
        sum=sum+confMat(i,j);
    end
    for j=1:size(confMat,2)
        confMat(i,j)=confMat(i,j)/sum;
    end
end
display(confMat)
accuracy=0;
for i=1:25
    accuracy=accuracy+confMat(i,i);
end
accuracy=accuracy/25;
display(accuracy)
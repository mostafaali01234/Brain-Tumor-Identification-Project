predict = zeros(260,2);
num = 0;
for i = 1:260
    try
        str = strcat('E:\Graduation Project\Project Code\yes\Y',int2str(i),'.jpg');
        im = imread(str);
        FilteredImage = MedianFilter(im);
        i
        fuzzySegmentation(FilteredImage);
        [contrast,correlation,homogeneity,energy,dissimilarity,entropyy,mean,variance,standardDev] = glcm();   %% Call the Function
        
        value = py.svm.predict([contrast,correlation,homogeneity,energy,dissimilarity,entropyy,mean,variance,standardDev]);
        if value.char == '1'
            predict(i,1) = i;
            predict(i,2) = 1;

        else
            predict(i,1) = i;
            predict(i,2) = 0;
            num = num+1;
        end
        
    catch
        continue;
    end
end
predict
num



predict2 = zeros(95,2);
num2 = 0;
for i = 1:95
    try
        str = strcat('E:\Graduation Project\Project Code\no\No',int2str(i),'.jpg');
        im = imread(str);
        FilteredImage = MedianFilter(im); 
        i
        fuzzySegmentation(FilteredImage);
        [contrast,correlation,homogeneity,energy,dissimilarity,entropyy,mean,variance,standardDev] = glcm();   %% Call the Function
        
        value = py.svm.predict([contrast,correlation,homogeneity,energy,dissimilarity,entropyy,mean,variance,standardDev]);
        if value.char == '0'
            predict2(i,1) = i;
            predict2(i,2) = 1;
        else
            predict2(i,1) = i;  
            predict2(i,2) = 0;
            num2 = num2+1;
        end
    catch
        continue;
    end
end
predict2
num2




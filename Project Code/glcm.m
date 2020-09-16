function [contrast,correlation,homogeneity,energy,dissimilarity,entropyy,meanI,varianceI,standardDeviation] = glcm()

%%% Read image
IM = imread('segmentedImage.jpg');
[H,W] = size(IM);

%%% Reduce the gray levels to 8
IM = uint8(floor(double(IM)/32));

%%% Creating the glcm
coMat = zeros(8+1,8+1);
for i=1:H
    for j=1:W-1
        x = IM(i,j)+1;
        y = IM(i,j+1)+1;
        coMat(x,y) = coMat(x,y) + 1;
    end
end
%%%%%% OR to create glcm
%[glcm] = graycomatrix(IM,'NumLevels',8,'GrayLimits',[]);

%%% Normalizing the glcm ( Probability )
coMat(:,:) = coMat(:,:)/sum(sum(coMat(:,:)));

%%% Calculating the stats
contrast = 0;  
energy = 0;    
homogeneity = 0;
meanI = 0;
meanJ = 0;
varianceI = 0;
varianceJ = 0;
correlation = 0;
dissimilarity = 0;
entropyy = 0;

for i=1:size(coMat,1)
    for j=1:size(coMat,2)
        
        %%% To Calculate Contrast
        contrast = contrast + coMat(i,j) * (i-j)^2;
                
        %%% To Calculate Dissimilarity
        dissimilarity = dissimilarity + coMat(i,j) * abs(i-j);

        %%% To Calculate Energy
        energy = energy + coMat(i,j)^2;
        
        %%% To Calculate Homogeneity
        homogeneity = homogeneity + coMat(i,j) / ( 1 + abs(i-j) );
        
        %%% To Calculate Entropy
        if coMat(i,j) > 0
            ln_value = log10( coMat(i,j) ) / log10( exp(1) );
            entropyy = entropyy + coMat(i,j) * -1 * ln_value ;
        end

        %%% To Calculate Mean
        meanI = meanI + (i * coMat(i,j));
        meanJ = meanJ + (j * coMat(i,j));
        
    end
end

%%% To Calculate Variance
for i=1:size(coMat,1)
    for j=1:size(coMat,2)
        varianceI = varianceI + (coMat(i,j) * (i - meanI)^2);
        varianceJ = varianceJ + (coMat(i,j) * (j - meanJ)^2);
    end
end

%%% To Calculate Correlation by using main and variance
for i=1:size(coMat,1)
    for j=1:size(coMat,2)
        value1 = (i-meanI)*(j-meanJ);
        value2 = sqrt(varianceI * varianceJ);
        correlation = correlation + (coMat(i,j) * (value1 / value2) );
    end
end

%%% To Calculate Standard Deviation
standardDeviation = sqrt(varianceI);

%%%
%%%%%%%%%%%%%%%%%%%%%% Save the output in excel file %%%%%%%%%%%%%%%%%%%%%%%%%%
filename='Features.xlsx';
fileExist = exist(filename,'file'); 
if fileExist==0
    header = {'Contrast', 'Correlation', 'Homogeneity', 'Energy', 'Dissimilarity', 'Entropy', 'Mean', 'Variance', 'Standard Deviation'};
    xlswrite(filename,header);
end
    [~,~,input] = xlsread(filename); % Read in your xls file to a cell array (input)
    % This is a cell array of the new line you want to add
    new_data = {contrast, correlation, homogeneity, energy, dissimilarity, entropyy, meanI, varianceI, standardDeviation};
    output = cat(1,input,new_data); % Concatinate your new data to the bottom of input
    xlswrite(filename,output); % Write to the new excel file. 
end


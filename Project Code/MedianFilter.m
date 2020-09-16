function [filteredImage] = MedianFilter(image)

% Convert the Image to Gray
if  (size(image,3) == 3)
    img = rgb2gray(image);
else
    img = image;
end

[R,C] = size(img);    %% get the size of image

filteredImage = zeros(R,C);              %% Create a New Image
filteredImage = double(filteredImage);   %% Convert the image into double

for i=2:R-1
    for j=2:C-1
        window = img(i-1:i+1,j-1:j+1);   %% take a window 3x3
        reSh = reshape(window,[1,9]);    %% To Reshape the window from 2D to 1D
        s = sort(reSh);                  %% Sort the values and
        filteredImage(i,j) = s(5);       %% take the median
    end
end

filteredImage = uint8(filteredImage);    %% Convert double to integer
end


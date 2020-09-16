function [segmentedImage] = fuzzySegmentation(image,handles)
% This program illustrates the Fuzzy c-means segmentation of an image. 
% This program converts an input image into two segments using Fuzzy k-means
% algorithm. The output is stored as "segmentedImage.jpg" in the current directory.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% IM = double(image);                     %% Convert image to double
% 
% data = reshape(IM,[],1);              %% To Reshape the pixels from 2D to 1D  --> (1 column)
% [center,member] = fcm(data,3);        %% Performs fuzzy c-means clustering on the given data and returns 3 cluster centers.
% [center,cindex] = sort(center);       %% Sort a three cluster centers 
% member = member';                     %% inverse --> size x 3  --> (3 columns)
% member = member(:,cindex);            %% Sort the member (smaller to larger)      
% [maxmember,label] = max(member,[],2); %% take the max value of each row
% 
% level = ( max(data(label==2)) + min(data(label==3)) )/2;   %% Threshold value 
% 
% bw = imbinarize(IM,level);   %% Convert the image into black && white
% figure(1),imshow(bw);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
epsilon = 0.3;
no_clusters = 3;
m = 2;            %% Fuzzification Parameter
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
IM = double(image);
data = reshape(IM,[],1);   %% To Reshape the pixels from 2D to 1D  --> (1 column)
no_pixels = size(data,1);  %% Get number of pixels  

%%% Initialize membership matrix randomly
u_mat = rand(no_pixels, no_clusters);
%%% Normalize for sum to 1
u_mat = u_mat ./ sum(u_mat, 2);

%%%%%%%%%% New Cluster Centers (Centroid)
new_centers = sum(u_mat.^m .*data) ./ sum(u_mat.^m);

old_centers = 0;
no_iterations = 0;
while norm(new_centers - old_centers) > epsilon

    no_iterations = no_iterations+1;  %% increase the iteration
        
    %%%%%%%%%%%%%% Euclidean Distance %%%%%%%%%%%%%%
    %%%%%%% || X - Ci || 
    for i = 1 : no_clusters 
        distance(:,i) = data - new_centers(i);
    end
    
    %%%%%%%%%%%%%% Update Membership Matrix %%%%%%%%%%%%%%%
    for i=1:no_pixels
        %%% Membership to each cluster
        for j=1:no_clusters
            sumD = 0;
            for k=1:no_clusters
                d = distance(i,j)/distance(i,k);
                sumD = sumD + d ^(2/(m-1));
            end
            u_mat(i,j) = 1.0/sumD;
            if isnan(u_mat(i,j))   %if NAN --> 1/0
                u_mat(i,j) = 0;
            end
        end
    end
    
    %%%%%%%%%%%%%% Update Cluster Centers %%%%%%%%%%%%%%%
    old_centers = new_centers;
    new_centers = sum(u_mat.^m .*data) ./ sum(u_mat.^m);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [center, cindex] = sort(old_centers);       %% Sort a three cluster centers 
    u_mat = u_mat(:,cindex);                    %% Sort the member (smaller to larger) 

    [maxmember,label] = max(u_mat,[],2);        %% take the max value of each row

    if size(data(label == no_clusters-1),1) == 0        
        level = ( 0 + min(data(label == no_clusters)) )/2;   %% Threshold value     
    else 
        level = ( max(data(label == no_clusters-1)) + min(data(label == no_clusters)) )/2; 
    end
    
    bw = imbinarize(IM,level);     %% Convert the image into black && white
    axes(handles.axesOutput2);
    imshow(bw);
end

disp(['Number of iterations : ',num2str(no_iterations)]);

if no_iterations == 1
    segmentedImage = fuzzySegmentation(image,handles);
else
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% Performs morphological operation (Erosion)
    segmentedImage = imerode(bw, strel('rectangle',[3 3]));   %strel -> structuring element 
    imwrite(segmentedImage,'segmentedImage.jpg');  % store the image in the current directory
end
end




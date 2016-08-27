function [Features,Labels] = calculate_features_and_labels(folder_name,nfiles)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
Features = [];
Labels   = [];
hogFeatureSize=86436;
cellsize=8;
load('filenames.mat');
imagefiles = imageSet(folder_name,   'recursive');
for j=1:25
    
    s=classnames{j};
    s1=strsplit(s);
    s=s1{1};
    len=length(s);
    class_name=s(1:len-1);
    
    %imagefiles=dir(fullfile(folder_name,class_name,'*.jpeg'))
    %nfiles=length(imagefiles);
    features  = zeros(nfiles, hogFeatureSize, 'single');
    for i = 1:nfiles
        image=read(imagefiles(j),i);
        image=imresize(image,[200 200]);
        if(size(image,3)==3)
            im1 = im2single(rgb2gray(image));
        else
            im1 = im2single(image);
        end
        [hog vis]= extractHOGFeatures(im1,'CellSize',[4 4]);
        hog=hog(1:hogFeatureSize);
        features(i, :)=hog;
    end

    % Use the imageSet Description as the training labels. The labels are
    % the digits themselves, e.g. '0', '1', '2', etc.
    labels = repmat(j, nfiles, 1);

    Features = [Features; features];   %#ok<AGROW>
    Labels   = [Labels;   labels  ];   %#ok<AGROW>

end

end
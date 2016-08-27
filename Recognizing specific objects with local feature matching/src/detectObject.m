%%% Skeleton script for 395T Visual Recognition Assignment 1%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Kristen Grauman, UT-Austin
%%% Using the VLFeat library.  http://www.vlfeat.org.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% ****Be sure to add vl feats to the search path: ****
% >>> run('VLFEATROOT/toolbox/vl_setup');
% where VLFEATROOT is the directory where the code was downloaded.
% See http://www.vlfeat.org/install-matlab.html
fprintf('Be sure to add VLFeat path.\n');

clear;
close all;

% Some flags
DISPLAY_PATCHES = 0;
SHOW_ALL_MATCHES_AT_ONCE = 1;

% Constants
N = 50;  % how many SIFT features to display for visualization of features
num_iterations_ransac=100;

templatename = 'object-template.jpg';
scenenames = {'object-template-rotated.jpg', 'scene1.jpg', 'scene2.jpg'};

% Read in the object template image.  This is the thing we'll search for in
% the scene images.
im1 = im2single(rgb2gray(imread(templatename)));


% Extract SIFT features from the template image.
%
% 'f' refers to a matrix of "frames".  It is 4 x n, where n is the number
% of SIFT features detected.  Thus, each column refers to one SIFT descriptor.  
% The first row gives the x positions, second row gives the y positions, 
% third row gives the scales, fourth row gives the orientations.  You will
% need the x and y positions for this assignment.
%
% 'd' refers to a matrix of "descriptors".  It is 128 x n.  Each column 
% is a 128-dimensional SIFT descriptor.
%
% See VLFeats for more details on the contents of the frames and
% descriptors.
[f1, d1] = vl_sift(im1);
[h w d]=size(imread(templatename));

threshold_for_ransac=3;
% count number of descriptors found in im1
n1 = size(d1,2);
x_rec=[1 w 1 w];
y_rec=[1 1 h h];

% Loop through the scene images and do some processing
for scenenum = 1:length(scenenames)
    fprintf('Reading image %s for the scene to search....\n', scenenames{scenenum});
    im2 = im2single(rgb2gray(imread(scenenames{scenenum})));
    
    n1 = size(d1,2);
    % Extract SIFT features from this scene image
    [f2, d2] = vl_sift(im2);
    n2 = size(d2,2);
    
    % Show a random subset of the SIFT patches for the two images
    if(DISPLAY_PATCHES)
        
        displayDetectedSIFTFeatures_all(im1, im2, f1, f2, d1, d2);
        
        fprintf('Showing a random sample of the sift descriptors.  Type dbcont to continue.\n');
        
        keyboard;
    end
    
    % Compute the Euclidean distance between the descriptors in im1
    % and all descriptors in im2
    % This function is an efficient implementation to compute all pairwise Euclidean
    % distances between two sets of vectors.  See the header.
    dists = dist2(double(d1)', double(d2)');
    
    % Sort those distances
    [sortedDists, sortedIndices] = sort(dists, 2, 'ascend');
    
    %sortedDistsArray is an n1x1 matrix where each column represents the
    %index of the closest match for the descriptor correspoinding to the
    %row in consideration
    sortedDistsArray=sortedDists(:,1);
    
    %sortedDists_top2 is an n1x2 matrix where the first two columns
    %represent the index of the top two closest matches for the 
    %descriptor corresponding to the row in consideration
    sortedDists_top2=sortedDists(:,1:2);
    
    % Take the first neighbor as a candidate match.
    % Record the match as a column in the matrix 'matchMatrix',
    % where the first row gives the index of the feature from the first
    % image, the second row gives the index of the feature matched to it in
    % the second image, and the third row records the distance between
    % them.
    matchMatrix = [(1:n1); sortedIndices(:,1)'; sortedDistsArray'];
    
    %applying the thresholded_nearest_neighbors algorithm to reject certain
    %outliers
    [matchMatrix dists_array n1]=thresholded_nearest_neighbors(sortedDistsArray,sortedDists_top2,matchMatrix,n1);
            
    %applying the thresholded_ratio_test algorithm to reject certain
    %outliers      
	matchMatrix=thresholded_ratio_test(dists_array,matchMatrix,n1);
    
    numMatches = size(matchMatrix,2);
    
    %application of ransac to reject outliers
    [max matchMatrix best_transform]=ransac(matchMatrix,numMatches,f1,f2);
    
    %show image2
    clf;
    imshow(im2);
    axis equal ; axis off ; axis tight ;
    hold on ;
    
    %if the maximum number of inliers output after application of ransac if
    %greater than the threshold, we say that there is a match
    if(max>threshold_for_ransac)
        [x_t y_t]=tformfwd(best_transform,x_rec,y_rec);
        rectangle_vector=[x_t;y_t];
        drawRectangle(rectangle_vector,'g');
        fprintf('Showing the object detected in %s with a red rectangle.  Type dbcont to continue.\n',scenenames{scenenum});
        keyboard;
    end
end
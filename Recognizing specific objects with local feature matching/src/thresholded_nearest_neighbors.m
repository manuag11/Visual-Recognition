function [matchMatrix dists_array n1] = thresholded_nearest_neighbors(sortedDistsArray,sortedDists_top2,matchMatrix,n1)
%	SUMMARY rejects outliers as per the thresholded nearest neighbor algorithm

%   DESCRIPTION returns a matchMatrix consisting of only those columns which are
%   inliers as per the thresholded nearest neighbor algorithm. dists_array
%   is an array of the top two nearest matches of every index(descriptor) that survived
%   the threshold nearest neighbor outlier rejection. n1 is the number of
%   inliers remaining after the application of this algorithm
    
    %relevant_indices stores the indices of the matchMatrix that are
    %inliers after the current outlier rejection method
    relevant_indices=[];
    
    threshold=0.8;
    
    %dists_array stores the top two closest matches for the descriptors
    %that are inliers after application of thresholded nearest neighbors
    dists_array=[];
    mean_num=mean(sortedDistsArray);
    for i=1:n1
        if(sortedDistsArray(i)<threshold*mean_num)
            relevant_indices(end+1)=i;
            dists_array=[dists_array sortedDists_top2(i,:)'];
        end
    end
    matchMatrix=matchMatrix(:,relevant_indices);
    n1=size(relevant_indices,2);
end


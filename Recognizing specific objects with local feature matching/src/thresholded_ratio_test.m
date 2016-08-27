function matchMatrix = thresholded_ratio_test(dists_array,matchMatrix,n1)
%	SUMMARY rejects outliers as per the thresholded ratio test
%	algorithm

%   DESCRIPTION returns a matchMatrix consisting of only those columns which are
%   inliers as per the thresholded ratio test algorithm. dists_array
%   is an array of the top two nearest matches of every index(descriptor) that survived
%   the threshold nearest neighbor outlier rejection. n1 is the number of
%   inliers remaining after the application of the thresholded nearest neighbor algorithm

    %relevant_indices stores the indices of the matchMatrix that are
    %inliers after the current outlier rejection method
    relevant_indices=[];
    
    threshold=0.6;
    
	for i=1:n1
        if(dists_array(1,i)/dists_array(2,i)<threshold)
            relevant_indices=[relevant_indices i];
        end
    end
    matchMatrix=matchMatrix(:,relevant_indices);
end


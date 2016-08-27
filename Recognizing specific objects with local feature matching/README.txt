The project contains two major scripts matchComparison.m and detectObject.m. matchComparison.m shows the matches between the template object and the scene images. detectObject.m shows a bounding box around the object if it is present in the scene. These files make use of other scripts in the src folder to produce the desired output. To run any of the two scripts, simply type the name of the script on the MATLAB terminal. For instance,
>matchComparison
>detectObject

The details of other scripts are as follows:
ransac.m - rejects outliers by application of ransac
thresholded_nearest_neighbors.m - rejects outliers as per the thresholded nearest neighbor algorithm
thresholded_ratio_test.m - rejects outliers as per the thresholded ratio test
displayDetectedSIFTFeatures_all.m - displays all SIFT features in the two images under consideration

The rest of the scripts were already provided as part of the assignment and perform the same functionality as they did before.
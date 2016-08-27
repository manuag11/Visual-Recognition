function [max,matchMatrix,best_transform] = ransac(matchMatrix,numMatches,f1,f2)
%   SUMMARY rejects outliers by application of ransac
%   DESCRIPTION returns a matchMatrix consisting of only those columns which are
%   inliers after application of ransac. best_transform represents the best
%   affine transformation returned by ransac

    num_iterations_ransac=100;
    
    %max keeps track of the maximum number of inliers encountered so far in
    %any iteration of ransac
    max=0;
    
    %relevant_indices stores the indices of the matchMatrix that are
    %inliers after application of ransac
    relevant_indices=[];
    
    %threshold_distance represents the threshold for classifying a point as
    %an inlier
    threshold_distance=5;
    
    for j=1:num_iterations_ransac
        
        %permutation array from 1 to numMatches
        permutation=randperm(numMatches);
    
        %extract three random points for finding affine transformation
        random_points=matchMatrix(1:2,permutation(1:3));
    
        %extract the indices in the first image
        first_image_indices=random_points(1,:);
        %extract the indices in the second image
        second_image_indices=random_points(2,:);
        
        %extract the coordinates in the first image
        first_image_coordinates=f1(1:2,first_image_indices);
        %extract the coordinates in the second image
        second_image_coordinates=f2(1:2,second_image_indices);
        
        try
            
            %calculate affine transformation using the three points found
            %above
            affine_transform=cp2tform(first_image_coordinates',second_image_coordinates','affine');
        
            %extract points in the first image which are to be tested
            x_coordinates_to_be_transformed=f1(1,matchMatrix(1,:));
            y_coordinates_to_be_transformed=f1(2,matchMatrix(1,:));
            
            %extract points in the second image against which distance
            %would be checked for labeling a point as an inlier or outlier
            x_coordinates_second_image_original=f2(1,matchMatrix(2,:));
            y_coordinates_second_image_original=f2(2,matchMatrix(2,:));
        
            %applying affine transformation to the points in the first
            %image for inlier classification
            [u v]=tformfwd(affine_transform,x_coordinates_to_be_transformed,y_coordinates_to_be_transformed);
            
            %len represents the number of points which are to be tested
            len=size(x_coordinates_second_image_original,2);
            
            %count represents the number of inliers found in the current
            %iteration of ransac
            count=0;
            
            %relevant_indices1 stores the indices of the inliers as per the
            %current iteration of ransac
            relevant_indices1=[];
            
            %test which points are inliers
            for i=1:len
                %calculate distance between the transformed point and the
                %corresponding point in the second image
                distance=sqrt((u(i)-x_coordinates_second_image_original(i))^2+(v(i)-y_coordinates_second_image_original(i))^2);
                
                %check if the current point is an inlier
                if(distance<threshold_distance)
                    relevant_indices1=[relevant_indices1 i];
                    count=count+1;
                end
            end
            
            %if the current iteration yielded the maximum number of inliers
            %till now, update the best transform and relevant_indices
            if(count>max)
                max=count;
                relevant_indices=relevant_indices1;
                best_transform=affine_transform;
            end
    
        catch
            %move to the next iteration if less than three non-collinear
            %points have been selected randomly for finding an affine
            %transformation
        end
    end
    
    %check if no matches have been found
    if(max==0)
        matchMatrix=[];
    %more than one matches have been found, update the matchMatrix to
    %contain the relevant indices
    else
        matchMatrix=matchMatrix(:,relevant_indices);
    end
end
% Step 4.1: Feature matcher

function [locs1, locs2] = matchPics(I1, I2)
% MATCHPICS Extract features, obtain their descriptors, and match them!
% I1, I2: 2 images
% loc1, loc2: N x 2 matrices of x and y coordinates of the matched point pairs

originalI1 = I1
originalI2 = I2

% MARK: Convert images to grayscale, if necessary
if (ndims(I1) == 3)
    I1 = rgb2gray(I1);
end
if (ndims(I2) == 3)
    I2 = rgb2gray(I2);
end

% MARK: Detect features in both images
points1 = detectFASTFeatures(I1);
points2 = detectFASTFeatures(I2);

% MARK: Obtain descriptors for the computed feature locations
[desc1, locs1] = computeBrief(I1, points1.Location);
[desc2, locs2] = computeBrief(I2, points2.Location);

% MARK: Match features using the descriptors
% Source: https://www.mathworks.com/help/vision/ref/matchfeatures.html
indexPairs = matchFeatures(desc1, desc2, 'MatchThreshold', 10.0, 'MaxRatio', 0.7);    % BRIEF is a binary descriptor
locs1 = locs1(indexPairs(:,1),:);
locs2 = locs2(indexPairs(:,2),:);

% MARK: Plot
% https://www.mathworks.com/help/vision/ref/showmatchedfeatures.html
% figure;
% showMatchedFeatures(originalI1, originalI2, locs1, locs2, 'montage');

end

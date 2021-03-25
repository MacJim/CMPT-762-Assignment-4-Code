% Visualize Homography 2 to 1.

coverImg = imread('../data/cv_cover.jpg');
deskImg = imread('../data/cv_desk.png');


% MARK: Match
[locs1, locs2] = matchPics(coverImg, deskImg);
figure('Name', 'Matched Features', 'NumberTitle', 'off');
showMatchedFeatures(coverImg, deskImg, locs1, locs2, 'montage');    % There are some outliers on the black spots of the desk.


% MARK: computeH
H2to1 = computeH(locs1, locs2);

% Randomly select 10 points
% Source: https://www.mathworks.com/matlabcentral/answers/35258-randomly-select-elements-of-an-array
idx = randperm(size(locs1, 1), 10);

correspondingLocs1 = [];
for i = 1:10
    point2 = [locs2(idx(i),:)'; 1];    % Append 1.
    pointArr = H2to1 * point2;
    correspondingLocs1 = [correspondingLocs1; (pointArr / pointArr(3))'];    % Divide by final element here.
end

figure('Name', 'computeH', 'NumberTitle', 'off');
showMatchedFeatures(coverImg, deskImg, correspondingLocs1(:,1:2), locs2(idx, :), 'montage');


% MARK: computeH_norm
H2to1 = computeH_norm(locs1, locs2);

% Randomly select 10 points
% Source: https://www.mathworks.com/matlabcentral/answers/35258-randomly-select-elements-of-an-array
idx = randperm(size(locs1, 1), 10);

correspondingLocs1 = [];
for i = 1:10
    point2 = [locs2(idx(i),:)'; 1];    % Append 1.
    pointArr = H2to1 * point2;
    correspondingLocs1 = [correspondingLocs1; (pointArr / pointArr(3))'];    % Divide by final element here.
end

figure('Name', 'computeH_norm', 'NumberTitle', 'off');
showMatchedFeatures(coverImg, deskImg, correspondingLocs1(:,1:2), locs2(idx, :), 'montage');


% MARK: computeH_ransac
[bestH2to1, inliers, bestIdx] = computeH_ransac(locs1, locs2);

% Visualize the 4 point-pairs (that produced the most number of inliers).
figure('Name', 'computeH_ransac Chosen Points', 'NumberTitle', 'off');
showMatchedFeatures(coverImg, deskImg, locs1(bestIdx, :), locs2(bestIdx, :), 'montage');

% Visualize the inlier matches that were selected by RANSAC.
correspondingLocs1 = [];
inliersIdx = find(inliers == 1);
inliersLocs2 = locs2(inliersIdx, :);
for i = 1:length(inliersLocs2)
    point2 = [inliersLocs2(i, :)'; 1];
    pointArr = bestH2to1 * point2;
    correspondingLocs1 = [correspondingLocs1; (pointArr / pointArr(3))'];
end

figure('Name', 'computeH_ransac Inliers', 'NumberTitle', 'off');
showMatchedFeatures(coverImg, deskImg, correspondingLocs1(:, 1:2), inliersLocs2, 'montage');

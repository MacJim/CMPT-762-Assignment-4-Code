% Step 4.2: SURF and Rotations
% This script only uses SURF. Refer to the `briefRotTest.m` script for BRIEF.

% MARK: Read the image and convert to grayscale, if necessary
img = imread('../data/cv_cover.jpg');
if (ndims(img) == 3)
    img = rgb2gray(img);
end


% MARK: SURF
surfMatches = [];

originalPoints = detectSURFFeatures(img);
[desc1, originalLocs] = extractFeatures(img, originalPoints.Location, 'Method', 'SURF');

for i = 0:36
    % Rotate image.
    rotatedImg = imrotate(img, i * 10);

    % Detect rotated features.
    rotatedPoints = detectSURFFeatures(rotatedImg);
    [desc2, locs2] = extractFeatures(rotatedImg, rotatedPoints.Location, 'Method', 'SURF');

    % Match.
    % indexPairs = matchFeatures(desc1, desc2, 'MatchThreshold', 10.0, 'MaxRatio', 0.7);
    indexPairs = matchFeatures(desc1, desc2, 'MaxRatio', 0.7);    % Just use the default threshold.
    locs1 = originalLocs(indexPairs(:,1),:);
    locs2 = locs2(indexPairs(:,2),:);

    % Update histogram count.
    surfMatches = [surfMatches size(locs1, 1)];

    % Plot feature matching result at three different orientations.
    if ((i == 3) || (i == 6) || (i == 9))
        figure('Name', sprintf('SURF: Rotation: %d Degrees', i * 10), 'NumberTitle', 'off');
        showMatchedFeatures(img, rotatedImg, locs1, locs2, 'montage');
    end
end

% Display histogram.
figure;
bar(0:10:360, surfMatches);
xlabel('Rotation in Degrees');
ylabel('Matched Feature Count');
title('SURF Matched Features Count');

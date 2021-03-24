% Step 4.2: BRIEF and Rotations
% This script only uses BRIEF. Refer to the `surfRotTest.m` script for SURF.

% MARK: Read the image and convert to grayscale, if necessary
img = imread('../data/cv_cover.jpg');
if (ndims(img) == 3)
    img = rgb2gray(img);
end


% MARK: BRIEF
briefMatches = [];

for i = 0:36
    % Rotate image.
    rotated_img = imrotate(img, i * 10);
    
    % Match features.
    [locs1, locs2] = matchPics(img, rotated_img);
    
    % Update histogram count.
    briefMatches = [briefMatches size(locs1, 1)];
    
    % Plot feature matching result at three different orientations.
    if ((i == 3) || (i == 6) || (i == 9))
        figure('Name', sprintf('BRIEF: Rotation: %d Degrees', i * 10), 'NumberTitle', 'off');
        showMatchedFeatures(img, rotated_img, locs1, locs2, 'montage');
    end
end

% Display histogram.
figure;
bar(0:10:360, briefMatches);
xlabel('Rotation in Degrees');
ylabel('Matched Feature Count');
title('BRIEF Matched Features Count');

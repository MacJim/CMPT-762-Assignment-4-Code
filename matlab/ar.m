% Step 5: Video inpainting.

% Load source files.
cvImg = imread('../data/cv_cover.jpg');
bookVid = loadVid('../data/book.mov');    % 21s "book" video
pandaVid = loadVid('../data/ar_source.mov');    % 20s KFP film clip, 640x360

% VideoWriter
outputFile = VideoWriter('../result/ar.avi');    % Don't know why but the default folder name is `results`.
open(outputFile);

% For each frame.
% for i = 1:10
for i = 1:length(pandaVid)
    % Match cover and book video frame.
    bookImg = bookVid(i).cdata;
    [locs1, locs2] = matchPics(cvImg, bookImg);
    % [bestH2to1, ~, ~] = computeH_ransac(locs1, locs2);
    try
        [bestH2to1, ~, ~] = computeH_ransac(locs1, locs2);
        prevH2to1 = bestH2to1;
    catch
        % In case there aren't enough matching points.
        bestH2to1 = prevH2to1;
    end

    % Replace book cover in book video frame with cropped KFP frame.
    pandaImg = pandaVid(i).cdata;
    pandaImg = pandaImg(40:320, 200:440, :);    % This is in (W, H, C).
    pandaImg = imresize(pandaImg, [size(cvImg, 1), size(cvImg, 2)]);

    % Calculate.
    currentFrame = compositeH(bestH2to1, pandaImg, bookImg);
    writeVideo(outputFile, currentFrame);

    % disp(sprintf('Written frame %d.', i));
end

close(outputFile);

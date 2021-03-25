% Step 4.5: homography with RANSAC.
%
% Minimum requirement: 4 point pairs

function [bestH2to1, inliers, bestIdx] = computeH_ransac(locs1, locs2)
% COMPUTEH_RANSAC A method to compute the best fitting homography given a list of matching points.
% bestH2to1: Homography H with most inliers.
% inliers: A vector of length N with a 1 at those matches that are part of the consensus set, and 0 elsewhere.
% bestIdx: Indices of points used to compute `bestH2to1`.

inlierThreshold = 10;

bestH2to1 = [];
inliers = [];
bestIdx = [];

maxInliersCount = 0;

for i = 1:3000
    % Choose 4 point pairs.
    idx = randperm(size(locs1, 1), 4);

    % Compute H.
    H2to1 = computeH_norm(locs1(idx, :), locs2(idx, :));
    
    % Find current inliers.
    currentInliers = zeros(size(locs1, 1), 1);
    for j = 1:size(locs1, 1)
        targetPoint = H2to1 * [locs2(j, :)'; 1];    % Append 1.
        targetPoint = targetPoint / targetPoint(3);
        loss = sqrt((targetPoint(1) - locs1(j, 1))^2 + (targetPoint(2) - locs1(j, 2))^2);
        if (loss < inlierThreshold)
            currentInliers(j) = 1;
        end
    end

    % Update return value if this H yields more inliers.
    currentInliersCount = length(find(currentInliers == 1));
    if (currentInliersCount > maxInliersCount)
        bestH2to1 = H2to1;
        inliers = currentInliers;
        bestIdx = idx;

        maxInliersCount = currentInliersCount;
    end
end

end


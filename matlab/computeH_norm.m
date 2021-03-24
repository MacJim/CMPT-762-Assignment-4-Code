% Step 4.4: normalized homography.

function [H2to1] = computeH_norm(x1, x2)

%% Compute centroids of the points.
centroid1 = mean(x1);
centroid2 = mean(x2);

%% Shift the origin of the points to the centroid.
x1 = x1 - centroid1;
x2 = x2 - centroid2;

%% Normalize the points so that the average distance from the origin is equal to sqrt(2).
averageDistance1 = mean(hypot(x1(:, 1), x1(:, 2)));
averageDistance2 = mean(hypot(x2(:, 1), x2(:, 2)));
scale1 = sqrt(2) / averageDistance1;
scale2 = sqrt(2) / averageDistance2;

x1 = x1 * scale1;
x2 = x2 * scale2;

%% similarity transform 1.
T1 = [
    scale1, 0, -centroid1(1) * scale1;
    0, scale1, -centroid1(2) * scale1;
    0, 0, 1;
];

%% similarity transform 2.
T2 = [
    scale2, 0, -centroid2(1) * scale2;
    0, scale2, -centroid2(2) * scale2;
    0, 0, 1;
];

%% Compute Homography.
H = computeH(x1, x2);

%% Denormalization.
H2to1 = T1 \ H * T2;

% Step 4.3: Homography Computation

function [H2to1] = computeH(x1, x2)
% Computes the homography between two sets of points.
% x1, x2: N x 2 matrices of (x, y) points.
% H2to1: 3 x 3 matrix of the best homography from image 2 to image 1 in the least-square sense.

% disp(size(x1))

A = zeros(2 * size(x1, 1), 9);

for i = 1:size(x1, 1)
    A(2 * i - 1, :) = [-x2(i, 1), -x2(i, 2), -1, 0, 0, 0, x2(i, 1) * x1(i, 1), x1(i, 1) * x2(i, 2), x1(i, 1)];
    A(2 * i, :) = [0, 0, 0, -x2(i, 1), -x2(i, 2), -1, x1(i, 2) * x2(i, 1), x1(i, 2) * x2(i, 2), x1(i, 2)];
end

[~, ~, V] = svd(A);

H2to1 = V(:, 9);
H2to1 = reshape(H2to1, [3, 3])';

end

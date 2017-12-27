function [ xn, Tx, Tx_inv ] = ex03_1b_normalization( x )
% EX03_1B_NORMALIZATION Normalizes homogeneous data points to be centered
% around the origin and have a standard variation of sqrt(2).
% x:        [3xn] data points.
% xn:       [3xn] normalized data points.
% Tx:       [3x3] normalization matrix.
% Tx_inv:   [3x3] inverse normalization matrix.
    
    n = size(x,2);

    %% TODO!
    % Make sure last component is one.
    Xmax = max(x(3,:));
    Xmin = min(x(3,:));
    assert(Xmax == 1,'homogeneous coordinate rules violated')
    assert(Xmin == 1,'homogeneous coordinate rules violated')

    % Norm is performed in 2D (even for our 3D points, as z=0).
    x_2d = x(1:2,:);
    
    % Center the data around its mean.  
    % ...
    cen = mean(x_2d,2);
    x_cen = x_2d - repmat(cen,1,size(x_2d,2));
    
    
    % Make sure the average distance is sqrt(2).
    % ...
    
    sx = sqrt(2)/mean(sum(x_cen.^2));
    x_cen = sx*x_cen;
    
    % Calculate transformation matrix.
    Tx = [sx 0  -sx*cen(1);...
          0  sx -sx*cen(2);...
          0  0  1];
    Tx_inv = inv(Tx);

    % Normalize point
    xn = [x_cen;ones(1,size(x_cen,2))];
end
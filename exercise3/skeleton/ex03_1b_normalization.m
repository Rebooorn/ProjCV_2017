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
    % x = ???;

    % Norm is performed in 2D (even for our 3D points, as z=0).
    x_2d = x(1:2,:);
    
    % Center the data around its mean.  
    % ...
    % x_cen = ???;
    
    
    % Make sure the average distance is sqrt(2).
    % ...
    % sx = ???;
    
    % Calculate transformation matrix.
    % Tx = ???;
    % Tx_inv = ???;

    % Normalize point
    % xn = ???;
end
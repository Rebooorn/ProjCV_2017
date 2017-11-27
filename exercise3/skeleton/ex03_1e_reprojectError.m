function [ errors ] = ex03_1e_reprojectError( x_pts, X_pts, K, R, t )
% EX03_1E_REPROJECTERROR Computes the reprojection errors as and array
% for all n_ima images.
% x_pts:    cell of image points
% X_pts:    cell of world points
% K:        intrinsic parameter matrix
% R|t:      cells of extrinsic parameters

n_ima = size(x_pts,1);
errors = zeros(1,n_ima);

for i = 1 : n_ima
    % Extract points for image i.
    x_i = x_pts{i};
    X_i = X_pts{i};
    
    %% TODO!
    % Make points homogeneous.
    % x = ???;
    % X = ???;
    
    % Reproject world points and divide by third component.
    % ...
    % x_reproj = ???;
    
    % Compute error (mean norm of residuals).
	residuals=x-x_reproj;
	% errors(i) = ???;
end


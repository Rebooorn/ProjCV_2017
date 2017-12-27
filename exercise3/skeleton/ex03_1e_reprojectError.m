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
    x = [x_i;ones(1,size(x_i,2))];
    X = [X_i;ones(1,size(X_i,2))];
    
    % Reproject world points and divide by third component.
    % ...
    x_reproj = K * [R{i} t{i}] * X;
    temp = [x_reproj(3,:);x_reproj(3,:);x_reproj(3,:)];
    x_reproj = x_reproj./temp;
    
    % Compute error (mean norm of residuals).
	residuals=x-x_reproj;
	errors(i) = mean(sqrt((sum(residuals.*residuals))));
end


%% Ex 03 - 1 Calibration

% The Goal of this exercise is to implement the initialization step of
% Zhengyou Zhang's "Flexible new Technique for Camera Calibration".

%% Clean-Up.
close all;

%% a) Preprocessing
% Read Images
n_ima = 15;
calib_images = cell(n_ima,1);
for i = 1:n_ima,
    ima_fullname = ['../data/ex03_1/ima' num2str(i) '.jpg'];
    calib_images{i} = double(imread(ima_fullname));
end

% Load Point Correspondences from corPts.mat
% They will be loaded as cells x_pts and X_pts.
load('../data/ex03_1/corPts.mat');

%% b) Homography
% Homography between corresponding points for each image.
rH = cell(n_ima,1);
for i = 1:n_ima,
    % 1. Extract points for image i.
    x_i = x_pts{i};
    X_i = X_pts{i};
   
    % 2. Make them homogeneous.
    % TODO!
    % x = ???;
    % X = ???;
    
    % 3. Calculate homography (just like ex04)
    % TODO! Implement ex03_1b_normalizedHomography(x,X)
    rH{i} = ex03_1b_computeHomography(x, X); 
end


%%  c) Absolute Conic
% Generate G Matrix (2n x 6) for the linearized system of equations.
% This is the V Matrix from Zhang's Method, we call it G to avoid any
% ambiguity with Singular Vaue Decomposition.
G = zeros(2*n_ima,6); 
for i = 1:n_ima,
    %% TODO!
    % Implement ex03_1c_constraintEquations(H)
    G((2*i)-1:(2*i), :) = ex03_1c_constraintEquations( rH{i} ); 
end

% Calculate entries of the absolute conic B
% with b = [B11, B12, B22, B13, B23, B33], where b = null(G).
% Solve via SVD.
%% TODO!
% ...
% b = ??? 


%% d) Recovering Parameters
% Calculate intrinsic parameters from the entries of the absolute conic
% and fill the K matrix accordingly.

% TODO! Implement ex03_1d_intrinsicParamsFromConic(b)
[fu, fv, s, u0, v0] = ex03_1d_intrinsicParamsFromConic(b); 
% K = ???;

% Calculate extrinsic parameters from the homography and K.
R = cell(n_ima,1);
t = cell(n_ima,1);
for i = 1 : n_ima,
    % TODO! Implement ex03_1d_extrinsicParamsFromHom(H,K)
    [R{i}, t{i}] = ex03_1d_extrinsicParamsFromHom(rH{i},K);
end

%% Output
fprintf(1,'\n\nCalibration parameters after initialization:\n\n');
fprintf(1,'Focal Length:          fu = %3.5f, fv = %3.5f\n',K(1,1),K(2,2));
fprintf(1,'Principal point:       u0 = %3.5f, v0 = %3.5f\n',K(1,3),K(2,3));
fprintf(1,'Skew:                  s =  %3.5f, alpha_c = %3.5f\n                    => angle of image axes = %3.5f degrees\n',K(1,2),K(1,2)/K(1,1),90 - atan(K(1,2)/K(1,1))*180/pi);


%% e) Error Evaluation
% TODO! Implement ex03_reprojectError(x,X,K,R,t)
errors = ex03_1e_reprojectError( x_pts,X_pts,K,R,t );
err_mean = mean(errors);
fprintf(1,'Reprojection error:    err = %3.5f pixels\n', err_mean);


%% Show Points on Grid
for idx = 1:n_ima,
    % Image points
    x = x_pts{idx};

    %% TODO!
    % Reprojected world points
    % ...
    % x_rep = ???;

    % Plot
    figure;
    imshow(uint8(calib_images{idx}));
    hold on;
    
    % Plot points and error-arrows.
    % plot(?,?,'rx');
    % plot(?,?, 'b+');
    % quiver(?,?,?,?);
    hold off;
end
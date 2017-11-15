clc;
close all;
clear all;
%
% ex02-1b
%

% Load images
F=imread('./schloss/facade.jpg');
P=imread('./schloss/photo.jpg');

% Specify corresponding points
% first find 4 corresponding points in the window
x = readNpoints(P,4);
x_prime = readNpoints(F,4);

% normalize and transform to homogeneous coordinates
% x_mean = mean(x,2);
% x_prime_mean = mean(x_prime,2);
% s_x = sqrt(2)*mean( sqrt(sum( (x-repmat(x_mean,1,4)).^2,1 )) );
% s_x_prime = sqrt(2)*mean( sqrt(sum( (x_prime-repmat(x_prime_mean,1,4)).^2,1 )) );
% x(1,:)=(x(1,:)-x_mean(1))/s_x;
% x(2,:)=(x(2,:)-x_mean(2))/s_x;
% x_prime(1,:)=(x_prime(1,:)-x_prime_mean(1))/s_x_prime;
% x_prime(2,:)=(x_prime(2,:)-x_prime_mean(2))/s_x_prime;

x=[x;ones(1,size(x,2))];
x_prime = [x_prime;ones(1,size(x_prime,2))];

% Compute homography
H=dlt_homography(x,x_prime);

% Compute reprojection error
reprojection_error=reprojection_error_homography(x_prime,H,x)

% Warp image and display
% ...
tform = maketform('projective',H');
P_mapping = imtransform(P,tform);
figure;
hold on
subplot(1,2,1);imshow(P);title('original image');
subplot(1,2,2);imshow(P_mapping);title('mapping image');
hold off

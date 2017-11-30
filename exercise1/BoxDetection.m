close all;
clear all;
clc;

load('example1kinect.mat');
% load('example2kinect.mat');
% load('example3kinect.mat');
% load('example4kinect.mat');

% Display 3D point cloud for nothing.
% 
% c1 = cloud1(:,:,1);
% c2 = cloud1(:,:,2);
% c3 = cloud1(:,:,3);
% 
% c1 = reshape(c1,[424*512,1]);
% c2 = reshape(c2,[424*512,1]);
% c3 = reshape(c3,[424*512,1]);
% 
% c1 = downsample(c1,19);
% c2 = downsample(c2,19);
% c3 = downsample(c3,19);
% 
% scatter3(c1,c2,c3);

cloud = cloud1;

%% RanSAC algorithm
max_inlier = 0;
best_model = planeModel;
best_model.planeVector = [0 0 0];
best_model.maxIteration = 50;
best_model.threshold = round(0.8*424*512);
delta = 0.06;
% model contains: 1. plane parameter(3D vector);
%                 2. threshold to measure the quality of the model (use
%                 60% of pixel num here)
%                 3. parameter for maximum iterations

% count = 0;
% while count<best_model.maxIteration
% %   randomly sample 3 points for model calculation
% %   random sample should avoid unsuccessful points
%     samplesX=[1,1,1];
%     samplesY=[1,1,1];
%     while ~all(reshape(cloud(samplesX,samplesY,:),27,1))
%         samplesX = randsample(size(cloud,1),3);
%         samplesY = randsample(size(cloud,2),3);
%     end
%     model = estimate_plane(samplesX,samplesY,best_model,cloud);
%     inlier = computeInlier(cloud,model,delta); % return binary image
%     num_inlier = length(inlier(inlier==1));
%     if num_inlier>max_inlier
%         best_model = model;
%         max_inlier = num_inlier;
%     end
% %   exit rule
%     if num_inlier > best_model.threshold
%         break;
%     end
%     
%     count = count+1;
% end

best_model = RANSAC(cloud,best_model,delta);
% mask of failure detection 
failMask = all(cloud,3);
% figure;imagesc(failMask);title('failure detection');

% mask amplitudes image and display
floor = computeInlier(cloud,best_model,delta);
figure; imagesc(floor); title('floor detected', 'FontSize', 18);

%% Morphological operation
floor_closed = bwmorph(floor,'close');
figure; imagesc(floor_closed); title('floor detected(closed)', 'FontSize', 18);

%% Detect box in image
BoxDetected = ~floor_closed.*failMask;
figure; imagesc(BoxDetected);title('Box mask', 'FontSize', 18);
BoxReal = amplitudes1.*BoxDetected;
% figure; imagesc(BoxReal); title('Real Box');

%% Detect upper plane of the box
delta = 0.01;
cloud_filter = cloud;
cloud_filter(:,:,1)=cloud_filter(:,:,1).*BoxDetected;
cloud_filter(:,:,2)=cloud_filter(:,:,2).*BoxDetected;
cloud_filter(:,:,3)=cloud_filter(:,:,3).*BoxDetected;
upBox_best_model = planeModel;
upBox_best_model.planeVector = [0 0 0];
upBox_best_model.maxIteration = 50;
upBox_best_model.threshold = round(0.8*424*512);
upBox_best_model = RANSAC(cloud_filter,upBox_best_model,delta);

upBox = computeInlier(cloud_filter,upBox_best_model,delta);
figure; imagesc(upBox);title('upper plane of Box', 'FontSize', 18);

%% use largest connected component in upBox as final result
cc = bwconncomp(upBox);
labeled = labelmatrix(cc);
labeled(labeled>1)=0;  % only preserve largest connected component
figure; imagesc(labeled); title('Largest connected component in upper plane', 'FontSize', 18);


%% edge detection
[B,L]=bwboundaries(labeled,'noholes');
boundary = B{1};
figure;imagesc(labeled);title('edge detection','FontSize',18);
hold on
plot(boundary(:,2),boundary(:,1),'w','LineWidth',2);
hold off

%% visualization of all results
% Object                | Value |
% failure detection,    |   0   |
% floor,                |   1   |
% box,                  |   2   |
% box top plane,        |   3   |
% top plane corners,    |   4   |

FinalRes = floor + 2* BoxDetected + double(labeled);
figure; imagesc(FinalRes); title('Visualization of Box and floor','FontSize',18);
hold on
plot(boundary(:,2),boundary(:,1),'w','LineWidth',2);
hold off

%% calculate box size 
% calculate height according to best_model and upBox_best_model
z=1/best_model.planeVector(3);
height = abs(upBox_best_model.planeVector(3)*z-1)/sqrt(upBox_best_model.planeVector(1)^2+upBox_best_model.planeVector(2)^2+upBox_best_model.planeVector(3)^2)

% width and length
% because we have all 3D coordinates of up-plane, then we don't need to
% detect the corner actually.
% idea: extract middle point, then detect most distant point from middle
% point(corner)

% get middle point
cloud_cal = cloud;
X_coor = cloud_cal(:,:,1).*double(labeled);
Y_coor = cloud_cal(:,:,2).*double(labeled);
Z_coor = cloud_cal(:,:,3).*double(labeled);
mid_point = [sum(X_coor(:)) sum(Y_coor(:)) sum(Z_coor(:))]/sum(labeled(:));

Dist = (X_coor-mid_point(1)).^2 + (Y_coor-mid_point(2)).^2 + (Z_coor-mid_point(3)).^2;
Dist(Dist>=0.99*norm(mid_point)^2)=0;
corner_point = [X_coor(Dist==max(Dist(:))) Y_coor(Dist==max(Dist(:))) Z_coor(Dist==max(Dist(:))) ];

% display location of center and corner
[v,loc_corner] = max(Dist(:));
Dist(Dist==0)=1000 ; %set background to 100
[v,loc_center] = min(Dist(:));
figure; imagesc(FinalRes); title('Center and corner','FontSize',18);
hold on
plot(ceil(loc_center/size(Dist,1)),mod(loc_center,size(Dist,1)),'w*');
plot(ceil(loc_corner/size(Dist,1)),mod(loc_corner,size(Dist,1)),'wo');
hold off

width = 2*abs(mid_point(1)-corner_point(1))
length = 2*abs(mid_point(2)-corner_point(2))



















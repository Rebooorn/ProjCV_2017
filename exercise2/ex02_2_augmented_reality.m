clc
clear all
close all

% Load calibration image
C=double(imread('./ar/TargetA.png'))/255;
% Pixel size of calibration image
calibImagePixelsPerMM=0.5*11.6533333333;
% calibImagePixelsPerMM=1;

% Intrinsic Parameters
K=[625.68234         0 316.52402
           0 623.28764 240.81022
           0         0         1]

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calibration step
[calib_pos, calib_hue, calib_mask]=ar_detect_colored_markers(C); % use calibration image to get

% need to be automatical
% calib_hue_real =calib_hue([3,4,6,20,24]+1,:);
% calib_pos_real =calib_pos([3,4,6,20,24]+1,:);

calib_hue_real =calib_hue;
calib_pos_real =calib_pos;

calib_rgb = hsv2rgb(calib_hue_real);

figure('name','Calibration: Color Mask','numbertitle','off');
imshow(calib_mask);
%%% TODO visualize center of mass and mean color of detected markers
hold on
for i = 1:length(calib_pos_real)
%     plot(calib_pos(i,1),calib_pos(i,2),'o');
    plot(calib_pos_real(i,1),calib_pos_real(i,2),'o','MarkerEdgeColor','none','MarkerFaceColor',calib_rgb(i,:));
end
hold off


% Move origin to center of points and scale to millimeters
calib_pos_real=(calib_pos_real-ones(size(calib_pos_real,1),1)*mean(calib_pos_real))/calibImagePixelsPerMM

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Tracking by detection

% I=double(imread('.\ar\cam1004.png'))/255;
% I=double(imread('./ar/cam1000.png'))/255;
I=double(imread('./ar/cam1001.png'))/255;
% I=double(imread('./ar/cam1002.png'))/255;
% I=double(imread('./ar/cam1003.png'))/255;
% I=double(imread('./ar/cam1004.png'))/255;

[pos,hue,mask]=ar_detect_colored_markers(I); % TODO
% figure('name','Current frame','numbertitle','off');
% imshow(mask);
% hold on
% for i = 1:length(pos)
%     plot(pos(i,1),pos(i,2),'o');
% end
% hold off
index = zeros(length(calib_pos_real),1);

%%% TODO Figure out which markers were matched and visualize
for i = 1:length(calib_pos_real)
%    match real photo with calibration hue value
     dist = abs(hue(:,1)-calib_hue_real(i,1));
     [val,index(i)]=min(dist);
end
figure('name','Current frame','numbertitle','off');
imshow(mask);
hold on
plot(pos(index,1),pos(index,2),'o');
hold off

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Use calibration to compute projection matrix

%%% TODO Figure out projection matrix from planar homography
% x refers to coordinates in reference plane, x_prime refers to points in
% real-world(setting z-coordinate to be 0, and set zeros to the center?)

x = calib_pos_real;
x = [x';ones(1,size(x,1))];
x_prime = pos(index,:);
x_prime = [x_prime';ones(1,size(x_prime,1))];
% x = zeros(2,4); 
% x_prime = zeros(2,4);
H = dlt_homography(x,x_prime);
if det(H)<0 % ensure det(H) to be positive
    H=-H;
end
est = K\H;
r1_prime = est(:,1);
r2_prime = est(:,2);
t_prime = est(:,3);
t = 2*t_prime/(norm(r1_prime)+norm(r2_prime));
r3_prime = cross(r2_prime,r1_prime);
[u,s,v]=svd([r1_prime r2_prime r3_prime]);
R = u*v';
K_prime = [K zeros(3,1)];
Rt = [R t;zeros(1,3) 1];
P = K_prime*Rt;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Draw in coordinates of target (3D millimeters)

%%% TODO Project and draw [0 0 0 1]'  [100 0 0 1]' [0 100 0 1]' and [0 0 100 1]' 
orig = [0 0 0 1]';
x_dir = [100 0 0 1]';
y_dir = [0 100 0 1]';
z_dir = [0 0 100 1]';
orig_prime = P*orig;
x_dir_prime = P*x_dir;
y_dir_prime = P*y_dir;
z_dir_prime = P*z_dir;
figure;
imshow(I);
hold on
plot([orig_prime(1)/orig_prime(3) x_dir_prime(1)/x_dir_prime(3)],[orig_prime(2)/orig_prime(3) x_dir_prime(2)/x_dir_prime(3)],'r');
plot([orig_prime(1)/orig_prime(3) y_dir_prime(1)/y_dir_prime(3)],[orig_prime(2)/orig_prime(3) y_dir_prime(2)/y_dir_prime(3)],'g');
plot([orig_prime(1)/orig_prime(3) z_dir_prime(1)/z_dir_prime(3)],[orig_prime(2)/orig_prime(3) z_dir_prime(2)/z_dir_prime(3)],'b');
% hold off
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Draw a house. (optional)
% front wall
% ar_draw_line(P, [-50 -50 0 1]',[-50 -50 +50 1]');
% ar_draw_line(P, [+50 -50 0 1]',[+50 -50 +50 1]');
% ar_draw_line(P, [-50 -50 +50 1]',[+50 -50 +50 1]');
% ar_draw_line(P, [-50 -50 +50 1]',[0 -50 +100 1]');
% ar_draw_line(P, [+50 -50 +50 1]',[0 -50 +100 1]');
% % back wall
% ar_draw_line(P, [-50 +50 0 1]',[-50 +50 +50 1]');
% ar_draw_line(P, [+50 +50 0 1]',[+50 +50 +50 1]');
% ar_draw_line(P, [-50 +50 +50 1]',[+50 +50 +50 1]');
% ar_draw_line(P, [-50 +50 +50 1]',[0 +50 +100 1]');
% ar_draw_line(P, [+50 +50 +50 1]',[0 +50 +100 1]');
% % connect
% ar_draw_line(P, [-50 -50 +50 1]',[-50 +50 +50 1]');
% ar_draw_line(P, [+50 -50 +50 1]',[+50 +50 +50 1]');
% ar_draw_line(P, [0 -50 100 1]',[0 +50 100 1]');
hold off
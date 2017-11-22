clc
clear all
close all

% Load calibration image
C=double(imread('./ar/TargetA.png'))/255;
% Pixel size of calibration image
calibImagePixelsPerMM=0.5*11.6533333333;

% Intrinsic Parameters
K=[625.68234         0 316.52402
           0 623.28764 240.81022
           0         0         1]

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calibration step
[calib_pos, calib_hue, calib_mask]=ar_detect_colored_markers(C); % TODO
figure('name','Calibration: Color Mask','numbertitle','off');
imshow(calib_mask);
calib_rgb = hsv2rgb(calib_hue);
%%% TODO visualize center of mass and mean color of detected markers
hold on
for i = 1:length(calib_rgb)
    plot(calib_pos(i,1),calib_pos(i,2),'o','MarkerEdgeColor','none','MarkerFaceColor',calib_rgb(i,:));
end
hold off

% Move origin to center of points and scale to millimeters
calib_pos=(calib_pos-ones(size(calib_pos,1),1)*mean(calib_pos))/calibImagePixelsPerMM

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Tracking by detection

I=double(imread('.\ar\cam1000.png'))/255;

[pos,hue,mask]=ar_detect_colored_markers(I); % TODO
figure('name','Current frame','numbertitle','off');
imshow(mask);
hold on
for i = 1:length(pos)
    plot(pos(i,1),pos(i,2),'o');
end
hold off
%%% TODO Figure out which markers were matched and visualize


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Use calibration to compute projection matrix

%%% TODO Figure out projection matrix from planar homography


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Draw in coordinates of target (3D millimeters)

%%% TODO Project and draw [0 0 0 1]'  [100 0 0 1]' [0 100 0 1]' and [0 0 100 1]' 


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

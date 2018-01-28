%% Ex 03 - 2 Stereo Vision

% Goal of this exercise is to implement a disparity estimation from two
% calibrated camera views.

%% Clean-Up.
close all;

%% a) Data
% Read Images
ima_dir = '../data/ex03_2/';
I1 = imread([ima_dir 'bulli' num2str(1) '.jpg']);
I2 = imread([ima_dir 'bulli' num2str(2) '.jpg']);

% Intrinsic Matrix
K = load(fullfile(ima_dir, 'intrinsic_K.txt'));

%% b) The Eight Point Algorithm

% 1. Load Point Correspondences as x1,x24
load(fullfile(ima_dir,'20bulliPoints.mat'));

% 2. Compute fundamental matrix F using 8-Point algorithm
% TODO! Implement the 8-point algorithm in ex03_05_2b_computeF(x1,x2)
F = ex03_2b_computeF(x1,x2,20);

% Control
% This is a matlab internal method for reference of your own implementation only!
F_ctrl = estimateFundamentalMatrix(x1(1:2,:)',x2(1:2,:)','Method','Norm8Point');

% 3. Double-check epipolar constraint x'^T F x = 0
% TODO!
disp('My implementation: err:');
disp(diag(x2'*F*x1));
disp('Ideal err:');
disp(diag(x2'*F_ctrl*x1));

% 4. Draw epipolar lines
lines2 = epipolarLine(F,x1(1:2,:)');
lines1 = epipolarLine(F',x2(1:2,:)');
borders2 = lineToBorderPoints(lines2, size(I2));
borders1 = lineToBorderPoints(lines1, size(I1));
% 
% Draw in image 1
% figure;
% imshow(I1);
% hold on;
% plot(x1(1,:), x1(2,:),'go');
% line(borders1(:, [1,3])', borders1(:, [2,4])');
% hold off;
% 
% % Draw in image 2
% figure;
% imshow(I2);
% hold on;
% line(borders2(:, [1,3])', borders2(:, [2,4])');
% plot(x2(1,:), x2(2,:),'go');
% hold off;

%% c) Camera Matrices 
% Compute essential matrix E using known K.
% TODO!
% size(E)=(3,3)
E=K'*F*K;
[U,S,V] = svd(E);
% S = diag([S(1,1)+S(2,2),S(1,1)+S(2,2),0])/2;
S = diag([1,1,0]);
E = U*S*V';

% Compute the four possible projection matrices.
% TODO! Implement ex03_2c_possibleProjectionMatrices(E); 
% size(P)=(3,4), which moves camera from original position to second
% position
allPossiblePs = ex03_2c_possibleProjectionMatrices(E);

%% d) & e) Triangulation to identify correct setup.
% TODO! Implement ex03_2e_getCorrectP(Ps,K,x1,x2); 
P = ex03_2e_getCorrectP(allPossiblePs,K,x1(:,1),x2(:,1));

% Compute camera matrices.
% TODO!
P1 = [diag([1,1,1]),zeros(3,1)];
P2 = P;

% Triangulate points.
X_est = ex03_2d_triangulation(x1,K*P1,x2,K*P2);

% Plot triangulated points.
figure;
% TODO!
plot3(X_est(1,:)./X_est(4,:),X_est(2,:)./X_est(4,:),X_est(3,:)./X_est(4,:),'+');
grid on;

%% Visualize the camera locations and orientations in the same figure as the points

% TODO!
% First camera
R1 = P1(:,1:3);
t1 = P1(:,4);

% Second camera
R2 = P2(:,1:3);
% t2 = P2(:,4);
% t is the null space of E
[U,S,V] = svd(P2);
t2 = V(:,4);
t2 = t2/t2(4);

cameraSize = 0.2;
hold on;
xlim([-2,2]);
ylim([-2,2]);
zlim([-1,3]);

grid on;
plot3(t1(1),t1(2),t1(3), 'r*');
% plotCamera('Location', t1, 'Orientation', R1, 'Size', cameraSize, 'Color', 'r', 'Label', '1', 'Opacity', 0);
plot3(t2(1),t2(2),t2(3), 'g*');
% plotCamera('Location', t2, 'Orientation', R2', 'Size', cameraSize, 'Color', 'g', 'Label', '2', 'Opacity', 0);
xlabel('x');
ylabel('y');
zlabel('z');
%% Read low-resolution frames along with their motion parameters.
load('lowResData.mat');        

%% Set parameters required for the different super-resolution algorithms.
% Test your implementations with different configurations of these
% parameters! In particular, test with different numbers of input frames,
% different magnification factors and different optimization parameters
% (e.g. step size, regularization weights...).

% --- Parameters related to the image formation process:
% Desired magnification factor (should be an integer > 1).
magFactor = 3;
% Width (standard deviation) of isotropic Gaussian PSF (should be in the
% range 0.2 to 0.5 for real images).
psfWidth = 0.3;

% --- Parameters related to numerical optimization:
% Maximum number of iterations for gradient descent optimization.
maxIter = 50;
% Gradient descent step size parameter (parameter alpha on the exercise
% sheet, should be in the range 0.01 to 0.1)
stepSize = 0.05;
% Termination tolerance for gradient descent optimization.
tolX = 0.005;
% Method to compute descent direction for gradient descent 
% ('steepestDescent' or zometGradient').
descentDirectionMethod = 'zometGradient';
% Prior used for regularization in MAP estimation ('gaussian' or 'tv').
prior = 'tv';
% Regularization weight.
lambda = 2.5;

%% ToDo: Run your super-resolution algorithms.

% Super-resolution using non-uniform interpolation.
% Motion Compensation
V=[];
X=[];
Y=[];
for i=1:26
H=motionParams{1,i};
for y=1:49
for x=1:57
product=H*[y;x;1];
X=[X;product(2)];
Y=[Y;product(1)];
V=[V;LRImages(x,y,i)];
end
end
end

%V=reshape(LRImages,[57*49*26,1]);

% Interpolation

x1=1:1/3:57;
y1=1:1/3:49;
[X1,Y1] = meshgrid(x1,y1);




vq = griddata(X,Y,V,X1,Y1);

%Here vq' will be the image shown in exercise...

% Super-resolution using MAP estimation and iterative optimization.
% ...

%% ToDo: Display the results.

% Show super-resolved images.
% ...

% Show the behaviour of gradient descent optimization.
% ...
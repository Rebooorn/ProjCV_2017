% Compose the super-resolution system matrix for a given low-resolution 
% using the corresponding motion and imaging parameters.
%	- imsize: size of the low-resolution image in the format [hight, width]
%	- magFactor: desired magnification factor (should be an integer > 1)
%	- psfWidth: Width (standard deviation) of an isotropic Gaussian PSF
%	- motionParams: motion parameters given by a homography in homogeneous 
%	  coordinates
function W = composeSystemMatrix(imsize, magFactor, psfWidth, motionParams)

    % Create W' using MEX implementation.
    W = composeSystemMatrix_mex(imsize, magFactor, psfWidth, motionParams);
    % Transpose the result to obtain W'.
    W = W';
    
    % Normalize the row sums.
    W = spdiags( sum(abs(W),2) + eps, 0, size(W,1), size(W,1) ) \ W;
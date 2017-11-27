function [ H ] = ex03_1b_computeHomography( x, X )
% EX03_1B_COMPUTEHOMOGRAPHY
% Calculates a (normalized) homography
% from two sets of corresponding points. 
%
% x [2xn]: the image points
% X [2xn]: the world points on a plane without z-component (because z=0)
%
% H [3x3] x=H*X: the homography (up to scale)

    %% Preprocessing
    n=size(x,2);

    % Make sure last component is one (homogeneous coordinates)
    % TODO!
    % ...
    % x = ???;
    % X = ???; 
    
    %% Normalization of point coordinates (see lecture 4)
    % TODO! Implement ex03_1b_normalization(x)
    [xn,Tx,Tx_inv] = ex03_1b_normalization(x);
    [Xn,TX,TX_inv] = ex03_1b_normalization(X);
   
    %% Compute Homography
	A=zeros(2*n,9);
	for i=1:n
        % Fill A matrix
        % TODO!
        % ...
    end
    
    % SVD of A matrix
    % TODO!
    % ...
    % Hnorm = ???;
    
    % Final (denormalized) homography
    % TODO!
    % ...
    % H = ???;
end

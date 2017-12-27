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
    % ...   (-_-|||) we already did this somewhere else... 
    X = [ X(1:2,:);ones(1,n)]; 
    
    %% Normalization of point coordinates (see lecture 4)
    % TODO! Implement ex03_1b_normalization(x)
    [xn,Tx,Tx_inv] = ex03_1b_normalization(x);
    [Xn,TX,TX_inv] = ex03_1b_normalization(X);
   
    %% Compute Homography
	A=zeros(2*n,9);
	for i=1:n
        % Fill A matrix
        A(2*i-1,4)=xn(3,i)*Xn(1,i);
        A(2*i-1,5)=xn(3,i)*Xn(2,i);
        A(2*i-1,6)=xn(3,i)*Xn(3,i);
        A(2*i-1,7)=-xn(2,i)*Xn(1,i);
        A(2*i-1,8)=-xn(2,i)*Xn(2,i);
        A(2*i-1,9)=-xn(2,i)*Xn(3,i);
        A(2*i,1)=-xn(3,i)*Xn(1,i);
        A(2*i,2)=-xn(3,i)*Xn(2,i);
        A(2*i,3)=-xn(3,i)*Xn(3,i);
        A(2*i,7)=xn(1,i)*Xn(1,i);
        A(2*i,8)=xn(1,i)*Xn(2,i);
        A(2*i,9)=xn(1,i)*Xn(3,i);
    end
    
    % SVD of A matrix
    % TODO!
    % ...
    [U,S,V] = svd(A);
    Hnorm = V(:,size(V,2));
    
    % Final (denormalized) homography
    % TODO!
    % ...
    H = [Hnorm(1) Hnorm(2) Hnorm(3);Hnorm(4) Hnorm(5) Hnorm(6);Hnorm(7) Hnorm(8) Hnorm(9)];
    H = Tx_inv*H*TX;
end

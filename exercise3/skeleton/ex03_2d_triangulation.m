function [ X ] = ex03_2d_triangulation( x1,P1,x2,P2 )
% EX03_2D_TRIANGULATION
% Triangulates a point in 3-D world from given x1,P1,x2,P2.
%       [x1] * P1 * Xw = 0
%       [x2] * P2 * Xw = 0
%  Thus [A]*[Xw;Xw] = [0;0]
%
%   x1,x2: [3xn] homogeneous image points
%   P1,P2: camera matrices
%
%   X: [4xn] triangulated world points

    n = size(x1,2);
    X = zeros(4,n);
    
    for i=1:n
        % Select point
        % TODO!
        % ...
        x = x1(:,i);
        x_p = x2(:,i);
        
        % Compose A matrix according to Hartley & Zisserman.
        % TODO!
        % ...
        A = [ x(1)*P1(3,:)-P1(1,:) ; x(2)*P1(3,:)-P1(2,:); x_p(1)*P2(3,:)-P2(1,:) ; x_p(2)*P2(3,:)-P2(2,:)]; 
        
        % Perform SVD and extract world point
        % TODO!
        [U,S,V]=svd(A);
        X_tmp = V(:,end);
        
        X(:,i) = X_tmp;
    end
end


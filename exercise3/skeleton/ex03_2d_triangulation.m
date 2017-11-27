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
        
        % Compose A matrix according to Hartley & Zisserman.
        % TODO!
        % ...
        % A = ???;
        
        % Perform SVD and extract world point
        % TODO!
        % ....
        % X_tmp = ???;
        
        X(:,i) = X_tmp;
    end
end


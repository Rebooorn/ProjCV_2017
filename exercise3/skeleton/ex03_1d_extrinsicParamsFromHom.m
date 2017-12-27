function [R,t] = ex03_1d_extrinsicParamsFromHom( H, K )
% EX03_1D_EXTRINSICPARAMSFROMHOM Calculates the extrinsic parameters from
% homography, under a given K.
    
    %% TODO!
    % Calculate r1 and r2.
    mu = 1/ norm( K\H(:,1) );
    r1 = mu * inv(K)*H(:,1);
    r2 = mu * inv(K)*H(:,2);
    r3 = cross(r1,r2);
    
    % Norm r1 and r2.
    % ...
    % see above
    
    % r3 is the cross product.
    % ...
    % see above
    
    % Enforce orthonormality using SVD (which is not a given due to noise).
    % ...
    [U, S, V] = svd([r1,r2,r3]);
        
    R = U*V';
    t = mu * inv(K)*H(:,3);
    
end


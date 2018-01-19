function [ Ps ] = ex03_2c_possibleProjectionMatrices( E )
% EX03_2C_POSSIBLEPROJECTIONMATRICES Calculates the 4 possible projection
% matrices from an essential matrix E.

    % SVD of E
    [U,S,V] = svd(E);
    
    %% TODO!
    % Force E to have two identical singular values
    S = diag([1,1,0]);
    [U,S,V] = svd(U*S*V');
    
    % Permutation Matrix W (see Hartley & Zisserman)
    W = [0 -1 0;1 0 0;0 0 1];
    
    % Calculate 4 possible Ps
    Ps = zeros(3,4,4);
    
    % 2 possible rotations...
    R1 = U*W*V';
    R2 = U*W'*V';
    
    % ...and 2 possible translations...
    T = U(:,3);

    % ...resulting in 4 permutations.
    Ps(:,:,1) = [R1,T];
    Ps(:,:,2) = [R1,-T];
    Ps(:,:,3) = [R2,T];
    Ps(:,:,4) = [R2,-T];
  
end



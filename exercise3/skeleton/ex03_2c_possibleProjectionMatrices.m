function [ Ps ] = ex03_2c_possibleProjectionMatrices( E )
% EX03_2C_POSSIBLEPROJECTIONMATRICES Calculates the 4 possible projection
% matrices from an essential matrix E.

    % SVD of E
    [U,~,V] = svd(E);
    
    %% TODO!
    % Force E to have two identical singular values
    % ...
    
    % Permutation Matrix W (see Hartley & Zisserman)
    % W = ???;
    
    % Calculate 4 possible Ps
    Ps = zeros(3,4,4);
    
    % 2 possible rotations...
    % R1 = ???;
    % R2 = ???;
    
    % ...and 2 possible translations...
    % T = ???;

    % ...resulting in 4 permutations.
    % Ps(:,:,1) = ???;
    % Ps(:,:,2) = ???;
    % Ps(:,:,3) = ???;
    % Ps(:,:,4) = ???;
  
end



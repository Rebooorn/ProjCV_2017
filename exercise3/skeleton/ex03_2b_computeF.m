function [ F ] = ex03_2b_computeF( x, x_prime )
% EX03_2B_COMPUTEF Computes the fundamental Matrix F from 
% a set of correpsonding points (8 Point Algorithmn).
% x1 = [3xn] points in the first image
% x2 = [3xn] points in the second image

% Returns F such that x_2^T F x = 0;

    n = size(x,2);

    % Normalization
    [x1, Tx1, Tx1_inv] = ex03_1b_normalization(x);
    [x2, Tx2, Tx1_inv] = ex03_1b_normalization(x_prime);

    % Compose linear matrix A
    % TODO!
    % A = ???
    
    % Calculate F matrix
    % TODO!
    
    % Make it rank 2 
    % TODO!
    
    % Revert normalization
    % TODO!
    % F= ???
end


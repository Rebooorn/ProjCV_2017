function [ F ] = ex03_2b_computeF( x, x_prime )
% EX03_2B_COMPUTEF Computes the fundamental Matrix F from 
% a set of correpsonding points (8 Point Algorithmn).
% x1 = [3xn] points in the first image
% x2 = [3xn] points in the second image
% Returns F such that x_2^T F x = 0;


%randomly select 8 point correspondences out of 20 from x and x_prime, 3*8 matrices
s = randperm(8);
x=x(:,s(1:8));
x_prime=x_prime(:,s(1:8));


% Set n=8
    n = size(x,2);

    % Normalization
    [x1, Tx1, Tx1_inv] = ex03_1b_normalization(x);
    [x2, Tx2, Tx1_inv] = ex03_1b_normalization(x_prime);

    % Compose linear matrix A
    % TODO!
   A = [ repmat(x2(1,:)',1,3) .* x1', repmat(x2(2,:)',1,3) .* x1', x1(1:3,:)'];
    
    % Calculate F matrix
   [U,S,V] = svd(A);

    % Make it rank 2 
    F_norm = reshape(V(:,end),3,3)';

[uf,sf,vf] = svd(F_norm);
F_norm_prime = uf*diag([sf(1) sf(5) 0])*(vf');

    
    % Revert normalization
    % TODO!
    F= Tx2' * F_norm_prime* Tx1;
end


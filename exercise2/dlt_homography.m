% Algebraic estimate of a 2D homography 
% x,x_prime source and target points, related approximately by x_prime=H*x
% assumes size(x)==[3,n], size(x)==size(x_prime)
function H = dlt_homography(x, x_prime)
	n=size(x,2);
	
	% TODO ...
    % generate M matrix, size(M)=[2n,9]
    M = zeros(2*n,9);
    for i =1:n
        M(2*i-1,4)=x_prime(3,i)*x(1,i);
        M(2*i-1,5)=x_prime(3,i)*x(2,i);
        M(2*i-1,6)=x_prime(3,i)*x(3,i);
        M(2*i-1,7)=-x_prime(2,i)*x(1,i);
        M(2*i-1,8)=-x_prime(2,i)*x(2,i);
        M(2*i-1,9)=-x_prime(2,i)*x(3,i);
        M(2*i,1)=-x_prime(3,i)*x(1,i);
        M(2*i,2)=-x_prime(3,i)*x(2,i);
        M(2*i,3)=-x_prime(3,i)*x(3,i);
        M(2*i,7)=x_prime(1,i)*x(1,i);
        M(2*i,8)=x_prime(1,i)*x(2,i);
        M(2*i,9)=x_prime(1,i)*x(3,i);
    end
    
    % calculate null space of M, use SVD and last col of V as null space
    [U,S,V]=svd(M);
    h=V(:,size(V,2));   % extract last coloum
    
    % sort to get H
    H=[h(1) h(2) h(3);h(4) h(5) h(6);h(7) h(8) h(9)];
    
	
end % function

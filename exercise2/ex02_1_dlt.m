%
% ex02-1a (dlt_homography)
%

% some random homography with not too small determinant
while 1
	H=rand(3);
	H(1:2,3)=H(1:2,3)*100;
	H(3,1:2)=H(3,1:2)*0.05;
	H(3,3)=1;
	if (det(H(1:2,1:2))<0.5)
		break;
	end % if
end % while

% Some test points
n=4+round(rand(1)*20)
x=rand(3,n)*100;
x(3,:)=1;
x_prime=H*x;
x_prime=x_prime./([ 1 1 1 ]'*x_prime(3,:));

% Call DLT function with GT
H_estimate=dlt_homography(x,x_prime);

% Show results
H_ground_truth=H
H_estimate=H_estimate/H_estimate(3,3)

% Reprojection Error
err_numerics=reprojection_error_homography(x_prime,H_estimate,x)


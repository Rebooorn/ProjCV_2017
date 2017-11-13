% Computes geometric reprojection error
function err=reprojection_error_homography(x_prime,H,x)
	x_proj=H*x;
	x_proj=x_proj./([1;1;1]*x_proj(3,:));
	residuals=x_prime-x_proj;
	err=mean(sqrt((sum(residuals.*residuals))));
end % function

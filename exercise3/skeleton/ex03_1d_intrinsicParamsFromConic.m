function [ fu, fv, s, u0, v0 ] = ex03_1d_intrinsicParamsFromConic( b )
% EX03_1D_INTRINSICPARAMSFROMCONIC Extracts the intrinsic parameters from
% the absolute conic, according to Zhang's  method.
% Focal length: fu, fv
% Skew angle: s
% Principal point: u0, v0
% b is assumed to be the vector form of the absolute conic, which is
% a symmetric matrix of 6 distinct entries.
% b = [B11, B12, B22, B13, B23, B33]
%       1    2    3    4    5    6


%% TODO!

v0 = (b(2)*b(4)-b(1)*b(5))/(b(1)*b(3)-b(2)*b(2));
lambda = b(6) - ( b(4)*b(4)+v0*(b(2)*b(4)-b(1)*b(5)) )/(b(1));
fu = sqrt(lambda/b(1));
fv = sqrt( lambda*b(1)/(b(1)*b(3)-b(2)*b(2)) );
s = -b(2)*fu*fu*fv/lambda;
u0 = s*v0/fv - b(4)*fu*fu/lambda;

end


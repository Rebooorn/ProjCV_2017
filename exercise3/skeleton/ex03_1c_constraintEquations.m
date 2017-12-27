function [ G ] = ex03_1c_constraintEquations( H )
% EX03_1C_CONSTRAINTEQUATIONS Generates two constraint from a given homography
% H according to h_i^T B h_j = g_ij b and returns the 2 x 6 matrix
% G = [ g_12^T; (g_11 - g_22)^T ] according to Eqn. (11) of the slides.

   % Remember: h_ij denots column i, row j. 
   
   %% TODO!
   % ...
   G =  zeros(2,6);
   g12 = [H(1,1)*H(1,2), H(1,1)*H(2,2)+H(2,1)*H(1,2), H(2,1)*H(2,2), H(3,1)*H(1,2)+H(1,1)*H(3,2), H(3,1)*H(2,2)+H(2,1)*H(3,2), H(3,1)*H(3,2)];
   g11 = [H(1,1)*H(1,1), H(1,1)*H(2,1)+H(2,1)*H(1,1), H(2,1)*H(2,1), H(3,1)*H(1,1)+H(1,1)*H(3,1), H(3,1)*H(2,1)+H(2,1)*H(3,1), H(3,1)*H(3,1)];
   g22 = [H(1,2)*H(1,2), H(1,2)*H(2,2)+H(2,2)*H(1,2), H(2,2)*H(2,2), H(3,2)*H(1,2)+H(1,2)*H(3,2), H(3,2)*H(2,2)+H(2,2)*H(3,2), H(3,2)*H(3,2)];
   G(1,:) = g12;
   G(2,:) = g11-g22;
end
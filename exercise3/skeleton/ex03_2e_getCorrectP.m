function [ P, index ] = ex03_2e_getCorrectP( Ps, K, x1, x2 )
% EX03_2E_GETCORRECTP
% Determines the correct projection matrix out of the 4 solutions that are possible with
% any given essential matrix.
% For each configuration, the corresponding world point is triangulated to
% check the depth information. The projection, for which the world point
% lies in front of both cameras, is the correct one.
%
% Ps: [(3x4)x4] the set of four possible projection matrices
% K:  The intrinsic camera matrix
% x1,x2:   a matching point set

    % First camera: P = [I|0] 
    % P1 = ???;
    
    for i = 1:4
        % Second camera candidate
        % TODO!
        % P2 = ???;
        
        % Triangulate a point using that candidate.
        % TODO! Implement ex03_2d_triangulation(x1,P1,x2,P2)
        
        % X = ex03_2d_triangulation(?,?,?,?);
        
        % For both cameras:
        %   Rotate back to camera coordinates.
        %   Normalize.
        %   Check z-component.
        %   Return the correct P and index of the 4 candidates.
        
        % TODO!
        % ...
    end
end


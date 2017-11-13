% Detect colored blobs in an image.
% I is a color image.
% returns
%    center_of_mass: matrix containing the x,y positions of all marker centers
%    color_hue: vector containing the hue of the mean rgb color
%    mask: boolean image indicating pixels that belong to markers (input for connected components)
function [center_of_mass, color_hue, mask]=ar_detect_colored_markers(I)

	%%% (optional: filters like median ... )
	% ...
	
	%%% Compute value, chromacity and saturation
	%%% (alternatively use build-in hsv(...) function)
	color_value=max(I,[],3);
	% color_chromacity=...;
	% color_saturation=...;

	%%% Score is simply saturation with pixels under thresh_value intensity excluded
	% ...
	
	%%% (optional: morphological opening ... )
	% ...
	
	% Find connected components
	[ny,nx]=size(mask);
	[label_image,n]=bwlabel(mask);
	
	%%% Analyze components
	% ...
	
end % function

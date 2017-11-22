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
	color_chromacity=max(I,[],3)-min(I,[],3);
    color_saturation=color_chromacity./color_value;
    
	%%% Score is simply saturation with pixels under thresh_value intensity excluded
	mask=ones(size(color_value));
%   mask = color_value;
    mask(color_value<0.25)=0;

	%%% (optional: morphological opening ... )
	mask = bwareaopen(mask,50);
   
	% Find connected components
	[ny,nx]=size(mask);
	[label_image,n]=bwlabel(mask);
    
    center_of_mass = zeros(n+1,2);
    color_hue = zeros(n+1,3);
	%%% Analyze components
	% ...
    for i = 0:n
    %   in test image, target component is 1 and other all is 0
        test = zeros(size(color_value));
        test(label_image==i)=1;
    %   calculate center of mass
        [Xc,Yc]=meshgrid(1:size(test,2),1:size(test,1));
        Xc = Xc.*test;
        Yc = Yc.*test;
        Xm = round(sum(Xc(:)) / sum(test(:)));
        Ym = round(sum(Yc(:)) / sum(test(:)));
        if Xm<size(test,2)
            center_of_mass(i+1,1) = Xm;
        else
            center_of_mass(i+1,1) = size(test,2)
        end
        
        if Ym<size(test,1)
            center_of_mass(i+1,2) = Ym;
        else
            center_of_mass(i+1,2) = size(test,1);
        end
        
        color_hue(i+1,:)=rgb2hsv(I(center_of_mass(i+1,2),center_of_mass(i+1,1),:));
    end

end % function

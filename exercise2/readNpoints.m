function M = readNpoints(img,num)
% display img, instruct user to locate N=num points;
% M is point coordinates matrix, size(M)=[2,num]

M=zeros(2,num); % initiate M

figure;
imshow(img);
title('Pls click on four points');
hold on
for i=1:num
    [x,y]=ginput(1);
    M(1,i)=x;
    M(2,i)=y;
    plot(x,y,'ro');
end

end
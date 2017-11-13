function r = estimate_plane(coorX,coorY,Last_model,cloud)
% coorX, coorY are vectors with length of 3
% return: plane model calculated by XY
   thisModel = Last_model;
   p1 = reshape(cloud(coorX(1),coorY(1),:),3,1);
   p2 = reshape(cloud(coorX(2),coorY(2),:),3,1);
   p3 = reshape(cloud(coorX(3),coorY(3),:),3,1);
   N=[1 1 1]/[p1 p2 p3];
   thisModel.planeVector = N;
   r=thisModel;
end
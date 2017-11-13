    function r = computeInlier(cloud,model,delta)
% compute inlier binary map of inlier of specific model;
% delta is the tolerance to separate inlier and outlier

% model of plane: N, plane parameter;
% plane representation: n1*x + n2*y + n3*z = 1,  
    resMap = cloud(:,:,1)*model.planeVector(1) + cloud(:,:,2)*model.planeVector(2) + cloud(:,:,3)*model.planeVector(3);
    resMap(resMap<1-delta)=0;
    resMap(resMap>1+delta)=0;
    resMap(resMap~=0)=1;
    r = resMap;
end
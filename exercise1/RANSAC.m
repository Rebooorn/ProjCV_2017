function r = RANSAC(cloud,best_model,delta)
% RANSAC(cloud,start_model,delta), return best model of dominant plane
% start model need initiate.
    max_inlier = 0;
    count = 0;
    while count<best_model.maxIteration
    %   randomly sample 3 points for model calculation
    %   random sample should avoid unsuccessful points
        samplesX=[1,1,1];
        samplesY=[1,1,1];
        while ~all(reshape(cloud(samplesX,samplesY,:),27,1))
            samplesX = randsample(size(cloud,1),3);
            samplesY = randsample(size(cloud,2),3);
        end
        model = estimate_plane(samplesX,samplesY,best_model,cloud);
        inlier = computeInlier(cloud,model,delta); % return binary image
        num_inlier = length(inlier(inlier==1));
        if num_inlier>max_inlier
            best_model = model;
            max_inlier = num_inlier;
        end
    %   exit rule
        if num_inlier > best_model.threshold
            break;
        end

        count = count+1;
    end
    
    r = best_model;
end
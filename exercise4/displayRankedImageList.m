function displayRankedImageList(names, scores, uniform, numImages)
% DISPLAYRANKEDIMAGELIST  Display a (subset of a) ranked list of images
%   DISPLAYRANKEDIMAGELIST(NAMES, SCORES) displays NUMIMAGES images from
%   the list of image names NAMES sorted by decreasing scores
%   SCORES. IF UNIFORM is true then the images are sampled uniformly
% 

[drop, perm] = sort(scores, 'descend') ;
if uniform
  perm = vl_colsubset(perm, numImages, 'uniform') ;
else
  perm = vl_colsubset(perm, numImages, 'beginning') ;
end
for i = 1:length(perm)
  vl_tightsubplot(length(perm),i,'box','inner') ;
  if exist(names{perm(i)}, 'file')
    fullPath = names{perm(i)} ;
  else
    fullPath = fullfile('data','images',[names{perm(i)} '.jpg']) ;
  end
  imagesc(imread(fullPath)) ;
  text(10,10,sprintf('score: %.2f', scores(perm(i))),...
       'background','w',...
       'verticalalignment','top', ...
       'fontsize', 8) ;
  set(gca,'xtick',[],'ytick',[]) ; axis image ;
end
colormap gray ;

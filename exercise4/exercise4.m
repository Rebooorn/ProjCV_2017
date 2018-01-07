setup;

% set random state
vl_twister('state', 1);

data_dir = 'data';
img_dir = fullfile('data', 'images');

opt.feature = 'sift'; % sift or phow
opt.feat_norm = 'none'; % none or hellinger
opt.encoding = 'vq'; % vq or vlad
opt.enc_norm = 'none'; %none (only l2), intra, power
opt.spp_levels = 0; % spatial pyramid level
opt.k = 1000; % number of clusters (try for vq: 100 / 1000 / 10000, for vlad: 50 / 100 / 150)

% get all training images
i = 1;
names = cell(1,2);
for subset = {'background_train.txt', ...                
              'horse_train.txt'}
  fname = fullfile(data_dir, char(subset));
  fid = fopen(fname);
  tmp = textscan(fid,'%s'); 
  names{i} = tmp{1};
  fclose(fid);
  i = i + 1;
end
names = cat(1,names{:})';

% create temporary directory
tmp_dir = sprintf('%s_%s_%s_%s_%d_%d',opt.feature, opt.feat_norm, ...
                     opt.encoding, opt.enc_norm, opt.spp_levels, opt.k);
fprintf('create %s\n', tmp_dir)		     
vl_xmkdir(tmp_dir);

% select some local descriptors
if ~exist(fullfile(tmp_dir,'descriptors.mat'), 'file')  
  disp('> feature extraction');
  % TODO: select and extract Features
  % ...
  % TODO: save descriptors.mat
else 
  disp('load descriptors');
  % TODO: load descriptors.mat
end

% compute background model
if ~exist(fullfile(tmp_dir,'kmeans_kdtree.mat'), 'file')  
  disp('> k-means'); 
  % TODO: compute kmeans and kdtree
  % ...
  % TODO: Save centers and kdtree
else 
  disp('load kmeans-centers / kdtree')
  % TODO: load kmeans / kdtree
end

%%%
% ENCODING
%%%
disp('> encoding');  

% for each subset compute encoding
for subset = {'background_train', ...
                'background_val', ...
                'horse_train', ...
                'horse_val'}
    % read files
    out_path = fullfile(tmp_dir, sprintf('%s_enc.mat', char(subset)));
    fprintf('| Processing %s\n', out_path);    
    if exist(out_path, 'file')
      disp('| loaded saved file');
      continue; 
    end
    fname = fullfile(data_dir, [char(subset) '.txt']);
    fid = fopen(fname);
    tmp = textscan(fid, '%s');
    img_names = tmp{1};
    fclose(fid);
    
    n_images = numel(img_names);
    fprintf('encode %d iamges\n', n_images);
    
    % TODO: compute encoding for each image

    % TODO save encodings
end

%%%
% Classification
%%%
disp('> classification');  

% TODO Load training data
% TODO Load labels: all positives get label '1', all negatives '-1' 

% count how many images are there
fprintf('Number of training images: %d positive, %d negative\n', ...
        sum(labels > 0), sum(labels < 0));

% Train the linear SVM. The SVM paramter C should be
% cross-validated. Here for simplicity we pick a valute that works
% well
C = 1.0;

%% Bonus: proper cross-validation

% Train now SVM using the complete training set w. chosen C
% TODO 

% ---
% Classify the test images and assess the performance
% ---
% Load testing data
pos = load(fullfile(tmp_dir,'horse_val_enc.mat'));
neg = load(fullfile(tmp_dir,'background_val_enc.mat'));
% TODO: set test-labels (1/-1)

fprintf('Number of testing images: %d positive, %d negative\n', ...
        sum(test_labels > 0), sum(test_labels < 0));

% Test the linear SVM
% TODO

% Visualize the ranked list of images
figure(1) ; clf ; set(1,'name','Ranked test images (subset)') ;
displayRankedImageList(test_names, testScores, false, 36)  ;

% Visualize the precision-recall curve
% TODO

% Print results
% TODO

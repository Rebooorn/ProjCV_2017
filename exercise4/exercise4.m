%% Testing index
% sift none vq none 0 1000
% phow none vq none 0 1000 ==>0.5255
% sift none vlad none 0 100 
% sift none vlad intra 0 100
% sift none vlad power 0 100
% phow none vlad none 0 100
% phow none vlad intra 0 100
% phow none vlad power 0 100


%% preparation
run('VLFEATROOT/toolbox/vl_setup.m')
vl_setup;

% set random state
vl_twister('state', 1);

data_dir = 'data';
img_dir = fullfile('data', 'images');

opt.feature = 'sift'; % sift or phow
opt.feat_norm = 'none'; % none or hellinger
opt.encoding = 'vlad'; % vq or vlad
opt.enc_norm = 'none'; %none (only l2), intra, power
opt.spp_levels = 0; % spatial pyramid level
opt.k = 100; % number of clusters (try for vq: 100 / 1000 / 10000, for vlad: 50 / 100 / 150)

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
  % 1158 images in total, for each image randomly select 150, and in total
  % 173700 features are selected
  n = length(names);
  descriptors = zeros(128,173700);
  flag = 0; %flag for last colomn of descriptors
  for i = 1:n
      % occasionally the number of features will be less than 150, then
      % push all features and 
      p = fullfile(img_dir,strcat(num2str(names{i}),'.jpg'));
      a = imread(p);
      % the size of feature vector is 128
      if strcmp(opt.feature,'sift')==1
          [F,D] = vl_sift(rgb2gray(im2single(a)));
      else
          [F,D] = vl_phow(rgb2gray(im2single(a)),'step',4,'floatdescriptors',true);
      end
      if size(D,2)>150
        descriptors(:,flag+1:flag+150) = vl_colsubset(D,150);
        flag = flag+150;
      else
        descriptors(:,flag+1:flag+size(D,2))=D;
        flag = flag+size(D,2);
      end
  end
  
  descriptors(:,flag+1:end)=[];
  save(fullfile(tmp_dir,'descriptors.mat'),'descriptors');
%   save fullfile(tmp_dir,'descriptors.mat') descriptors
  
  % TODO: save descriptors.mat
else 
  disp('load descriptors');
  load(fullfile(tmp_dir,'descriptors.mat'));
%   load discriptors.mat
  % TODO: load descriptors.mat
end

% compute background model
if ~exist(fullfile(tmp_dir,'kmeans_kdtree.mat'), 'file')  
  disp('> k-means'); 
  % TODO: compute kmeans and kdtree
  % in 'descriptors' of last step, we generated 173700 features
  % corresponding to 1158 images, here we compress all features(173700)
  % into a codebook with length of 1000, using kmeans.
  % cen is our dictionary. 
  
  [cen,refer] = vl_kmeans(descriptors,opt.k,'initialization','plusplus','algorithm','ann');
  KDT = vl_kdtreebuild(cen);
  save(fullfile(tmp_dir,'kmeans_kdtree.mat'),'cen','refer','KDT');
%   save kmeans_kdtree.mat cen refer KDT
  % TODO: Save centers and kdtree
else 
  disp('load kmeans-centers / kdtree')
  % TODO: load kmeans / kdtree
  load(fullfile(tmp_dir,'kmeans_kdtree.mat'));
end


%%
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
    fprintf('encode %d images\n', n_images);
    
    % TODO: compute encoding for each image
    if strcmp(opt.encoding,'vq')
        % using VQ for encoding
        Cnt = zeros(opt.k,n_images);
        for i = 1:n_images
           % calculate each image and save to "enc"
           p = fullfile(img_dir,strcat(num2str(img_names{i}),'.jpg'));
           a = imread(p);
           if strcmp(opt.feature,'phow')
               % by default using sift
               [F,D] = vl_phow(rgb2gray(im2single(a)),'step',4,'floatdescriptors',true);
           else
               [F,D] = vl_sift(rgb2gray(im2single(a))); 
           end
           % D is the matrix 0f descriptors, size = (128,N),and ind is the
           % mapping from D to cen 
           [ind,dist]=vl_kdtreequery(KDT,cen,double(D)); 
           tmp = histc(ind,1:1000)./norm(histc(ind,1:1000),2);
           Cnt(:,i) = tmp';
        end
        % TODO save encodings
        eval(strcat(char(subset),'=Cnt;'));
        eval(strcat('save(''',out_path,''',''', char(subset),''')'));
    else
        % using VLAD for encoding
        Cnt = zeros(opt.k*128,n_images);
        for i = 1:n_images
           % calculate each image and save to "enc"
           p = fullfile(img_dir,strcat(num2str(img_names{i}),'.jpg'));
           a = imread(p);
           if strcmp(opt.feature,'sift')
               [F,D] = vl_sift(rgb2gray(im2single(a))); 
           else
               [F,D] = vl_phow(rgb2gray(im2single(a)),'step',4,'floatdescriptors',true);  
           end
           [ind,dist]=vl_kdtreequery(KDT,cen,double(D));
           % accumulate and catenate to a vector of k*d dimension
           res = double(D) - cen(:,ind);
           for j = 1:opt.k
              if strcmp(opt.enc_norm,'power')==1
                  tmp = sum(res(:,ind==j),2);
                  Cnt(128*j-127:128*j,i) = sqrt(abs(tmp));
              elseif strcmp(opt.enc_norm,'intra')==1
                  tmp = sum(res(:,ind==j),2);
                  Cnt(128*j-127:128*j,i) = tmp/norm(tmp,2);
              else
                  % none method
                  Cnt(128*j-127:128*j,i) = sum(res(:,ind==j),2);
              end
           end
           % followed by global normalization
           Cnt(:,i) = Cnt(:,i)/norm(Cnt(:,i),2);
        end
        % save encoding 
        eval(strcat(char(subset),'=Cnt;'));
        eval(strcat('save(''',out_path,''',''', char(subset),''')'));
    end
end

%%%
% Classification
%%%
disp('> classification');  


% TODO Load training data
load(fullfile(tmp_dir,'background_train_enc.mat'));
load(fullfile(tmp_dir,'background_val_enc.mat'));
load(fullfile(tmp_dir,'horse_train_enc.mat'));
load(fullfile(tmp_dir,'horse_val_enc.mat'));
% TODO Load labels: all positives get label '1', all negatives '-1' 
labels = ones(1,size(background_train,2)+size(horse_train,2));
labels(1,1:size(background_train,2)) = -1;
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
[W,B] = vl_svmtrain([background_train, horse_train],labels,1.0/(C*length(labels)));

% % ---
% % Classify the test images and assess the performance
% % ---
% Load testing data
pos = load(fullfile(tmp_dir,'horse_val_enc.mat'));
neg = load(fullfile(tmp_dir,'background_val_enc.mat'));
% TODO: set test-labels (1/-1)
% labels_eva ==> [ -1(background), 1(horse) ]
labels_eva = ones(1,size(background_val,2)+size(horse_val,2));
labels_eva(1,1:size(background_val,2)) = -1;

fprintf('Number of testing images: %d positive, %d negative\n', ...
        sum(labels_eva > 0), sum(labels_eva < 0));

% Test the linear SVM
% We hope testScores to be identical to labels_eva
testScores = W'*[background_val, horse_val]+B;
testScores_horse = W'*horse_val+B;
% Visualize the ranked list of images
i = 1;
test_names = cell(1,2);
for subset = {'horse_val.txt','background_val.txt'}
  fname = fullfile(data_dir, char(subset));
  fid = fopen(fname);
  tmp = textscan(fid,'%s'); 
  test_names{i} = tmp{1};
  fclose(fid);
  i = i + 1;
end
test_names = cat(1,test_names{:})';

figure; 
displayRankedImageList(test_names, testScores, false, 36)  ;

% Visualize the precision-recall curve
% TODO
[recall,precision,info] = vl_pr(labels_eva,testScores);
figure; plot(recall,precision);
xlabel('recall');
ylabel('precision');

% Print results
% TODO
% print accuracy, TNR, and TPR
testScores(testScores>=0) = 1;
testScores(testScores<0) = -1;
comp = (testScores==labels_eva);
Accuracy = sum(comp(:))/length(comp);
TNR = comp(1,1:size(background_val,2));
TNR = sum(TNR(:))/length(TNR);
TPR = comp(1,size(background_val,2)+1:end);
TPR = sum(TPR(:))/length(TPR);

disp(['Accuracy: ',num2str(Accuracy)]);
disp(['Average precision: ',num2str(info.ap)]);
disp(['True negative rate: ',num2str(TNR)]);

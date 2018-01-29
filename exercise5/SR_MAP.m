function SR_MAP
    %loads LRImages (lowres images) and motionParams (homographies)
    load('lowResData.mat');
    sz=size(LRImages);
    scale=3;
    lrel=prod(sz(1:2));%the vector size of the lowres image vector
    psf=.6;
    K=20;%number of images
    Wk=cell(K,1);
    yk=cell(K,1);
    Wk{1}=composeSystemMatrix(sz(1:2),scale,psf,cell2mat(motionParams(1)));
    W=Wk{1};
    yk{1}=imageToVector(LRImages(:,:,1));
    y=yk{1};
    for i=2:K
        H=cell2mat(motionParams(i));%homography of image i
        Wk{i}=composeSystemMatrix(sz(1:2),scale,psf,H);
        W=cat(1,W,Wk{i});        
        %W is the big matrix which goes from hires image to homographed lowres image
        yk{i}=imageToVector(LRImages(:,:,i));
        y=cat(1,y,yk{i});
    end
    x1=imageToVector(imresize(LRImages(:,:,2),scale));
    x2=x1;
    x3=x1;
    stepsize=.05;
    %h = waitbar(0,'Maximum likelihood estimation');
    fx1=[];fx2=[];fx3=[];
    
    %for maximum a posteriori
    qu=build_q(size(x1,1),1);
    qv=build_q(size(x1,1),size(LRImages,2));
    
    
    for i=1:50
       %using steepest decent
       p1=-2*W'*(y-W*x1);
       x1=x1-stepsize*p1;
       subplot(2,3,1); imshow(vectorToImage(x1,sz(1:2)*scale));
       fx1=[fx1,norm(y-W*x1)^2];

       %using Zomets method
       gk=zeros(lrel*scale*scale,K);
       for k=1:K
        gk(:,k)=-2*Wk{k}'*(yk{k}-Wk{k}*x2);
       end
       p2=K*median(gk,2);
       x2=x2-stepsize*p2;
       subplot(2,3,2); imshow(vectorToImage(x2,sz(1:2)*scale));
       fx2=[fx2,norm(y-W*x2)^2];
       fprintf('x');
       
       %using maximum a-posteriori
       lm=.0002;
       rx=norm((qu+qv)*x3)^2;
       p3=p1+lm*sqrt(norm(qu*x3)^2+norm(qv*x3)^2);
       x3=x3-stepsize*p3;
       fx3=[fx3,norm(y-W*x3)^2+lm*norm((qu+qv)*x3)^2];
       subplot(2,3,3); imshow(vectorToImage(x3,sz(1:2)*scale));
       
       
       subplot(2,3,[4 6]);
       plot(fx1,'color','blue');
       hold on; 
       %plot(fx3,'color','blue');
       %hold off;
       drawnow;

    end
    
    
end


function vec=imageToVector(ima)
    sz=size(ima);x=sz(1);y=sz(2);
    vec=reshape(ima',1,x*y)';
end

function ima=vectorToImage(vec,sz)
    ima=reshape(vec,sz(2),sz(1),numel(vec)/(sz(1)*sz(2)))';
end

function q=build_q(N,offset)
    q=sparse(N,N);
    for i=1:N
        q(i,i)=1;
        if i+offset<=N 
            q(i,i+offset)=-1;
        end
    end
end
function drawSegSuperPixel()

HOME = './';
dataBases = {'STAN','MSRC','CORE','SIFT'};
selDB = dataBases{1};

imgFold = [HOME selDB 'img/'];
gtFold = [HOME selDB 'labels/'];
matFold = [HOME selDB 'mat/'];
drawSuperFold = [HOME selDB 'drawSuper/'];

if ~exist(drawSuperFold,'dir')
    mkdir(drawSuperFold);
end

ImgDir=dir([imgFold '*.jpg']);
lenImg = length(ImgDir);
for iImg = 1:lenImg
    fprintf('%d\n',iImg);
    iImgName = ImgDir(iImg).name;
    load([matFold iImgName(1:end-4) '_segFeatCV1.mat']);
    
    I = imread([imgFold iImgName]);
    [H, W] = size(superPixels);
    
    tH = H - 1;
    tW = W - 1;
    outI = I;
    for j = 2:tH
        jBeg = j-1;
        jEnd = j+1;
        for k = 2:tW
            kBeg = k-1;
            kEnd = k+1;
            curBlockSegLabel = superPixels(jBeg:jEnd,kBeg:kEnd);
            uniqBlockSegLabel = unique(curBlockSegLabel(:));
            if length(uniqBlockSegLabel)>1
                outI(j,k,:) = [255 0 0];
            end
        end
    end
    imwrite(outI, [drawSuperFold iImgName]);
end
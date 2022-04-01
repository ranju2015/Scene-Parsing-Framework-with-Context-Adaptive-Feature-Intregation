function getSuperPixelFeature(imgFold,gtFold,matFold,allImgList,centers,kVal,selDB,iCV)
% calculate superpixel features.

lenImg = length(allImgList);
for iImg = 1:lenImg
    iImgName = allImgList{iImg}; 
    if ~exist(([matFold iImgName(1:end-4) '_segFeatCV' num2str(iCV) '.mat']),'file')
        %fprintf('Image No %d: %s\n',iImg,iImgName);
        im = imread([imgFold iImgName]);        
        [nHeight,nWidth,nChannel] = size(im);
        %force it to have 3 channels
        if(nChannel==1)
            im = repmat(im,[1 1 3]);
        end
        
        %superPixels = GenerateSuperPixels(im,kVal);
        superPixels = superpixels(im,kVal); % create 512 images
        superPixInd = unique(superPixels);
        superLen = length(superPixInd);
        
        %find the adjacency graph between superpixels
        adjPairs = FindSPAdjacnecy(superPixels);
        
        % read pixel ground truths
        segFileName = [gtFold iImgName(1:end-4) '.regions.txt'];
        imgGT = importdata(segFileName);
        
        switch selDB
            case {'STAN','MSRC','CORE'}
                imgGT = imgGT + 1;          % GT: [-1 20] -> [0 21], not need for 'SIFT','CAMV' datasets.                                            
        end 
        
        [gtHeight, gtWidth] = size(imgGT);
        if (gtHeight~=nHeight || gtWidth~=nWidth)
            fprintf('image size is unequal to grounth truth size!');
            break;
        end
        
        % get superpixel ground truths.
        colSuper = superPixels(:);
        colGT = imgGT(:);
        segGT = -1*ones(superLen,1);
        for i = 1 : superLen
            segGT(i) = mode(colGT(colSuper==superPixInd(i)));
        end
        clear colSuper colGT;
        
        textons = [];
        textons.mr_filter = mr_filter( im, centers);
        textons.sift_textons = sift_textons( im, centers);
        
        segFeatLen = 1000;   % set to be large enough.
        segFeat = zeros(superLen,segFeatLen,'single');
        for j = 1:superLen
            mask = superPixels==superPixInd(j);
            [foo, borders, bb] = get_int_and_borders(mask);
            borders = borders(bb(1):bb(2),bb(3):bb(4),:);
            maskCrop = mask(bb(1):bb(2),bb(3):bb(4));
            imCrop = im(bb(1):bb(2),bb(3):bb(4),:);
            
            textonsCrop = textons;
            textonsCrop.mr_filter = textons.mr_filter(bb(1):bb(2),bb(3):bb(4));
            textonsCrop.sift_textons = textons.sift_textons(bb(1):bb(2),bb(3):bb(4));
            
            spDesc = sift_hist_int_(imCrop,mask,maskCrop,bb,centers,textonsCrop,borders,im);
            featAcc = 1;
            segFeat(j,featAcc:featAcc+length(spDesc(:))-1) = spDesc(:);
            featAcc = featAcc+length(spDesc(:));
            
            spDesc = sift_hist_dial(imCrop,mask,maskCrop,bb,centers,textonsCrop,borders,im);
            segFeat(j,featAcc:featAcc+length(spDesc(:))-1) = spDesc(:);
            featAcc = featAcc+length(spDesc(:));
            
            spDesc = int_text_hist_mr(imCrop,mask,maskCrop,bb,centers,textonsCrop,borders,im);
            segFeat(j,featAcc:featAcc+length(spDesc(:))-1) = spDesc(:);
            featAcc = featAcc+length(spDesc(:));
            
            spDesc = dial_text_hist_mr(imCrop,mask,maskCrop,bb,centers,textonsCrop,borders,im);
            segFeat(j,featAcc:featAcc+length(spDesc(:))-1) = spDesc(:);
            featAcc = featAcc+length(spDesc(:));
            
            spDesc = mean_color(imCrop,mask,maskCrop,bb,centers,textonsCrop,borders,im);
            segFeat(j,featAcc:featAcc+length(spDesc(:))-1) = spDesc(:);
            featAcc = featAcc+length(spDesc(:));
            
            spDesc = color_std(imCrop,mask,maskCrop,bb,centers,textonsCrop,borders,im);
            segFeat(j,featAcc:featAcc+length(spDesc(:))-1) = spDesc(:);
            featAcc = featAcc+length(spDesc(:));
            
            spDesc = color_hist(imCrop,mask,maskCrop,bb,centers,textonsCrop,borders,im);
            segFeat(j,featAcc:featAcc+length(spDesc(:))-1) = spDesc(:);
            featAcc = featAcc+length(spDesc(:));
            
            spDesc = dial_color_hist(imCrop,mask,maskCrop,bb,centers,textonsCrop,borders,im);
            segFeat(j,featAcc:featAcc+length(spDesc(:))-1) = spDesc(:);
            featAcc = featAcc+length(spDesc(:));
            
            spDesc = top_height(imCrop,mask,maskCrop,bb,centers,textonsCrop,borders,im);
            segFeat(j,featAcc:featAcc+length(spDesc(:))-1) = spDesc(:);
            featAcc = featAcc+length(spDesc(:));
            
            spDesc = absolute_mask(imCrop,mask,maskCrop,bb,centers,textonsCrop,borders,im);
            segFeat(j,featAcc:featAcc+length(spDesc(:))-1) = spDesc(:);
            featAcc = featAcc+length(spDesc(:));
        end
        
        segFeat = segFeat(:,1:featAcc-1);
        save([matFold iImgName(1:end-4) '_segFeatCV' num2str(iCV) '.mat'],'segFeat','segGT','imgGT','adjPairs','superPixels');
    end
end
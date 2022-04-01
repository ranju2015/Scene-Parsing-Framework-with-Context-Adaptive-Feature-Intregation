function sumLocPriorMap = getLocPriorMap(matFold,allImgList,testImgIdx,numClass,blockrow,iCV)

if exist(([matFold 'locPriorMapCV' num2str(iCV) 'Block' num2str(blockrow) '.mat']),'file')  % note this is for all images.
    load([matFold 'locPriorMapCV' num2str(iCV) 'Block' num2str(blockrow) '.mat'],'locPriorMap');
else
    numBlock = blockrow*blockrow;
    lenImg = length(allImgList);
    locPriorMap = cell(lenImg,1);
    
    for iImg = 1:lenImg   % note this is for all images.
        iImgName = allImgList{iImg};
        %fprintf('.');
        
        load([matFold iImgName(1:end-4) '_segFeatCV' num2str(iCV) '.mat'],'segFeat','segGT','imgGT','adjPairs','superPixels');
            
        % read pixel ground truths
%         segFileName = [gtFold iImgName(1:end-4) '.txt'];
%         imgGT = importdata(segFileName);
%         imgGT = imgGT + 1;
        [gtHeight, gtWidth] = size(imgGT);
        
        blockIdx = zeros(gtHeight,gtWidth,'uint8');
        oneUnitHeight = ceil(gtHeight/blockrow);
        oneUnitWidth = ceil(gtWidth/blockrow);
        for j = 1:gtHeight
            HIdx = ceil(j/oneUnitHeight);
            for k = 1:gtWidth
                WIdx = ceil(k/oneUnitWidth);
                blockIdx(j,k) = (HIdx-1)*blockrow + WIdx;
            end
        end
        blockIdx = blockIdx(:);
        
        colGT = imgGT(:);        
        tempClassCount = zeros(numBlock,numClass,'uint32');
        for i = 1:numBlock
            iBlockGT = colGT(blockIdx==i);  
            iBlockGT = iBlockGT(iBlockGT>0);  % not consider 0 GT.
            
            if length(iBlockGT)<30  % block contains too little valid pixels.
                continue;
            end
            
            uniqueGT = unique(iBlockGT);
            %GTCount = histcounts(iBlockGT(:),uniqueGT);
            GTCount = histc(iBlockGT(:),uniqueGT);
            lenUniGT = length(uniqueGT);
            for j = 1 : lenUniGT
                tempClassCount(i,uniqueGT(j)) = GTCount(j);
            end
        end
        locPriorMap{iImg} = tempClassCount;
        %locPriorMap(iImg,:,:) = tempClassCount;
    end
    save([matFold 'locPriorMapCV' num2str(iCV) 'Block' num2str(blockrow) '.mat'],'locPriorMap');
end

if exist(([matFold 'sumLocPriorMapCV' num2str(iCV) 'Block' num2str(blockrow) '.mat']),'file')
    load([matFold 'sumLocPriorMapCV' num2str(iCV) 'Block' num2str(blockrow) '.mat'],'sumLocPriorMap');
else
    lenImg = length(allImgList);
    numBlock = blockrow*blockrow;
    %sumLocPriorMap = zeros(numBlock,numClass,numBlock,numClass,'single');
    sumLocPriorMap = cell(numBlock,numClass,numBlock);
    for iBlk = 1:numBlock
        for iCls = 1 : numClass
            Ttemp = zeros(numBlock,numClass,'double');
            for iImg = 1 : lenImg
                if ~ismember(iImg,testImgIdx)  % training images;
                    iImgMap = locPriorMap{iImg};
                    iClassCount = iImgMap(iBlk,iCls);                    
                    if iClassCount ==0
                        continue;
                    end
                    
                    for i = 1:numBlock
                        Ttemp(i,:) = Ttemp(i,:) + double(iClassCount*iImgMap(i,:));
                    end
                end
            end
            %sumLocPriorMap{iBlk}{iCls} = Ttemp;
            
            for i = 1 : numBlock
                TT = Ttemp(i,:);
                if sum(TT)>30
                    sumLocPriorMap{iBlk}{iCls}{i} = TT/sum(TT);
                else
                    sumLocPriorMap{iBlk}{iCls}{i} = 0;
                end
            end
        end
    end
    save([matFold 'sumLocPriorMapCV' num2str(iCV) 'Block' num2str(blockrow) '.mat'],'sumLocPriorMap');
end

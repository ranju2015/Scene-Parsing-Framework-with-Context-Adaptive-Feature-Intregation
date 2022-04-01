function adjSuperPixelOcc = getAdjSuperPixelOcc(matFold,allImgList,testImgIdx,numClass,iCV)

if exist(([matFold 'adjSuperPixelOccCV' num2str(iCV) '.mat']),'file')
    load([matFold 'adjSuperPixelOccCV' num2str(iCV) '.mat'],'adjSuperPixelOcc');
else
    adjSuperPixelOcc = zeros(numClass,numClass,'single');
    %adjSuperPixelOcc_2 = zeros(numClass,numClass,'single'); %basim
    lenImg = length(allImgList);
    for iImg = 1:lenImg
        if ~ismember(iImg,testImgIdx)  % training images;
            %adjSuperPixelOcc_2 = zeros(numClass,numClass,'single'); %basim
            iImgName = allImgList{iImg};
            %fprintf('Image No %d: %s\n',iImg,iImgName);
            load([matFold iImgName(1:end-4) '_segFeatCV' num2str(iCV) '.mat'],'segFeat','segGT','imgGT','adjPairs','superPixels');
            
            pairNum = size(adjPairs,1);
            for i = 1 : pairNum
                curSPGT = segGT(adjPairs(i,1));
                curAdjGT = segGT(adjPairs(i,2));
                if curSPGT>0 && curAdjGT>0
                    adjSuperPixelOcc(curSPGT,curAdjGT) = adjSuperPixelOcc(curSPGT,curAdjGT) + 1;
                    %adjSuperPixelOcc_2(curSPGT,curAdjGT) = adjSuperPixelOcc_2(curSPGT,curAdjGT) + 1;
                    
                end
            end
            % Save Super Pixel Adjacency Graph
            %save([tarFold iImgName(1:end-4) '_SPAG' num2str(iCV) '.mat'],'adjSuperPixelOcc_2'); %basim

        end
    end
    
    % occ -> probablity
    for iCls = 1 : numClass
        iClsOcc = adjSuperPixelOcc(iCls,:);
        adjSuperPixelOcc(iCls,:) = iClsOcc/sum(iClsOcc);
    end
    save([matFold 'adjSuperPixelOccCV' num2str(iCV) '.mat'],'adjSuperPixelOcc'); 
    %save([matFold 'adjSuperPixelOccCV' num2str(iCV) '.mat'],'adjSuperPixelOcc','adjSuperPixelOcc_2');%basim
end
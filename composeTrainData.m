function [trainSegFeat,trainSegGT] = composeTrainData(matFold,allImgList,testImgIdx,iCV)

if exist(([matFold 'trainSegFeat_CV' num2str(iCV) '.mat']),'file')
    load([matFold 'trainSegFeat_CV' num2str(iCV) '.mat'],'trainSegFeat','trainSegGT');
else
    trainSegFeat = [];
    trainSegGT = [];
    lenImg = length(allImgList);
    for iImg = 1:lenImg
        if ~ismember(iImg,testImgIdx)  % training images;
            iImgName = allImgList{iImg};
            load([matFold iImgName(1:end-4) '_segFeatCV' num2str(iCV) '.mat'],'segFeat','segGT','imgGT','adjPairs','superPixels');
%             load([matFold iImgName(1:end-4) '.mat'],'segFeat','segGT','imgGT','adjPairs','superPixels');

            trainSegFeat = [trainSegFeat; segFeat];
            trainSegGT = [trainSegGT; segGT];
        end
    end
    
    % remove superpixels with invalid GT.
    validGTIdx = find(trainSegGT>0);
    trainSegGT = trainSegGT(validGTIdx);
    trainSegFeat = trainSegFeat(validGTIdx,:);
    save([matFold 'trainSegFeat_CV' num2str(iCV) '.mat'],'trainSegFeat','trainSegGT');   
end
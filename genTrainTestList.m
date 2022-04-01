function [allImgList, testImgIdxCV,testImgLenCV] = genTrainTestList(imgFold,matFold,numCV)
% generate training/test image lists.

allImgList = dir_recurse(fullfile(imgFold,'*.jpg'),0);

if exist(([matFold 'testImgIdxCV.mat']),'file')
    load([matFold 'testImgIdxCV.mat'],'testImgIdxCV','testImgLenCV');
else
    lenImg = length(allImgList);
    testImgLen = round(lenImg/numCV);
    ranImgIdx = randperm(lenImg);

    testImgIdxCV = zeros(numCV,testImgLen,'uint16');
    testImgLenCV = zeros(numCV,1,'uint16');
    for icv = 1 : numCV
        tmpSelIdx = [(icv-1)*testImgLen+1 : min(icv*testImgLen,lenImg)];
        testImgIdxCV(icv,1:length(tmpSelIdx)) = ranImgIdx(tmpSelIdx);
        testImgLenCV(icv) = length(tmpSelIdx);
    end
    save([matFold 'testImgIdxCV.mat'],'testImgIdxCV','testImgLenCV');
end

    

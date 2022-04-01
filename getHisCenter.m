function centers = getHisCenter(imgFold,matFold,allImgList,testImgIdx,dictionarySize,iCV)

if exist(([matFold 'centersCV' num2str(iCV) '.mat']),'file')
    load([matFold 'centersCV' num2str(iCV) '.mat'],'centers');
else
    %dictionarySize = 100;    
    centers = [];
    centers.mr_resp_centers = mr_resp_centers(allImgList, imgFold, testImgIdx,dictionarySize);
    centers.sift_centers = sift_centers(allImgList, imgFold, testImgIdx,dictionarySize);
    save([matFold 'centersCV' num2str(iCV) '.mat'],'centers');
end
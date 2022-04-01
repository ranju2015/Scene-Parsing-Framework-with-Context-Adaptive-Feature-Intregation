%The new version named 'create_test_feature_GA' will create test file as
%well as separte classwise test file for GA experiment

function create_test_feature_GA(matFold,allImgList,testImgIdx,numClass,selClf,selInt,SelFeaIdx,sumLocPriorMap,adjSuperPixelOcc,blockrow,sta,iCV)

    if exist(([matFold 'allCombProTest_' selClf 'CV_' num2str(iCV) 'Block' num2str(blockrow) '.mat']),'file')
        load([matFold 'allCombProTest_' selClf 'CV_' num2str(iCV) 'Block' num2str(blockrow) '.mat'],'allCombTestPro','allSegTestGT');
    else
        allCombTestPro = [];
        allSegTestGT = [];
        lenImg = length(allImgList);
        for iImg = 1:lenImg
            if  ismember(iImg,testImgIdx)  % training images;
                iImgName = allImgList{iImg};
                %fprintf('Image No %d: %s\n',iImg,iImgName);
                load([matFold iImgName(1:end-4) '_segFeatCV' num2str(iCV) '.mat'],'segFeat','segGT','imgGT','adjPairs','superPixels'); 
                nSeg = size(segFeat,1);         

                % get classifier probabilites.
                segProbMap = getSupClassifierPro(matFold,segFeat,SelFeaIdx,nSeg,numClass,selClf,sta,iCV);         

                % get neighouring block votes.
                blkVotes = getNeigBlockVote(sumLocPriorMap,superPixels,imgGT,segProbMap,blockrow,nSeg,numClass);

                % get neighouring superpixel occurance
                negSPocc = getNeigSupOcc(adjSuperPixelOcc,adjPairs,segGT,nSeg,numClass);               

                combinedPro = [segProbMap blkVotes negSPocc];

                allCombTestPro = [allCombTestPro; combinedPro];
                allSegTestGT = [allSegTestGT; segGT];
            end
        end
        save([matFold 'allCombProTest_' selClf '_CV_' num2str(iCV) '_Block_' num2str(blockrow) '.mat'],'allCombTestPro','allSegTestGT');
    end

 
    matFold_new ='TestMatClasswiseGA/';
    if ~exist(matFold_new,'dir')
        mkdir(matFold_new);
    end
    for iCls = 1 : numClass
        binAllSegTestGT = zeros(length(allSegTestGT),1,'single');
        binAllSegTestGT(allSegTestGT==iCls) = 1;
        iClsProIdx = [iCls iCls+numClass iCls+2*numClass];
        iClsCombTestPro = allCombTestPro(:,iClsProIdx);
        save([matFold_new 'allCombProTest_' selClf '_CV_' num2str(iCV) '_Block_' num2str(blockrow) '_iCls_' num2str(iCls) '.mat'],'iClsCombTestPro','binAllSegTestGT');
    end
end
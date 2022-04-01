function SuperpixelData()
    % run the results on 21-class MSRC data.
    HOME = './';
    addpath(genpath(HOME));

    dataBases = {'STAN','MSRC','CORE','SIFT','CAMV','CS'}; %CS-CityScapes
    selDB = dataBases{6};

    imgFold = [HOME selDB 'Data/'];
    gtFold = [HOME selDB 'Label/'];
    matFold = [HOME selDB 'Mat/'];
    tarFold = [HOME selDB 'SPAG/'];    %SuperPixel Adjacency Graph

    switch selDB
        case 'STAN'
            numClass = 8;  % [0 7]: {'sky', 'tree', 'road', 'grass', 'water', 'building', 'mountain','foreground'};
        case 'MSRC'        
            numClass = 21;  % [0 20]:   %building,Grass,Tree,Cow,Sheep,Sky,Aeroplane,Water,Face,Car,Bicycle,Flower,Sign,Bird,Book,Chair,Road,Cat%,Dog,Body,Boat.
        case 'CORE'
            numClass = 7;
        case 'SIFT'
            numClass = 33;
        case 'CAMV'
            numClass = 11; % 30; % [0 11]:    %Void,Building,Tree,Sky,Car,Sign-Symbol,Road,Pedestrian,Fence,Column-Pole,Sidewalk,Bicyclist.
        case 'CS'
            numClass = 19;
    end

    classifiers = {'ANN','SVM','ADB','RDF','CNN'};
    selClf = classifiers{2};

    Integration_Layer = {'Linear','Non_linear','SVM','MLP','R-Ensemble'};   % Options for Integration Layer (Regression)
    selInt = Integration_Layer{4};

    %% paramters setting %% Feat_and_Label_SVM_1
    Kval = 256;         % control number of superpixels.
    blockRow = 6 ;      % image divided into 6*6 blocks (location prior).
    numCV = 5;
    iCV = 1;
    %% end paramters setting %% 

    %% generate training/test image lists.
    fprintf('generate train/test image lists\n');
    switch selDB
        case {'STAN','MSRC','CORE'}
            [allImgList, testImgIdxCV,testImgLenCV] = genTrainTestList(imgFold,matFold,numCV);
            testImgIdx = testImgIdxCV(iCV,1:testImgLenCV(iCV));
        case {'SIFT','CAMV','CS'}
            [allImgList, testImgIdx] = genTrainTestListSIFT(imgFold,matFold);
    end

    %% get superpixel features
    if 1
        fprintf('get the centers for histogram\n');
        dictionarySize = 100;   
        centers = getHisCenter(imgFold,matFold,allImgList,testImgIdx,dictionarySize,iCV);
        
        fprintf('calculate superpixel features\n');
        getSuperPixelFeature(imgFold,gtFold,matFold,allImgList,centers,Kval,selDB,iCV);
    end

    fprintf('Compose training data\n');
    [trainSegFeat,trainSegGT] = composeTrainData(matFold,allImgList,testImgIdx,iCV);

    %fprintf('Feature selection\n');
    selFeatLen = 50;   % number of selected features.
    %featureSel is not in use as GA-based feature selection is employed in trainClassifier
    %However, SelFeaIdx has been used as parameters in few of the following functions
    SelFeaIdx = featureSel(matFold,trainSegFeat,trainSegGT,numClass,selFeatLen,iCV);

    fprintf('Train class-specific classifiers\n');
    %sta = trainClassifer(matFold,trainSegFeat,trainSegGT,numClass,SelFeaIdx,selClf,iCV);
    %GA-based feature selection is employed in trainClassfierV2GA
    sta = trainClassiferV2GA(matFold,trainSegFeat,trainSegGT,numClass,selClf,iCV); 

    fprintf('get adj superpixel occurance\n');
    adjSuperPixelOcc = getAdjSuperPixelOcc(matFold,allImgList,testImgIdx,numClass,iCV); %tarfold removed

    fprintf('get location prior map\n');
    sumLocPriorMap = getLocPriorMap(matFold,allImgList,testImgIdx,numClass,blockRow,iCV);

    fprintf('logistic regression on training images\n');
    %coef = logistRegTrainData(matFold,allImgList,testImgIdx,numClass,selClf,selInt,SelFeaIdx,sumLocPriorMap,adjSuperPixelOcc,blockRow,sta,iCV);
    load('coefCV1Block6.mat');

    fprintf('Evaluation on testing images\n');
    evaTestImg(matFold,allImgList,testImgIdx,numClass,selClf,selInt,selDB,SelFeaIdx,sumLocPriorMap,adjSuperPixelOcc,coef,blockRow,sta,iCV);

    % fprintf('Creating Test Feature for GA-method\n');
    % create_test_feature_GA(matFold,allImgList,testImgIdx,numClass,selClf,selInt,SelFeaIdx,sumLocPriorMap,adjSuperPixelOcc,blockRow,sta,iCV);
end



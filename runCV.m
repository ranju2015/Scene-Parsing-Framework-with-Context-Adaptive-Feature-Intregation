function runCV()

if 0
    SuperpixelData(2);
    SuperpixelData(8);
    SuperpixelData(10);
    SuperpixelData(12);
end

%SuperpixelData(1);
if 1
    for iCV = 1 : 5
        SuperpixelData(iCV);
    end
end

if 0
    blockrow = 6 ;
    numCV = 5;
    classifierAcc = zeros(numCV,1,'single');
    spBlockVoteAcc = zeros(numCV,1,'single');
    ngSuperOccAcc = zeros(numCV,1,'single');
    regressAcc = zeros(numCV,1,'single');
    for iCV = 1 : numCV
        %matFold = './MSRCMat/';
        %matFold = './STANMat8/';
        matFold = './MSRCMatSVM/';
        %load([matFold 'ClsOutPutCV' num2str(iCV) '.mat'],'allGT','allPL','allPL1','allPL2','allPL3');
        load([matFold 'ClsOutPutCV' num2str(iCV) 'Block' num2str(blockrow) '.mat'],'allGT','allPL','allPL1','allPL2','allPL3');
        
        
        classifierAcc(iCV) = mean(allGT==allPL);
        %formConfusionM(allGT,allPL)
        
        
        spBlockVoteAcc(iCV) = mean(allGT==allPL1);
        %formConfusionM(allGT,allPL1)
        
        ngSuperOccAcc(iCV) = mean(allGT==allPL2);
        %formConfusionM(allGT,allPL2)
        
        
        regressAcc(iCV) = mean(allGT==allPL3);
        %formConfusionM(allGT,allPL3)
    end
    fprintf('Acc using ANN/SVM classifier:\n');
    mean(classifierAcc)
    std(classifierAcc)
    min(classifierAcc)
    max(classifierAcc)
    
    fprintf('\nAcc using spatial block voting:\n');
    mean(spBlockVoteAcc)
    std(spBlockVoteAcc)
    min(spBlockVoteAcc)
    max(spBlockVoteAcc)
    
    fprintf('\n Acc using neighouring superpixel occurance:\n');
    mean(ngSuperOccAcc)
    std(ngSuperOccAcc)
    min(ngSuperOccAcc)
    max(ngSuperOccAcc)
    
    fprintf('\nAcc using logistic regression on all probabilities:\n');
    mean(regressAcc)
    std(regressAcc)
    min(regressAcc)
    max(regressAcc)
end

if 0
    GT = [];
    PL = [];
    PL1 = [];
    PL2 = [];
    PL3 = [];
    blockrow = 6 ;
    numClass = 21 ;
    for iCV = 1 : 5
        matFold = './MSRCMatSVM/';
        %matFold = './STANMatSVM/';
        %load([matFold 'ClsOutPutCV' num2str(iCV) '.mat'],'allGT','allPL','allPL1','allPL2','allPL3');
        load([matFold 'ClsOutPutCV' num2str(iCV) 'Block' num2str(blockrow) '.mat'],'allGT','allPL','allPL1','allPL2','allPL3');
        
        GT = [GT;allGT];
        PL = [PL;allPL];
        PL1 = [PL1;allPL1];
        PL2 = [PL2;allPL2];
        PL3 = [PL3;allPL3];
    end
    
    fprintf('Acc using ANN/SVM classifier (all CV):\n');
    pixelACC = mean(GT==PL)
    mat1 = formConfusionM(GT,PL)
    aa = 0;
    for i = 1 : numClass
        aa = aa + mat1(i,i);
    end
    classACC = aa/numClass
    
    fprintf('Acc using spatial block voting (all CV):\n');
    pixelACC = mean(GT==PL1)
    mat2 = formConfusionM(GT,PL1)
    aa = 0;
    for i = 1 : numClass
        aa = aa + mat2(i,i);
    end
    classACC = aa/numClass
    
    fprintf('Acc using neighouring superpixel occurance (all CV):\n');
    pixelACC = mean(GT==PL2)
    mat3 = formConfusionM(GT,PL2)
    aa = 0;
    for i = 1 : numClass
        aa = aa + mat3(i,i);
    end
    classACC = aa/numClass
    
    fprintf('Acc using logistic regression on all probabilities (all CV):\n');
    pixelACC = mean(GT==PL3)
    mat4 = formConfusionM(GT,PL3)
    aa = 0;
    for i = 1 : numClass
        aa = aa + mat4(i,i);
    end
    classACC = aa/numClass
end

if 0
    matFold = './SIFTMatSVM/';
    %matFold = './STANMat/';
    blockrow = 6 ;
    iCV = 1;
    numClass = 33;
    allAcc = zeros(numClass,1,'single');
    load([matFold 'ClsOutPutCV' num2str(iCV) 'Block' num2str(blockrow) '.mat'],'allGT','allPL','allPL1','allPL2','allPL3');
    if 0
        for i = 1 : numClass
            if length(allPL1(allGT==i))>0
                allAcc(i) = mean(allGT(allGT==i) == allPL1(allGT==i));
            else
                allAcc(i) = 0;
            end
        end
        mean(allAcc)
    end
    
    if 0
        mean(allGT==allPL)
        mean(allGT==allPL1)
        mean(allGT==allPL2)
        mean(allGT==allPL3)
    end
    
    if 1
        pixelACC = mean(allGT==allPL3)
        mat4 = formConfusionM(allGT,allPL3)
        aa = 0;
        for i = 1 : numClass
            aa = aa + mat4(i,i);
        end
        classACC = aa/numClass
    end
end

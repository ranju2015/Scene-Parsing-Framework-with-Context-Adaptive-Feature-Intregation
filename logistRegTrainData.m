function coef = logistRegTrainData(matFold,allImgList,testImgIdx,numClass,selClf,selInt,SelFeaIdx,sumLocPriorMap,adjSuperPixelOcc,blockrow,sta,iCV)

if exist(([matFold 'allCombProCV' num2str(iCV) 'Block' num2str(blockrow) '.mat']),'file')
    load([matFold 'allCombProCV' num2str(iCV) 'Block' num2str(blockrow) '.mat'],'allCombPro','allSegGT');
else
    allCombPro = [];
    allSegGT = [];
    lenImg = length(allImgList);
    for iImg = 1:lenImg
        if ~ismember(iImg,testImgIdx)  % training images;
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
            
            allCombPro = [allCombPro; combinedPro];
            allSegGT = [allSegGT; segGT];
        end
    end
    save([matFold 'allCombProCV' num2str(iCV) 'Block' num2str(blockrow) '.mat'],'allCombPro','allSegGT');
end


coef = [];
coef2 = [];
coef3 = [];
coef4 = [];
%coef = zeros(numClass,3+1,'single');
    
for iCls = 1 : numClass
    binAllSegGT = zeros(length(allSegGT),1,'single');
    binAllSegGT(allSegGT==iCls) = 1;
    iClsProIdx = [iCls iCls+numClass iCls+2*numClass];
    iClsCombPro = allCombPro(:,iClsProIdx);

    %save training feature and label
    save([matFold 'Feat_and_Label_' selClf '_' num2str(iCls) '.mat'],'iClsCombPro','binAllSegGT');   %% added by RM

    if strcmp(selInt,'Linear') % FITGLM 
        coef(iCls,:) = glmfit(iClsCombPro,binAllSegGT);
       
        
    elseif strcmp(selInt,'Non_linear') % FITNLM
        
    
        x = iClsCombPro;
        y = binAllSegGT;
    
        rng('default') % for reproducibility
        modelfun = @(b,x)b(1)*x(:,1).^3+b(2)*x(:,2).^2+b(3)*x(:,3).^1;
        beta0 =rand(3,1);
        CVMdl = fitnlm(x,y,modelfun,beta0)  
        coef4{iCls}=CVMdl;
    
    
    elseif strcmp(selInt,'SVM') %
        
        x = iClsCombPro;
        y = binAllSegGT;
        CVMdl = fitrsvm(x,y);  
        coef4{iCls}=CVMdl;


    elseif strcmp(selInt,'MLP') 
      
        x = iClsCombPro;
        y = binAllSegGT;
        %net = feedforwardnet(16);  % 16 Hidden Neurons
        net = patternnet(16);
        net.trainParam.showCommandLine = true;
        net.divideFcn = 'dividerand';
        net.divideParam.trainRatio = 1;
        net.divideParam.valRatio = 0;
        net.divideParam.testRatio = 0;
        %net.performFcn='mse';
        %net.trainParam.goal=0.001;
        net.trainParam.epochs=300;
        net.trainParam.min_grad = 1e-8;  % default: 1e-5. If the magnitude of the gradient is less than 1e-5, training stops.
        net.trainParam.max_fail = 10;   %default: 6. If this number reaches 6, the training will stop.
        
        net = configure(net,double(x'),double(y')); 
        net = init(net);
        [net,tr] = train(net,double(x'),double(y'));  
        coef4{iCls}=net;
    
    
    elseif strcmp(selInt,'R-Ensemble') 
   
		% The ensemble aggregation algorithm is 'LSBoost' % Least Squares for Boosting.
		% One hundred trees compose the ensemble.
    
        coefr = fitrensemble(iClsCombPro,binAllSegGT);
        coef4{iCls}=coefr;
       
    else
        fprintf('Incorrect Integration Method Choosen!\n');
    end
    
end
fprintf('coef from trainig data:\n');
%coef2
save([matFold 'coefCV' num2str(iCV) 'Block' num2str(blockrow) '.mat'],'coef','coef4');
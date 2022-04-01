function SelFeaIdx = featureSel(matFold,trainSegFeat,trainSegGT,numClass,selFeatLen,iCV)

if exist([matFold 'SelFeaIdx_CV' num2str(iCV) '.mat'],'file')
    load([matFold 'SelFeaIdx_CV' num2str(iCV) '.mat'],'SelFeaIdx');
    
    %load([matFold 'SelFeaIdx__custom50_CV' num2str(iCV) '.mat'],'SelFeaIdx_2');
    %SelFeaIdx = SelFeaIdx_2;
else 
    % numClass = length(classLabels);
    segDisFeat = dataDiscret(trainSegFeat);    
    
    SelFeaIdx_2 = zeros(numClass,size(segDisFeat,2),'uint16');
    for i = 1 : numClass
        
        
        binSegGT = zeros(length(trainSegGT),1);
        binSegGT(trainSegGT==i)=1;
        
        %comment by basim
        SelFeaIdx(i,:) = mrmr_miq_d(double(segDisFeat), binSegGT, selFeatLen);
        
        
   %  [SelFeaIdx(i,:), W(i,:)] = reliefF(trainSegFeat, binSegGT, 20);


        
        
        %SelFeaIdx(i,:) = fscmrmr(double(segDisFeat), binSegGT);
        
           %SelFeaIdx(i,:) = isomap(double(trainSegFeat),2,selFeatLen);
                %LDA
       % SelFeaIdx = tsne(double(trainSegFeat),'NumDimensions',8);
                %mdl = fscnca(double(segDisFeat), binSegGT,'Solver','sgd','Verbose',1);


    
    
    end
    
    
    save([matFold 'SelFeaIdx_CV' num2str(iCV) '.mat'],'SelFeaIdx');
end
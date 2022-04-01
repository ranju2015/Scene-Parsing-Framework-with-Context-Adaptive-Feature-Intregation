function evaTestImg(matFold,allImgList,testImgIdx,numClass,selClf,selInt,selDB,SelFeaIdx,sumLocPriorMap,adjSuperPixelOcc,coef,blockrow,sta,iCV)

allGT = [];
allPL = [];
allPL1 = [];
allPL2 = [];
allPL3 = [];
lenImg = length(allImgList);

for iImg = 1:lenImg
    if ismember(iImg,testImgIdx)  % testing images;
        iImgName = allImgList{iImg};
        fprintf('.');
        %fprintf('Image No %d: %s\n',iImg,iImgName);
        load([matFold iImgName(1:end-4) '_segFeatCV' num2str(iCV) '.mat'],'segFeat','segGT','imgGT','adjPairs','superPixels');
        
        nSeg = size(segFeat,1);
        
        % get classifier probabilites.
        segProbMap = getSupClassifierPro(matFold,segFeat,SelFeaIdx,nSeg,numClass,selClf,sta,iCV);
        
        % get neighouring block votes.
        blkVotes = getNeigBlockVote(sumLocPriorMap,superPixels,imgGT,segProbMap,blockrow,nSeg,numClass);
        
        % get neighouring superpixel occurance
        negSPocc = getNeigSupOcc(adjSuperPixelOcc,adjPairs,segGT,nSeg,numClass);
        
% % %         segFeat = segFeat-repmat(sta.mean,[nSeg,1]);
% % %         segFeat = segFeat./repmat(sta.std + ~sta.std,[nSeg,1]);
% % %         segProbMap = zeros(nSeg,numClass,'single');   % save probablity of each class.
% % % 
% % %         for i = 1 : numClass
% % %             if exist(([matFold 'SelFeatIndex_CV' num2str(iCV) '_' num2str(i) '.mat']),'file')
% % %                 load([matFold 'SelFeatIndex_CV' num2str(iCV) '_' num2str(i) '.mat'],'Sf','curve');
% % %                 testFeat = segFeat(:,Sf);
% % %             else
% % %                 fprintf("SelFeatIndex not found for\n" );
% % %                 quit;
% % %             end
% % %             %testFeat = segFeat(:,SelFeaIdx(i,:));
% % %             if strcmp(selClf,'ANN') % using ANN
% % %                 load([matFold 'netANN_CV' num2str(iCV) '_' num2str(i) '_16.mat'],'net','tr');
% % %                 OutClassPro = sim(net,testFeat');
% % %                 segProbMap(:,i) = OutClassPro';
% % %             elseif  strcmp(selClf,'SVM') % using SVM.
% % %                 load([matFold 'modelSVM_CV' num2str(iCV) '_' num2str(i) '.mat'],'Model');
% % %                 testFlag = zeros(size(testFeat,1),1,'double');
% % %                 [preSVMLabel, SVMAcc,preSVMPro] = svmpredict(double(testFlag),double(testFeat),Model,'-b 1');
% % %                 segProbMap(:,i) = preSVMPro(:,2);
% % %             elseif  strcmp(selClf,'ADB') % using Adaboost.
% % %                 testFlag = zeros(size(testFeat,1),1,'double');
% % %                 [ada_train,ada_test, gda_in, knn_in,nb_in,linear_in,alpha] = adaboost('test',double(testFeat),i,matFold);                   
% % %                 segProbMap(:,i) = ada_test; %BASIM
% % %             elseif  strcmp(selClf,'RDF') % using Random Forest
% % %                 load([matFold 'modelRDF_CV' num2str(iCV) '_' num2str(i) '.mat'],'RDFModel');%BASIM 
% % %                 pred_label = RDFModel.predict(double(testFeat));
% % %                 pred_label_d = str2double(pred_label)
% % %                 segProbMap(:,i) = pred_label_d; %BASIM
% % %             elseif  strcmp(selClf,'CNN') % using Random Forest
% % %                 load([matFold 'modelCNN_CV' num2str(iCV) '_' num2str(i) '.mat'],'net');
% % %                 for j=1:size(testFeat,1)
% % %                     target_test(:,:,:,j)=testFeat(j,:);           
% % %                 end
% % %                 predictedLabels = classify(net,target_test);
% % %                 size(predictedLabels) 
% % %                 predictedLabels_1 = single((predictedLabels=='1'))                      
% % %                 segProbMap(:,i) = predictedLabels_1 
% % %                 %   segProbMap(:,i) = predictedLabels_1' ; 
% % %             end
% % %         end
% % %         
% % %         [maxSegPro maxSegClass] = max(segProbMap,[],2);
% % %         %save('segProbMap.mat','segProbMap');
% % % 
% % %         colSuper = superPixels(:);
% % %         superPixInd = unique(colSuper);
% % %         if 1
% % %             % get block index.
% % %             [gtHeight, gtWidth] = size(imgGT);
% % %             blockIdx = zeros(gtHeight,gtWidth,'uint8');
% % %             oneUnitHeight = ceil(gtHeight/blockrow);
% % %             oneUnitWidth = ceil(gtWidth/blockrow);
% % %             for j = 1:gtHeight
% % %                 HIdx = ceil(j/oneUnitHeight);
% % %                 for k = 1:gtWidth
% % %                     WIdx = ceil(k/oneUnitWidth);
% % %                     blockIdx(j,k) = (HIdx-1)*blockrow + WIdx;
% % %                 end
% % %             end
% % %             blockIdx = blockIdx(:);
% % % 
% % %             % get block index for superpixels.
% % %             segBlkIdx = zeros(nSeg,1,'uint8');
% % %             segPixNum = zeros(nSeg,1,'uint16');
% % %             for j = 1 : nSeg
% % %                 iSegIdx = find(colSuper==superPixInd(j));
% % %                 segBlkIdx(j) = mode(blockIdx(iSegIdx));
% % %                 segPixNum(j) = length(iSegIdx);
% % %             end
% % %         
% % %             % get votes from n-1 superpixels.
% % %             blkVotes = zeros(nSeg,numClass,'single');
% % %             for j = 1 : nSeg
% % %                 % iSegClass = maxSegClass(j);
% % %                 iSegBlk = segBlkIdx(j);
% % %                 temSumPro = zeros(numClass,1,'single');
% % %                 for k = 1 : nSeg
% % %                     if k~=j
% % %                         kSegClass = maxSegClass(k);
% % %                         kSegBlk = segBlkIdx(k);
% % %                         TTT = sumLocPriorMap{kSegBlk}{kSegClass}{iSegBlk};
% % %                         temSumPro = temSumPro + single(segPixNum(k))*maxSegPro(k)*TTT(:);
% % %                     end
% % %                 end
% % %                 blkVotes(j,:) = temSumPro/sum(temSumPro);
% % %             end
% % %         end
% % %         
% % %         if 1  % get neighouring superpixel occurance
% % %             negSPocc = zeros(nSeg,numClass,'single');
% % %             for j = 1 : nSeg
% % %                 jSPidx = find(adjPairs(:,1)==j);
% % %                 negSPidx = adjPairs(jSPidx,2);
% % %                 TT = segGT(negSPidx);  % remove 0 GT.
% % %                 negSPocc(j,:) = mean(adjSuperPixelOcc(TT(TT>0),:));
% % %             end
% % %         end

        combPro = [segProbMap blkVotes negSPocc];
        
        outSegPro = zeros(nSeg,numClass,'single');
        for iCls = 1 : numClass
            iClsProIdx = [iCls iCls+numClass iCls+2*numClass];
            iClsCombPro = combPro(:,iClsProIdx);
            load([matFold 'coefCV' num2str(iCV) 'Block' num2str(blockrow) '.mat'],'coef','coef4')         
            
            if strcmp(selInt,'Linear') 
                tempCoef = coef(iCls,:);
                outSegPro(:,iCls) = tempCoef(1) + iClsCombPro(:,1).*tempCoef(2) + iClsCombPro(:,2).*tempCoef(3) + iClsCombPro(:,3).*tempCoef(4);
            elseif strcmp(selInt,'Non_linear') 
                outSegPro(:,iCls) = predict(coef4{iCls},iClsCombPro);
            elseif strcmp(selInt,'SVM') 
                outSegPro(:,iCls) = predict(coef4{iCls},iClsCombPro);
            elseif strcmp(selInt,'MLP') 
                OutClassPro = sim(coef4{iCls},iClsCombPro');
                outSegPro(:,iCls) = OutClassPro';
            elseif strcmp(selInt,'R-Ensemble') 
                outSegPro(:,iCls) = predict(coef4{iCls},iClsCombPro);
            else
                fprintf('wrong chosen classifiers!\n');
            end
        end
        
        [outSegProVal outSegProIdx] =  max(outSegPro,[],2);
        
        [votSegPro votSegClass] = max(blkVotes,[],2);
        [occSegPro occSegClass] = max(negSPocc,[],2);
        
        colSuper = superPixels(:);
        superPixInd = unique(colSuper);
        [maxSegPro maxSegClass] = max(segProbMap,[],2);
        
        preLabel = zeros(length(imgGT(:)),1,'int8');
        preLabel1 = zeros(length(imgGT(:)),1,'int8');
        preLabel2 = zeros(length(imgGT(:)),1,'int8');
        preLabel3 = zeros(length(imgGT(:)),1,'int8');
        for j = 1 : nSeg
            iSegIdx = find(colSuper==superPixInd(j));
            preLabel(iSegIdx) = maxSegClass(j);
            preLabel1(iSegIdx) = votSegClass(j);
            preLabel2(iSegIdx) = occSegClass(j);
            preLabel3(iSegIdx) = outSegProIdx(j);
        end

        % draw output figures
        if 1
            %dataBases = {'STAN','MSRC','CORE','SIFT'};
            %selDB = dataBases{1};
            imgFold = [selDB 'Data/'];
            outFold = [selDB 'ClsOut' selClf '/'];
            
            if ~exist(outFold,'dir')
                mkdir(outFold);
            end
            
            outGT = imread([imgFold iImgName]); 
            [gtHeight, gtWidth] = size(imgGT);
            %TT = reshape(preLabel,[gtHeight, gtWidth]); %first label
            TT = reshape(preLabel3,[gtHeight, gtWidth]); % final label
                        
            if strcmp(selDB,'STAN')
                for iH = 1 : gtHeight
                    for iW = 1 : gtWidth
                        switch TT(iH,iW)
                            case 1
                                outGT(iH,iW,:) = [135 206 235];
                            case 2
                                outGT(iH,iW,:) = [0 255 0];
                            case 3
                                outGT(iH,iW,:) = [128 138 135];
                            case 4
                                outGT(iH,iW,:) = [31 139 34];
                            case 5
                                outGT(iH,iW,:) = [65 105 225];
                            case 6
                                outGT(iH,iW,:) = [138 43 226];
                            case 7
                                outGT(iH,iW,:) = [0 0 255];
                            case 8
                                outGT(iH,iW,:) = [255 255 0];
                            otherwise
                                outGT(iH,iW,:) = [0 0 0];
                        end
                    end
                end
            end

            if strcmp(selDB,'MSRC')
                for iH = 1 : gtHeight
                    for iW = 1 : gtWidth
                        switch TT(iH,iW)
                            case 1
                                outGT(iH,iW,:) = [128 0 0];
                            case 2
                                outGT(iH,iW,:) = [0 128 0];
                            case 3
                                outGT(iH,iW,:) = [128 128 0];
                            case 4
                                outGT(iH,iW,:) = [0 0 128];
                            case 5
                                outGT(iH,iW,:) = [0 128 128];
                            case 6
                                outGT(iH,iW,:) = [128 128 128];
                            case 7
                                outGT(iH,iW,:) = [192 0 0];
                            case 8
                                outGT(iH,iW,:) = [64 128 0];
                            case 9
                                outGT(iH,iW,:) =  [192 128 0];
                            case 10
                                outGT(iH,iW,:) =  [64 0 128];
                            case 11
                                outGT(iH,iW,:) =  [192 0 128];
                            case 12
                                outGT(iH,iW,:) =  [64 128 128];
                            case 13
                                outGT(iH,iW,:) = [192 128 128] ;
                            case 14
                                outGT(iH,iW,:) =  [0 64 0];
                            case 15
                                outGT(iH,iW,:) =  [128 64 0];
                            case 16
                                outGT(iH,iW,:) =  [0 192 0];
                            case 17
                                outGT(iH,iW,:) =  [128 64 128];
                            case 18
                                outGT(iH,iW,:) =  [0 192 128];
                            case 19
                                outGT(iH,iW,:) =  [128 192 128];
                            case 20
                                outGT(iH,iW,:) =  [64 64 0];
                            case 21
                                outGT(iH,iW,:) =  [192 64 0];
                            otherwise
                                outGT(iH,iW,:) = [0 0 0];
                        end
                    end
                end
            end

            if strcmp(selDB,'SIFT')
                for iH = 1 : gtHeight
                    for iW = 1 : gtWidth
                        switch TT(iH,iW)
                            case 1
                                outGT(iH,iW,:) = [128 0 0];
                            case 2
                                outGT(iH,iW,:) = [0 128 0];
                            case 3
                                outGT(iH,iW,:) = [128 128 0];
                            case 4
                                outGT(iH,iW,:) = [0 0 128];
                            case 5
                                outGT(iH,iW,:) = [0 128 128];
                            case 6
                                outGT(iH,iW,:) = [128 128 128];
                            case 7
                                outGT(iH,iW,:) = [192 0 0];
                            case 8
                                outGT(iH,iW,:) = [64 128 0];
                            case 9
                                outGT(iH,iW,:) =  [192 128 0];
                            case 10
                                outGT(iH,iW,:) =  [64 0 128];
                            case 11
                                outGT(iH,iW,:) =  [192 0 128];
                            case 12
                                outGT(iH,iW,:) =  [64 128 128];
                            case 13
                                outGT(iH,iW,:) = [192 128 128] ;
                            case 14
                                outGT(iH,iW,:) =  [0 64 0];
                            case 15
                                outGT(iH,iW,:) =  [128 64 0];
                            case 16
                                outGT(iH,iW,:) =  [0 192 0];
                            case 17
                                outGT(iH,iW,:) =  [128 64 128];
                            case 18
                                outGT(iH,iW,:) =  [0 192 128];
                            case 19
                                outGT(iH,iW,:) =  [128 192 128];
                            case 20
                                outGT(iH,iW,:) =  [64 64 0];
                            case 21
                                outGT(iH,iW,:) =  [192 64 0];
                            case 22
                                outGT(iH,iW,:) =  [255 0 0];
                            case 23
                                outGT(iH,iW,:) =  [0 255 0];
                            case 24
                                outGT(iH,iW,:) =  [ 0 0 255];
                            case 25
                                outGT(iH,iW,:) =  [255 255 0];
                            case 26
                                outGT(iH,iW,:) =  [255 0 255];
                            case 27
                                outGT(iH,iW,:) =  [0 255 255];
                            case 28
                                outGT(iH,iW,:) =  [255 97 0];
                            case 29
                                outGT(iH,iW,:) =  [255 128 64];
                            case 30
                                outGT(iH,iW,:) =  [135 38 87];
                            case 31
                                outGT(iH,iW,:) =  [51 161 201];
                            case 32
                                outGT(iH,iW,:) =  [3 168 158];
                            case 33
                                outGT(iH,iW,:) =  [199 97 20];
                            otherwise
                                outGT(iH,iW,:) = [0 0 0];
                        end
                    end
                end
            end
            
            if strcmp(selDB,'CS')
                for iH = 1 : gtHeight
                    for iW = 1 : gtWidth
                        switch TT(iH,iW)
                            case 1
                                outGT(iH,iW,:) = [128 64 128];
                            case 2
                                outGT(iH,iW,:) = [244 35 232];
                            case 3
                                outGT(iH,iW,:) = [70 70 70];
                            case 4
                                outGT(iH,iW,:) = [102 102 156];
                            case 5
                                outGT(iH,iW,:) = [190 153 153];
                            case 6
                                outGT(iH,iW,:) = [153 153 153];
                            case 7
                                outGT(iH,iW,:) = [250 170 30];
                            case 8
                                outGT(iH,iW,:) = [220 220 0];
                            case 9
                                outGT(iH,iW,:) =  [107 142 35];
                            case 10
                                outGT(iH,iW,:) =  [152 251 152];
                            case 11
                                outGT(iH,iW,:) =  [70 130 180];
                            case 12
                                outGT(iH,iW,:) = [220 20 60];
                            case 13
                                outGT(iH,iW,:) = [255 0 0];
                            case 14
                                outGT(iH,iW,:) = [0 0 142];
                            case 15
                                outGT(iH,iW,:) = [0 0 70];
                            case 16
                                outGT(iH,iW,:) = [0 60 100];
                            case 17
                                outGT(iH,iW,:) =  [0 80 100];
                            case 18
                                outGT(iH,iW,:) =  [0 0 230];
                            case 19
                                outGT(iH,iW,:) =  [119 11 32];
                            otherwise
                                outGT(iH,iW,:) = [0 0 0];
                        end
                    end
                end
            end
            
            imwrite(outGT,[outFold iImgName]);
        end
        allPL  = [allPL; preLabel(:)];
        allPL1 = [allPL1; preLabel1(:)];
        allPL2 = [allPL2; preLabel2(:)];
        allPL3 = [allPL3; preLabel3(:)];
        allGT  = [allGT; imgGT(:)];
    end
end

save([matFold 'pixClsLabel' num2str(blockrow) '.mat'],'allPL','allPL1','allPL2','allPL3','allGT');

% handle unknown object.
validIdx = find(allGT>0);
allPL = allPL(validIdx);
allPL1 = allPL1(validIdx);
allPL2 = allPL2(validIdx);
allPL3 = allPL3(validIdx);

fprintf('Acc using ANN/SVM classifier (CV %d):\n',iCV);
allGT = allGT(validIdx);
mean(allGT==allPL)
formConfusionM(allGT,allPL)

fprintf('Acc using spatial block voting (CV %d):\n',iCV);
mean(allGT==allPL1)
formConfusionM(allGT,allPL1)

fprintf('Acc using neighouring superpixel occurance (CV %d):\n',iCV);
mean(allGT==allPL2)
formConfusionM(allGT,allPL2)

fprintf('Acc using logistic regression on all probabilities (CV %d):\n',iCV);
mean(allGT==allPL3)
formConfusionM(allGT,allPL3)

save([matFold 'ClsOutPutCV' num2str(iCV) 'Block' num2str(blockrow) '.mat'],'allGT','allPL','allPL1','allPL2','allPL3');
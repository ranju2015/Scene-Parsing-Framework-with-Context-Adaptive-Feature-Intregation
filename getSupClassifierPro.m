function segProbMap = getSupClassifierPro(matFold,segFeat,SelFeaIdx,nSeg,numClass,selClf,sta,iCV)

segFeat = segFeat-repmat(sta.mean,[nSeg,1]);
segFeat = segFeat./repmat(sta.std + ~sta.std,[nSeg,1]);
segProbMap = zeros(nSeg,numClass,'double');   % save probablity of each class.

for i = 1 : numClass
    %testFeat = segFeat(:,SelFeaIdx(i,:));
    if exist(([matFold 'SelFeatIndex_CV' num2str(iCV) '_' num2str(i) '.mat']),'file')
        load([matFold 'SelFeatIndex_CV' num2str(iCV) '_' num2str(i) '.mat'],'Sf','curve');
        testFeat = segFeat(:,Sf);
    else
        fprintf("SelFeatIndex not found for\n" );
        quit;
    end
    
    if strcmp(selClf,'ANN') % using ANN
        load([matFold 'netANN_CV' num2str(iCV) '_' num2str(i) '_16.mat'],'net','tr');
        OutClassPro = sim(net,testFeat');
        segProbMap(:,i) = OutClassPro';
    elseif  strcmp(selClf,'SVM') % using SVM.
        load([matFold 'modelSVM_CV' num2str(iCV) '_' num2str(i) '.mat'],'Model');
        testFlag = zeros(size(testFeat,1),1,'double');
        [preSVMLabel, SVMAcc,preSVMPro] = svmpredict(double(testFlag),double(testFeat),Model,'-b 1');
        %segProbMap(:,i) = preSVMPro(:,1);
        segProbMap(:,i) = preSVMPro(:,2);
        
        
    elseif  strcmp(selClf,'ADB') % using ADABOOST. %BASIM
        %load([matFold 'modelADB_CV' num2str(iCV) '_' num2str(i) '.mat'],'ada_train','ada_test' ,'gda_in', 'knn_in','nb_in','linear_in');%BASIM 
        testFlag = zeros(size(testFeat,1),1,'double'); %BASIM
        [ada_train,ada_test, gda_in, knn_in,nb_in,linear_in,alpha] = adaboost('test',double(testFeat),i,matFold)
        %segProbMap(:,i) = preSVMPro(:,1); %BASIM
        segProbMap(:,i) = ada_test; %BASIM
    
    elseif strcmp(selClf,'RDF') % RandomForest.  %BASIM 
        load([matFold 'modelRDF_CV' num2str(iCV) '_' num2str(i) '.mat'],'RDFModel');%BASIM       
        pred_label = RDFModel.predict(double(testFeat));
        pred_label_d = str2double(pred_label)
        segProbMap(:,i) = pred_label_d; %BASIM
    end  
end
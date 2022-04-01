function sta = trainClassifer(matFold,trainSegFeat,trainSegGT,numClass,SelFeaIdx,selClf,iCV)

[trainSegFeat, sta] = normX(trainSegFeat);

for i = 1 : numClass
    fprintf('Class%d ',i);
    selSegFeat = trainSegFeat(:,SelFeaIdx(i,:));
    binSegGT = zeros(length(trainSegGT),1);
    binSegGT(trainSegGT==i)=1; 

    if strcmp(selClf,'ANN') % using ANN
        if ~exist([matFold 'netANN_CV' num2str(iCV) '_' num2str(i) '_16.mat'],'file')
            %net = newff(double(selSegFeat'),double(binSegGT'),16);
            net = patternnet(16);
            net.trainParam.showCommandLine = true;
            net.divideFcn = 'dividerand';
            net.divideParam.trainRatio = 1;
            net.divideParam.valRatio = 0;
            net.divideParam.testRatio = 0;
            %net.performFcn='mse';
            net.trainParam.goal=0.001;
            net.trainParam.epochs=300;
            net.trainParam.min_grad = 1e-8;  % default: 1e-5. If the magnitude of the gradient is less than 1e-5, training stops.
            net.trainParam.max_fail = 10;   %default: 6. If this number reaches 6, the training will stop.
            
            net = configure(net,double(selSegFeat'),double(binSegGT'));
            net = init(net);
            [net,tr] = train(net,double(selSegFeat'),double(binSegGT'));
            save([matFold 'netANN_CV' num2str(iCV) '_' num2str(i) '_16.mat'],'net','tr');
        end
    elseif strcmp(selClf,'SVM') % using SVM.
        if ~exist([matFold 'modelSVM_CV' num2str(iCV) '_' num2str(i) '.mat'],'file')
            Model  = svmtrain(double(binSegGT),double(selSegFeat),'-t 2 -b 1');%
%            Model  = libsvmtrain(double(binSegGT),double(selSegFeat),'-t 2 -b 1');
            
            save([matFold 'modelSVM_CV' num2str(iCV) '_' num2str(i) '.mat'],'Model');
        end
    elseif strcmp(selClf,'ADB') % ADABOOST.  %BASIM 
        if ~exist([matFold 'modelADB_CV' num2str(iCV) '_' num2str(i) '.mat'],'file')%BASIM 
            [ada_train,ada_test, gda_in,knn_in,nb_in,linear_in,alpha] = adaboost('train',double(selSegFeat),double(binSegGT),matFold);
            %[classestimate,model]=adaboost('train',double(selSegFeat),double(binSegGT'),50);%BASIM 
            save([matFold 'modelADB_CV' num2str(iCV) '_' num2str(i) '.mat'],'ada_train','ada_test' ,'gda_in', 'knn_in','nb_in','linear_in','alpha');%BASIM 
        end
    elseif strcmp(selClf,'RDF') % RandomForest.  %BASIM 
        if ~exist([matFold 'modelRDF_CV' num2str(iCV) '_' num2str(i) '.mat'],'file')%BASIM 
          
            RDFModel = TreeBagger(100,double(selSegFeat),double(binSegGT),'OOBPrediction','On');
             

            save([matFold 'modelRDF_CV' num2str(iCV) '_' num2str(i) '.mat'],'RDFModel');%BASIM 
        end   
    elseif strcmp(selClf,'CNN') % CNN.  %BASIM 
        if ~exist([matFold 'modelCNN_CV' num2str(iCV) '_' num2str(i) '.mat'],'file')%BASIM 
          
           [dim1, dim2]=size(selSegFeat);
           
           for j=1:size(selSegFeat,1)
           target2(:,:,:,j)=selSegFeat(j,:);           
           end
           
           binSegGT2=categorical(binSegGT);

           layers = [
                imageInputLayer([50 1 1]) % refers to number of features per sample
                convolution2dLayer(3,16,'Padding','same')
                reluLayer
                fullyConnectedLayer(10) % 384 refers to number of neurons in next FC hidden layer
                fullyConnectedLayer(10) % 384 refers to number of neurons in next FC hidden layer
                fullyConnectedLayer(2) % 2 refers to number of neurons in next output layer (number of output classes)
                softmaxLayer
                classificationLayer];
            options = trainingOptions('sgdm',...
                'MaxEpochs',10, ...
                'Verbose',false,...
                'Plots','training-progress');
            
            net = trainNetwork(target2,binSegGT2,layers,options);
            

            save([matFold 'modelCNN_CV' num2str(iCV) '_' num2str(i) '.mat'],'net');%BASIM 
        end    
    else
        fprintf('wrong chosen classifiers!\n');
    end
end
fprintf('\n');
function [ centers ] = mr_resp_centers( fileList, HOMEIMAGES, testImgIdx,dictionarySize)
%MAX_RESP_CENTERS Summary of this function goes here
%   Detailed explanation goes here

fprintf('Inside function SegmentDescriptors> calculate_centres >mr_resp_centers\n'); 

[uV sV] = memory;
ndata_max = min(sV.PhysicalMemory.Available/304/10,100000); %use 10% avalible memory if its smaller than the default
numTextonImages = min(1000,length(fileList));
imIndexs = randperm(length(fileList));
fullresp = [];
for i = imIndexs(1:numTextonImages)
    if ~ismember(i,testImgIdx)  % training images;
        filename = fullfile(fileList{i});   %filename = fullfile(HOMEIMAGES,fileList{i});
        im = imread(filename);
        [foo data2add] = FullMR8(im);
        
        if(size(data2add,2)>ndata_max/numTextonImages )
            p = randperm(size(data2add,2));
            data2add = data2add(:,p(1:floor(ndata_max/numTextonImages)));
        end
        fullresp = [fullresp data2add];
    end
end
fullresp = fullresp';

opts = statset('MaxIter',50,'Display','iter');
%% run kmeans
fprintf('\nRunning k-means\n');
[foo centers] = kmeans(fullresp, dictionarySize,'Options',opts);
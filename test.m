function test()

% HOME = './';
% addpath(genpath(HOME));
% imgFold = [HOME 'SIFTData'];
% gtFold = [HOME 'SIFTLabel'];
% 
% listFile = [HOME 'fileList.txt'];
% if (exist(listFile,'file'))
%     fileList = importdata(listFile);
% else
%     fileList = dir_recurse(fullfile(imgFold,'*.*'),0);
% end
% 
% ImgDir=dir([imgFold '*.bmp']);
% lenImg = length(ImgDir);
% 
% allGT = -2*ones(lenImg,20,'single');
% for iImg = 1:lenImg
%         iImgName = ImgDir(iImg).name;
%         fprintf('Image No %d: %s\n',iImg,iImgName);
%         % read pixel ground truths
%         segFileName = [gtFold iImgName(1:end-4) '.bmp'];
%         imgGT = importdata(segFileName);
%         imgGT = unique(imgGT(:));
%         allGT(iImg,1:length(imgGT)) = imgGT;
% end
% save('allGT.mat','allGT');

imgFold = 'SIFTData/';

allImgList = dir_recurse(fullfile(imgFold,'*.jpg'),0);
testImgListCell = textread([imgFold 'TestSet1.txt'],'%s');
[cc loc]= ismember(testImgListCell,allImgList)
save('tepTestOut.mat','allImgList','testImgListCell','loc');
function getPixAmountPerClass()

% imgFold = './STANLabel/';
imgFold = './MSRCLabel/';
ImgDir=dir([imgFold '*.txt']);
lenImg = length(ImgDir);

pixelPerClass = zeros(1,21);
for i = 1:lenImg
    fprintf('%d\n',i);
    iImgName = ImgDir(i).name;
    
    segFileName = [imgFold iImgName];
    S = importdata(segFileName);
    S = S(:);
    for j = 1 : 21
        pixelPerClass(j) = pixelPerClass(j)+ length(find(S ==j-1));
    end
end
%save('pixelPerClass.mat','pixelPerClass');
[Y, Idx] = sort(pixelPerClass,'descend');
Y
Idx
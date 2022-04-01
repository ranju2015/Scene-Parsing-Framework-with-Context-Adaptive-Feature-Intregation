function drawOutPutFig()

HOME = './';
addpath(genpath(HOME));

dataBases = {'STAN','MSRC','CORE','SIFT'};
selDB = dataBases{1};

imgFold = [HOME selDB 'img/'];
gtFold = [HOME selDB 'labels/'];
matFold = [HOME selDB 'mat/'];
outFold = [HOME selDB 'Out/'];
testImgFold = [HOME selDB 'testImg/'];

if ~exist(outFold,'dir')
    mkdir(outFold);
end

if ~exist(testImgFold,'dir')
    mkdir(testImgFold);
end

if 0
    testImgListCell = textread([imgFold 'TestSet1.txt'],'%s');
    lenImg = length(testImgListCell);
    for iImg = 1 : lenImg
        iImgName = testImgListCell{iImg};
        I = imread([imgFold iImgName]);
        imwrite(I,[testImgFold iImgName]);
    end
end


if 0  % sift data
    testImgListCell = textread([imgFold 'TestSet1.txt'],'%s');
    lenImg = length(testImgListCell);
    for iImg = 1 : lenImg
        iImgName = testImgListCell{iImg};
        segFileName = [gtFold iImgName(1:end-4) '.txt'];
        I = imread([imgFold iImgName]);
        
        imgGT = importdata(segFileName);
        [gtHeight, gtWidth] = size(imgGT);
        outGT = I;
        for iH = 1 : gtHeight
            for iW = 1 : gtWidth
                switch imgGT(iH,iW)
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
        imwrite(outGT,[outFold iImgName]);
    end
end

if 1  % standford data.
allImgList = dir_recurse(fullfile(imgFold,'*.jpg'),0);
lenImg = length(allImgList);
for iImg = 1:lenImg
    iImgName = allImgList{iImg}; 
    
    segFileName = [gtFold iImgName(1:end-4) '.regions.txt'];
    imgGT = importdata(segFileName);
    I = imread([imgFold iImgName]);
    
    imgGT = importdata(segFileName);
    [gtHeight, gtWidth] = size(imgGT);
    
    % Stanford: [0 7]: {'sky', 'tree', 'road', 'grass', 'water', 'building', 'mountain','foreground'};
    % grass: [34 139 34];
    % sky: [220 220 220];
    % tree: [227 207 87];
    % foreground: [0 0 255];
    % building: [138 43 226];
    % road: [221 160 221];
    % water: [65 105 225];
    % soil: [0 0 0];
    outGT = I;
    for iH = 1 : gtHeight
        for iW = 1 : gtWidth
            switch imgGT(iH,iW)
                case 0
                    outGT(iH,iW,:) = [135 206 235];
                case 1
                    outGT(iH,iW,:) = [0 255 0];
                case 2
                    outGT(iH,iW,:) = [128 138 135];
                case 3
                    outGT(iH,iW,:) = [31 139 34];
                case 4
                    outGT(iH,iW,:) = [65 105 225];
                case 5
                    outGT(iH,iW,:) = [138 43 226];
                case 6
                    outGT(iH,iW,:) = [0 0 255];
                case 7
                    outGT(iH,iW,:) = [255 255 0];
                otherwise
                    outGT(iH,iW,:) = [0 0 0];      
            end
        end
    end
    imwrite(outGT,[outFold iImgName]);
end
end
                    
function blkVotes = getNeigBlockVote(sumLocPriorMap,superPixels,imgGT,segProbMap,blockrow,nSeg,numClass)

[gtHeight, gtWidth] = size(imgGT);
blockIdx = zeros(gtHeight,gtWidth,'uint8');
oneUnitHeight = ceil(gtHeight/blockrow);
oneUnitWidth = ceil(gtWidth/blockrow);
for j = 1:gtHeight
    HIdx = ceil(j/oneUnitHeight);
    for k = 1:gtWidth
        WIdx = ceil(k/oneUnitWidth);
        blockIdx(j,k) = (HIdx-1)*blockrow + WIdx;
    end
end
blockIdx = blockIdx(:);

colSuper = superPixels(:);
superPixInd = unique(colSuper);
% get block index for superpixels.
segBlkIdx = zeros(nSeg,1,'uint8');
segPixNum = zeros(nSeg,1,'uint16');
for j = 1 : nSeg
    iSegIdx = find(colSuper==superPixInd(j));
    segBlkIdx(j) = mode(blockIdx(iSegIdx));
    segPixNum(j) = length(iSegIdx);
end

[maxSegPro maxSegClass] = max(segProbMap,[],2);
% get votes from n-1 superpixels.
blkVotes = zeros(nSeg,numClass,'single');
for j = 1 : nSeg
    % iSegClass = maxSegClass(j);
    iSegBlk = segBlkIdx(j);
    temSumPro = zeros(numClass,1,'single');
    for k = 1 : nSeg
        if k~=j
            kSegClass = maxSegClass(k);
            kSegBlk = segBlkIdx(k);
            TTT = sumLocPriorMap{kSegBlk}{kSegClass}{iSegBlk};
            temSumPro = temSumPro + single(segPixNum(k))*maxSegPro(k)*TTT(:);
        end
    end
    blkVotes(j,:) = temSumPro/sum(temSumPro);
end
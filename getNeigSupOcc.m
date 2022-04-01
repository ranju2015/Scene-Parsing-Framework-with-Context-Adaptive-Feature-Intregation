function negSPocc = getNeigSupOcc(adjSuperPixelOcc,adjPairs,segGT,nSeg,numClass)

negSPocc = zeros(nSeg,numClass,'single');
for j = 1 : nSeg
    jSPidx = find(adjPairs(:,1)==j);
    negSPidx = adjPairs(jSPidx,2);
    TT = segGT(negSPidx);  % remove 0 GT.
    negSPocc(j,:) = mean(adjSuperPixelOcc(TT(TT>0),:));
end
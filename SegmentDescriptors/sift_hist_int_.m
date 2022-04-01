function [ desc ] = sift_hist_int_( im, mask, maskCrop, bb, centers, textons, varargin  )
%INT_TEXT_HIST_MR Summary of this function goes here
%   Detailed explanation goes here
mask = maskCrop;
textonIm = textons.sift_textons(:);
textonIm(~mask) = [];

dictionarySize = size(centers.sift_centers,1);
desc = calculate_texton_hist( textonIm, dictionarySize );

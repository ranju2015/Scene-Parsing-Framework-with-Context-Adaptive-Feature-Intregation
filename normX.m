% function [X,sta] = normX(X)
% INPUTS
%  X   
%                      a [# examples * #features] matrix 
% OUTPUTS   
%  X
%                      has mean 0 and standard deviation 1
%  sta
%                      a struct with 
%                      sta.mean a [#features]-element array 
%                      sta.std  a [#features]-element array
% 2007-09-10 Hueihan
 
function [X,sta] = normX(X)


m = mean(X);
s = std(X);
s = s + ~s;

npoints = size(X,1);

X = X-repmat(m,[npoints,1]);
X = X./repmat(s,[npoints,1]);

sta.mean = m;
sta.std  = s;
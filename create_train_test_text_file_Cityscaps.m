%This file will read files form a directory and create text file
%---containing the name of files only without extension.
%The list of filename inside a 
% randomization is included

%fptrain = fopen('trainList.txt','w');   %train list file
fptest  = fopen('/home/mandalr/projects/SuperPixel_hpc_CityScapes/CSData/TestSet.txt','w');    %test list file  

Folder = '/home/mandalr/projects/SuperPixel_hpc_CityScapes/CSData/valRR/';
FileList = dir(fullfile(Folder, '*.png'));
Index    = randperm(numel(FileList));

[r c]=size(FileList);
disp(r);

for k = 1:1:r
  src = fullfile(Folder, FileList(Index(k)).name);
  %disp(src);
  [pathstr, name, ext] = fileparts(src);
  %disp(name);
  fprintf(fptest,'%s%s\n',name,ext);
   
end
%fclose(fptrain);
fclose(fptest);
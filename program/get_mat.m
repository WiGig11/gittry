clear all;
clc;

Path = 'D:\Campus\数据\数据\117数据\t2\';

File = dir(fullfile(Path,'*.txt')); % 显示文件夹下所有符合后缀名为.txt文件的完整信息
FileNames = {File.name}';  % 提取符合后缀名为.txt的所有文件的文件名，转换为n行1列的cell数据
n = size(FileNames,1); 
numfiles = n-2;
startnumfiles = 1;

if n>10000
    endnumfiles = 10000;
else
    endnumfiles = numfiles;
end

mydata = cell(startnumfiles, endnumfiles);
%读取数据
for k = startnumfiles:1:endnumfiles
  myfilename = sprintf('%d.txt',k);
%   mydata{k} = importdata(myfilename);
  mydata{k}=importdata([Path myfilename]);

end
distance = mydata{startnumfiles}(:,1);
intensity = [];
time = 1:1:endnumfiles-startnumfiles+1;

for k = startnumfiles:1:endnumfiles
    intensity = [intensity mydata{k}(:,2)];
end
% 读出数据

save('D:\Campus\数据\数据\117数据_t2\','intensity');





clear all;clc;

Path = 'D:\毕设\MATLAB程序整理\mat生成\txt数据\0905data\';
File = dir(fullfile(Path,'*.txt')); % 显示文件夹下所有符合后缀名为.txt文件的完整信息
FileNames = {File.name}';  % 提取符合后缀名为.txt的所有文件的文件名，转换为n行1列的cell数据
n = size(FileNames,1); 
numfiles = n-2;

startnumfiles = 19001;
endnumfiles = startnumfiles+1899;

startnum = 1;
endnum = endnumfiles-startnumfiles+1;
mydata = cell(startnum, endnum);
%读取数据
count = 1;
for k = startnumfiles:1:endnumfiles
  myfilename = sprintf('%d.txt',k);
%   mydata{k} = importdata(myfilename);
  mydata{count}=importdata([Path myfilename]);
  count = count +1;
end
distance = mydata{startnum}(:,1);
intensity = [];
time = 1:1:endnumfiles-startnumfiles+1;

for i = startnum:1:endnum
    intensity = [intensity mydata{i}(:,2)];
end

% 读出数据
save('D:\毕设\MATLAB程序整理\mat生成\mat数据\0905D21\','intensity');
figure(1);mesh(intensity);

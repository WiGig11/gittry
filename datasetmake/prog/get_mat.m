clear all;clc;

Path = 'D:\����\MATLAB��������\mat����\txt����\0905data\';
File = dir(fullfile(Path,'*.txt')); % ��ʾ�ļ��������з��Ϻ�׺��Ϊ.txt�ļ���������Ϣ
FileNames = {File.name}';  % ��ȡ���Ϻ�׺��Ϊ.txt�������ļ����ļ�����ת��Ϊn��1�е�cell����
n = size(FileNames,1); 
numfiles = n-2;

startnumfiles = 19001;
endnumfiles = startnumfiles+1899;

startnum = 1;
endnum = endnumfiles-startnumfiles+1;
mydata = cell(startnum, endnum);
%��ȡ����
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

% ��������
save('D:\����\MATLAB��������\mat����\mat����\0905D21\','intensity');
figure(1);mesh(intensity);

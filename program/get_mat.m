clear all;
clc;

Path = 'D:\Campus\����\����\117����\t2\';

File = dir(fullfile(Path,'*.txt')); % ��ʾ�ļ��������з��Ϻ�׺��Ϊ.txt�ļ���������Ϣ
FileNames = {File.name}';  % ��ȡ���Ϻ�׺��Ϊ.txt�������ļ����ļ�����ת��Ϊn��1�е�cell����
n = size(FileNames,1); 
numfiles = n-2;
startnumfiles = 1;

if n>10000
    endnumfiles = 10000;
else
    endnumfiles = numfiles;
end

mydata = cell(startnumfiles, endnumfiles);
%��ȡ����
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
% ��������

save('D:\Campus\����\����\117����_t2\','intensity');





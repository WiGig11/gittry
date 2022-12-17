clear all;clc;

i = 38
startnumfiles =  26000;
endnumfiles = startnumfiles+4299


Path = 'G:\˶ʿ�ڼ�\���˴���\����\gittry\datasetmake\txt\1107data\13\';
dirpa = ['G:\˶ʿ�ڼ�\���˴���\����\gittry\datasetmake\mat\13\1107_13_D',num2str(i)];
dirpa1 = ['1107_13_D',num2str(i),'.mat'];
dirpa2 = ['G:\˶ʿ�ڼ�\���˴���\����\gittry\datasetmake\csv\13\1107_13_D',num2str(i),'.csv'];
File = dir(fullfile(Path,'*.txt')); % ��ʾ�ļ��������з��Ϻ�׺��Ϊ.txt�ļ���������Ϣ
FileNames = {File.name}';  % ��ȡ���Ϻ�׺��Ϊ.txt�������ļ����ļ�����ת��Ϊn��1�е�cell����
n = size(FileNames,1); 
numfiles = n-2;
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
save(dirpa,'intensity');
figure(1);mesh(intensity);view([0 90]);
cd 'G:\˶ʿ�ڼ�\���˴���\����\gittry\datasetmake\mat\13'
intensity1 = importdata(dirpa1);   
cd 'G:\˶ʿ�ڼ�\���˴���\����\gittry\datasetmake\prog'
startpos1 = 100 ;endpos1 = 299; starttime = 1; Observe_Window_LEN = 500;
noise_deducted1 = datapre(intensity1,startpos1,endpos1,starttime,length(intensity1));
% silence_removed1 = silence_removal(noise_deducted1,800); 
% num_walker1 = get_walker_num(silence_removed1);
cell_of_matrix_sig1 = matrix_div_and_reconstr4(noise_deducted1,1);
maxsig =max(cell_of_matrix_sig1{1});
features =  featureall(intensity1,startpos1,maxsig,cell_of_matrix_sig1{1},410);     
features = table(features');
writetable(features,dirpa2);

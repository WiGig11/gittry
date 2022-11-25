clc ;
close all;
clear all;

%%
cd ..
cd('G:\硕士期间\光纤传感\数据\testmat');
intensity1 = importdata('chzblindright.mat');%盲杖右
intensity2 = importdata('chzblindmiddle.mat');%盲杖中
intensity3 = importdata('mcblindmiddle.mat');%mc中
intensity4 = importdata('chzmiddle.mat');%中
intensity5 = importdata('chzleft.mat');%左
intensity6 = importdata('lylzmiddle.mat');%盲杖左

% intensity7 = importdata('lyl_mcbilnd.mat');%左
% intensity6 = importdata('lyl_mcblind2.mat');%盲杖左


% intensity1 = importdata('intensitychztb.mat');%r
% intensity2 = importdata('intensitychztb2.mat');%r
% intensity3 = importdata('intensitymcpb.mat');%r
% intensity4 = importdata('4.mat');%r
% intensity5 = importdata('5.mat');%b
% cd ..
% cd('G:\硕士期间\光纤传感\数据\118data');
% intensity6 = importdata('DifferenceData 20221108152258188_ch1.mat');%b
cd ..
cd('G:\硕士期间\光纤传感\数据\program');

%%
startpos =180 ;%118
endpos = 279;  %279
starttime  = 1;
% endtime  = length(intensity1);
GAP = 500;

%%
features1 =  featureall(intensity1,169,240,starttime,length(intensity1),GAP);
features2 =  featureall(intensity2,157,227,starttime,length(intensity2),GAP);
features3 =  featureall(intensity3,84,281,starttime,length(intensity3),GAP);
features4 =  featureall(intensity4,152,254,starttime,length(intensity4),GAP);
features5 =  featureall(intensity5,155,246,starttime,length(intensity5),GAP);
features6 =  featureall(intensity6,114,293,starttime,length(intensity6),GAP);

feature = [features1;
    features2;
    features3;
    features4;
    features5;
    features6];
%%
featuret = table(feature);
size1 = size(feature);

% writetable(featuret, 'G:\硕士期间\光纤传感\数据\reliefF算法\test.csv');
ID = (1:size1(1,1))';
typeof = [0,0,1,1,1,0]';
feature = [ID,feature,typeof];
%% try

warning off MATLAB:xlswrite:AddSheet
fnames = {'ID','freq','ave_str','var_str','step_energy','var_mean_ratio','peakindex','mean_xocrr','timew','cw','bw','lr_ratio','T1','Cave1', 'T2','Cave2','T3','Cave3','timepdist2D','mean_bw','mean_peak_low','type'};
for i = 1:length(fnames)
    temp = [fnames{1,i};num2cell(feature(:,i))];
    xlswrite('G:\硕士期间\光纤传感\数据\reliefF算法\test1.xlsx',temp,'sheet1',[char(64+i),num2str(1)]);
    xlswrite('G:\硕士期间\光纤传感\数据\pythonProject1\test1.xlsx',temp,'sheet1',[char(64+i),num2str(1)]);
end
% ,[char(65+i),num2str(1)]
% sizef = size(feature);
% featuret.id = (1:length(sizef(1,1)))';
% featuret.type = [0;1;1;1;0;0];
%保存表格

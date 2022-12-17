close all;clear all;clc;
%% 参数设置 
startpos1 = 100 ; endpos1 = 299; 
startpos23 = 185;endpos23 = 232;  
Observe_Window_LEN = 500;                %get start_time!

%% 数据导入 & 预处理（去除底噪+人数判断、矩阵切割+移除静止时间）
intensity1 = importdata('4.mat');   
intensity2 = importdata('1107_10_1w5.mat');
intensity3 = importdata('B3.mat');
noise_reducted1 = datapre(intensity1,startpos1,endpos1,1,length(intensity1));
noise_reducted2 = datapre(intensity2,startpos23,endpos23,1,length(intensity2));
noise_reducted3 = datapre(intensity3,startpos23,endpos23,1,length(intensity3));
silence_removed1 = silence_removal(noise_reducted1); 
figure(1)
mesh(silence_removed1);
% subplot(211);mesh(noise_reducted1(:,4201:4800));
% subplot(212);mesh(noise_reducted1(:,4201-2000:4800));
% y = max(noise_reducted1(:,601:1200),[],2);
% y = max(noise_reducted1(:,1:600),[],2);
% y = max(noise_reducted1(:,1801:2401),[],2);
figure(22)
for l = 1:25
% l = 21;
    y = max(silence_removed1(:,1+(l-1)*Observe_Window_LEN:l*Observe_Window_LEN),[],2);
    plot(y);
    edge_index = pcount1(y);
end

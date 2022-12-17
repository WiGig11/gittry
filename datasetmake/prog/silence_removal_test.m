close all;clear all;clc;
%% 参数设置 
startpos1 = 100; endpos1 = 299; 
starttime  = 1;                

%% 数据导入 & 预处理（去除底噪+移除静止时间+人数判断、矩阵切割）
% intensity1 = importdata('4-1.mat'); 
intensity1 = importdata('1107_11_1w5.mat');   

noise_deducted1 = datapre(intensity1,startpos1,endpos1,starttime,length(intensity1));

silence_removed1 = silence_removal(noise_deducted1); 






%Silence Removal
% [row,column] = size(noise_deducted1);
% pure_noise_matrix = zeros(row,3000);%3000点噪声
% new_intensity1 = [pure_noise_matrix noise_deducted1(:,1:round(column/3)) pure_noise_matrix noise_deducted1(:,1+round(column/3):round(2*column/3)+100) pure_noise_matrix noise_deducted1(:,101+round(2*column/3):column)];
% % figure(1)
% % mesh(new_intensity1);
% max_old = max(noise_deducted1);
% max_new = max(new_intensity1);
% max_processed = max(silence_removed1);
% figure(2)
% subplot(311);plot(max_old(1:4999));title("原始步行振动信号")
% subplot(312);plot(max_new);title("加入纯噪声")
% subplot(313);plot(max_processed);title("消除纯噪声")




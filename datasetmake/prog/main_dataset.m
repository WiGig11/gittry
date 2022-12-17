close all;clear all;clc;
%%%                                                 %%%
%%%  注：训练集不需要做这么多预处理，人工挑选了时间坐标   %%%
%%%                                                 %%%
%% 数据导入
cd 'D:\毕设\MATLAB程序整理\mat生成\mat数据\'
intensity1 = importdata('0905D20.mat');   
% figure(99);mesh(intensity1);
cd 'D:\毕设\MATLAB程序整理\特征提取+定位偏航\程序\'
%% 参数设置 
startpos1 = 100 ;endpos1 = 299; starttime = 1; Observe_Window_LEN = 500;
%% 数据预处理
noise_deducted1 = datapre(intensity1,startpos1,endpos1,starttime,length(intensity1));
% silence_removed1 = silence_removal(noise_deducted1,800); 
% num_walker1 = get_walker_num(silence_removed1);
cell_of_matrix_sig1 = matrix_div_and_reconstr4(noise_deducted1,1);
maxsig =max(cell_of_matrix_sig1{1});
%% 特征提取
features =  featureall(intensity1,startpos1,maxsig,cell_of_matrix_sig1{1},410);     
features = table(features');
%% 保存表格
writetable(features,'0905D20.csv');

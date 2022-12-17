close all;clear all;clc;
%%%
%注：训练集不需要做这么多预处理，人工挑选了时间坐标
%%%
%% 数据导入
cd 'D:\毕设\MATLAB程序整理\mat生成\mat数据\'
intensity1 = importdata('0905D7.mat');   
figure(99);mesh(intensity1);
cd 'D:\毕设\MATLAB程序整理\特征提取+定位偏航\程序\'
%% 参数设置
GAP=410;
startpos1 = 100 ;endpos1 = 299; starttime = 1; Observe_Window_LEN = 500;
%% 数据预处理
noise_deducted1 = datapre(intensity1,startpos1,endpos1,starttime,length(intensity1));
% silence_removed1 = silence_removal(noise_deducted1,800); 
% num_walker1 = get_walker_num(silence_removed1);
cell_of_matrix_sig1 = matrix_div_and_reconstr4(noise_deducted1,1);
maxsig =max(cell_of_matrix_sig1{1});

features = [];
%% 宏观特征
%%%%%%%%%%%%%%%%%%%
%% 时间-最大强度直方图 参数  方差均值比、峰值系数   
mydata1 = yuanbaoshuzu(maxsig,length(maxsig));
feature1 = extractf(mydata1,maxsig,length(maxsig));
features = [features feature1];
%% 步频
[~,num_peak,~,~,delta_peak_time] =  Rx_ana(maxsig,GAP);
[f,peak_pos,~,peak_index,delta_time_var] = get_peak_pos(maxsig,cell_of_matrix_sig1{1},num_peak,delta_peak_time,startpos1,500);  %f是再结合时间-最大强度图得到的步频，更精准
ave_time_width = get_time_width(maxsig,num_peak,peak_index);
features = [features,f,delta_time_var,ave_time_width];
disp(peak_pos);
%% 步幅
[~,average_stride] = get_stride(peak_pos);
features = [features,average_stride];
disp("步幅（单位cm）：");disp(average_stride);
step_pos_vec = round(step_pos_ana(cell_of_matrix_sig1{1},peak_index)+startpos1);
disp(step_pos_vec);
[~,average_stride2] = get_stride(step_pos_vec);
disp("步幅（单位cm）：");disp(average_stride2);
ave = get_stride2(step_pos_vec,peak_pos);

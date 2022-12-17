close all;clear all;clc;
%% 数据导入
intensity1 = importdata('4.mat');   

%% 参数设置 
startpos1 =100 ;endpos1 = 299; starttime  = 1; Observe_Window_LEN = 500;

%% 预处理（去除底噪+人数判断、矩阵切割+移除静止时间）
noise_reducted1 = datapre(intensity1,startpos1,endpos1,starttime,length(intensity1));

silence_removed1 = silence_removal(noise_reducted1); 

num_walker1 = pcount2(max(silence_removed1(:,starttime:Observe_Window_LEN),[],2),0);

[cell_of_matrix_sig1,cell_of_matrix_pos1] = matrix_div_and_reconstr4(silence_removed1,num_walker1);

max1=max(cell_of_matrix_sig1{1});
% figure(1);plot(max1)

%% 步频特征挖掘                 
%主峰值、副峰值、主副峰值比  非平稳信号可用？
[freq1,num_peak1,main_peak1,second_peak1,delta_peak_time1] =  Rx_ana(max1,410);  % NOTE:main_peak_index = length(max)
[f1,peak1_pos,~,peak1_index] = get_peak_pos(max1,silence_removed1,num_peak1,delta_peak_time1,startpos1,500);  %f是再结合时间-最大强度图得到的步频，更精准
ave_time_width = get_time_width(max1,num_peak1,peak1_index);
%% 步幅特征挖掘
[~,average_stride1,var_stride1] = get_stride(peak1_pos);

%% 能量特征挖掘
[step_energy_array1,left_side_E1,right_side_E1] = get_step_energy2(noise_reducted1,startpos1,peak1_pos,peak1_index);
mean_E1 = mean(step_energy_array1);

%% 定位:只分辨在左/右光纤上某位置点
% pos1 = get_each_step_pos(left_side_E1,right_side_E1,peak1_pos);

%% 撞击力+蹬力特征挖掘
ave_pos_width = get_pos_width(cell_of_matrix_sig1{1},Observe_Window_LEN);
%% 获取峰值位置有效时间范围内（256点）的振动信号,并输出滤波前 & 后的每一步的振动信号
[raw_sig1_group,step_sig1_group,after_hampel1] = get_each_step_sig(peak1_pos,peak1_index,intensity1);

%% 拼接各单步信号

%% 单步主成分信号时域特征提取:
after_pca1 = step_group_observe(raw_sig1_group,1,after_hampel1);  %PCA

% after_pca1 = step_group_observe(raw_sig1_group,used_fig_num,Butterworth_LPF_45_50_1dB_50dB(after_hampel1));

feature1_single_step_time_domain = extract_f_of_single_step(after_pca1);

%% DSTFT分析：目前需要大量的步数才有可能获取准确的特征参数
%parameter:有效时宽点数 & 主要成分瑞利波的中心频率 & 有效带宽 & 中心频率的左右能量比
[stft_feature_matrix1,T_width1,Rayleigh_Freq1,BW1,LR_Ratio1] = get_stft_feature(num_peak1,step_sig1_group);
[Spec_1,~] = DSTFT(after_pca1,866*2,45,866);stft_feature_pca1 = stft_ana(Spec_1,after_pca1); 
%% WT
%% HHT？
%% 二维Gabor变换？
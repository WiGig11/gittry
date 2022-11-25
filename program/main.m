close all;
% clear all;
clc;

%% 参数设置
startpos =118 ;%118
endpos = 279;  %279
starttime  = 1;
%% 数据导入 & 降噪 & 构造时间-最大强度图
cd ..
cd('G:\硕士期间\光纤传感\数据\118data');
intensity1 = importdata('DifferenceData 20221108152258188_ch1.mat');%mang
intensity2 = importdata('DifferenceData 20221108152651356_ch1.mat');%mang
intensity3 = importdata('DifferenceData 20221108152725782_ch1.mat');%zhengchang
% intensity4 = importdata('DifferenceData 20221108152615313_ch1.mat');
% intensity5 = importdata('DifferenceData 20221108152651356_ch1.mat');
% intensity6 = importdata('DifferenceData 20221108152725782_ch1.mat');
cd ..
cd('G:\硕士期间\光纤传感\数据\program');

%%
noise_reducted1 = datapre(intensity1,startpos,endpos,starttime,length(intensity1));
noise_reducted2 = datapre(intensity2,startpos,endpos,starttime,length(intensity2));
noise_reducted3 = datapre(intensity3,startpos,endpos,starttime,length(intensity3));
% noise_reducted4 = datapre(intensity1,startpos,endpos,starttime,length(intensity4));
% noise_reducted5 = datapre(intensity2,startpos,endpos,starttime,length(intensity5));
% noise_reducted6 = datapre(intensity3,startpos,endpos,starttime,length(intensity6));
% max1=max(noise_reducted1);
% max2=max(noise_reducted2);
% max3=max(noise_reducted3);
max1=max_pre(max(noise_reducted1));
max2=max_pre(max(noise_reducted2));
max3=max_pre(max(noise_reducted3));

% figure(10);mesh(intensity1);h1=title("疾走");h1.FontSize = 25;
% figure(14);mesh(intensity2);h2=title("跑步");h2.FontSize = 25;
% figure(15);mesh(intensity3);h3=title("踏步");h3.FontSize = 25;
%
% figure(1);
% subplot(3,1,1);plot(max1);h1=title("疾走");h1.FontSize = 15;
% subplot(3,1,2);plot(max2);h2=title("跑步");h2.FontSize = 15;
% subplot(3,1,3);plot(max3);h3=title("踏步");h3.FontSize = 15;

feature = [];


%% 步频特征挖掘
%主峰值、副峰值、主副峰值比  非平稳信号可用？
% figure(2);
% subplot(3,1,1);plot(xcorr(max1,length(max1)-1));h1=title("疾走");h1.FontSize = 15;
% subplot(3,1,2);plot(xcorr(max2,length(max2)-1));h2=title("跑步");h2.FontSize = 15;
% subplot(3,1,3);plot(xcorr(max3,length(max3)-1));h3=title("踏步");h3.FontSize = 15;

[freq1,num_peak1,main_peak1,second_peak1,delta_peak_time1] =  Rx_ana(max1,300);  % NOTE:main_peak_index = length(max)
[freq2,num_peak2,main_peak2,second_peak2,delta_peak_time2] =  Rx_ana(max2,300);
[freq3,num_peak3,main_peak3,second_peak3,delta_peak_time3] =  Rx_ana(max3,410);  % RUNNING! GAP = 300   踏步 GAP = 350
freq = [freq1;freq2;freq3];
feature = [feature,freq];
% disp(freq);                    %归一化 步数/minute数
% max_rx_ratio = [main_peak1/second_peak1,main_peak2/second_peak2,main_peak3/second_peak3];%非平稳信号可用？
% delta_time_para1 = get_delta_time_para(delta_peak_time1);  % %mean与freq直接相关,考虑舍去
% delta_time_para2 = get_delta_time_para(delta_peak_time2);
% delta_time_para3 = get_delta_time_para(delta_peak_time3);

%当提示设置的阈值太大时候进入函数内部设置阈值
%get_peak_pos(vec,matrix,num_peak1,delta_peak_time1,startpos,GAP,THREAD)
[f2,peak2_pos,~,peak2_index] = get_peak_pos_1(max2,noise_reducted2,num_peak2,delta_peak_time2,startpos,410);
[f1,peak1_pos,~,peak1_index] = get_peak_pos_1(max1,noise_reducted1,num_peak1,delta_peak_time1,startpos,410);  %f是再结合时间-最大强度图得到的步频，更精准

[f3,peak3_pos,~,peak3_index] = get_peak_pos_1(max3,noise_reducted3,num_peak3,delta_peak_time3,startpos,410);

%% 步幅特征挖掘
[~,average_stride1,var_stride1] = get_stride(peak1_pos);
[~,average_stride2,var_stride2] = get_stride(peak2_pos);
[~,average_stride3,var_stride3] = get_stride(peak3_pos);
stride = [average_stride1;average_stride2;average_stride3];
feature = [feature,stride];
%% 能量特征挖掘
% 统计time_range peak_pos_range内的时域能量
% [step_energy_array1,left_side_E1,right_side_E1] = get_step_energy2(noise_reducted1,startpos,peak1_pos,peak1_index);
% [step_energy_array2,left_side_E2,right_side_E2] = get_step_energy2(noise_reducted2,startpos,peak2_pos,peak2_index);
% [step_energy_array3,left_side_E3,right_side_E3] = get_step_energy2(noise_reducted3,startpos,peak3_pos,peak3_index);
[step_energy_array,left_step_energy_array,right_step_energy_array] = get_step_energy2_1(noise_reducted1,startpos,peak1_pos,peak1_index)

% figure(3)
% subplot(9,1,1);plot(noise_reducted1(peak1_pos(1)-startpos-4,peak1_index(1)-70:peak1_index(1)+70));
% subplot(9,1,2);plot(noise_reducted1(peak1_pos(1)-startpos-3,peak1_index(1)-70:peak1_index(1)+70));
% subplot(9,1,3);plot(noise_reducted1(peak1_pos(1)-startpos-2,peak1_index(1)-70:peak1_index(1)+70));
% subplot(9,1,4);plot(noise_reducted1(peak1_pos(1)-startpos-1,peak1_index(1)-70:peak1_index(1)+70));
% subplot(9,1,5);plot(noise_reducted1(peak1_pos(1)-startpos+0,peak1_index(1)-70:peak1_index(1)+70));
% subplot(9,1,6);plot(noise_reducted1(peak1_pos(1)-startpos+1,peak1_index(1)-70:peak1_index(1)+70));
% subplot(9,1,7);plot(noise_reducted1(peak1_pos(1)-startpos+2,peak1_index(1)-70:peak1_index(1)+70));
% subplot(9,1,8);plot(noise_reducted1(peak1_pos(1)-startpos+3,peak1_index(1)-70:peak1_index(1)+70));
% subplot(9,1,9);plot(noise_reducted1(peak1_pos(1)-startpos+4,peak1_index(1)-70:peak1_index(1)+70));

% mean_E1 = mean(step_energy_array1);
% mean_E2 = mean(step_energy_array2);
% mean_E3 = mean(step_energy_array3);
%
% var_mean_ratio_E1 = var(step_energy_array1)/mean_E1;
% var_mean_ratio_E2 = var(step_energy_array2)/mean_E2;
% var_mean_ratio_E3 = var(step_energy_array3)/mean_E3;
%% 定位:只分辨在左/右光纤上某位置点
% pos1 = get_each_step_pos(left_side_E1,right_side_E1,peak1_pos);
% pos2 = get_each_step_pos(left_side_E2,right_side_E2,peak2_pos);
% pos3 = get_each_step_pos(left_side_E3,right_side_E3,peak3_pos);
%% 撞击力+蹬力特征挖掘:单步非平稳信号分析
used_fig_num = 0;
%% 获取峰值位置有效时间范围内（256点）的振动信号,并输出滤波前 & 后的每一步的振动信号
[raw_sig1_group,step_sig1_group1,after_hampel1] = get_each_step_sig(peak1_pos,peak1_index,intensity1);
[raw_sig2_group,step_sig2_group1,after_hampel2] = get_each_step_sig(peak2_pos,peak2_index,intensity2);
[raw_sig3_group,step_sig3_group1,after_hampel3] = get_each_step_sig(peak3_pos,peak3_index,intensity3);

% figure(20);plot(step_sig1_group(1,:));title("疾走第一步");xlabel('时间');ylabel('幅度')

% figure(12)
% subplot(331);plot(xcorr(step_sig1_group(2,:)));title('2')
% subplot(332);plot(xcorr(step_sig1_group(3,:)));title('3')
% subplot(333);plot(xcorr(step_sig1_group(4,:)));title('4')
% subplot(334);plot(xcorr(step_sig1_group(5,:)));title('5')
% subplot(335);plot(xcorr(step_sig1_group(6,:)));title('6')
% subplot(336);plot(xcorr(step_sig1_group(7,:)));title('7')
% subplot(337);plot(xcorr(step_sig1_group(8,:)));title('8')
% subplot(338);plot(xcorr(step_sig1_group(9,:)));title('9')
% subplot(339);plot(xcorr(step_sig1_group(10,:)));title('10')

%% 单步信号时域特征提取:
after_pca1 = step_group_observe(raw_sig1_group,used_fig_num,after_hampel1);  %PCA
after_pca2 = step_group_observe(raw_sig2_group,used_fig_num+1,after_hampel2);
after_pca3 = step_group_observe(raw_sig3_group,used_fig_num+2,after_hampel3);

% after_pca1 = step_group_observe(raw_sig1_group,used_fig_num,Butterworth_LPF_45_50_1dB_50dB(after_hampel1));
% after_pca2 = step_group_observe(raw_sig2_group,used_fig_num+1,Butterworth_LPF_45_50_1dB_50dB(after_hampel2));
% after_pca3 = step_group_observe(raw_sig3_group,used_fig_num+2,Butterworth_LPF_45_50_1dB_50dB(after_hampel3));

feature1_single_step_time_domain = extract_f_of_single_step(after_pca1);
feature2_single_step_time_domain = extract_f_of_single_step(after_pca2);
feature3_single_step_time_domain = extract_f_of_single_step(after_pca3);
feature_single = [feature1_single_step_time_domain;feature2_single_step_time_domain;feature3_single_step_time_domain];
feature = [feature feature_single];

%% DSTFT分析：目前需要大量的步数才有可能获取准确的特征参数
%parameter:有效时宽点数 & 主要成分瑞利波的中心频率 & 有效带宽 & 中心频率的左右能量比
% [stft_feature_matrix3,T_width3,Rayleigh_Freq3,BW3,LR_Ratio3] = get_stft_feature(num_peak3,step_sig3_group);
% [stft_feature_matrix2,T_width2,Rayleigh_Freq2,BW2,LR_Ratio2] = get_stft_feature(num_peak2,step_sig2_group);
% [stft_feature_matrix1,T_width1,Rayleigh_Freq1,BW1,LR_Ratio1] = get_stft_feature(num_peak1,step_sig1_group);

% [Spec_1,~] = DSTFT(after_pca1,866*2,45,866);stft_feature_pca1 = stft_ana(Spec_1,after_pca1);
% [Spec_2,~] = DSTFT(after_pca2,866*2,45,866);stft_feature_pca2 = stft_ana(Spec_2,after_pca2);
% [Spec_3,~] = DSTFT(after_pca3,866*2,45,866);stft_feature_pca3 = stft_ana(Spec_3,after_pca3);
% stftana = [stft_feature_pca1;stft_feature_pca2;stft_feature_pca3];
% feature = [feature stftana];
% % figure(188);mesh(Spec_1);
% matrix_1 = [after_pca1;
%     after_pca2;
%     after_pca3];
%% HHT
%对一维信号进行分解
% m1 = after_pca2;
% imf = hht(m1);
% [f1_matrix,hhtfeature1] = hhtfretrans(hht(after_pca1),0);
% [f2_matrix,hhtfeature2] = hhtfretrans(hht(after_pca2),0);
% [f3_matrix,hhtfeature3] = hhtfretrans(hht(after_pca3),0);
% hhtf = [hhtfeature1;hhtfeature2;hhtfeature3];
% feature = [feature hhtf];

%% WVD分布?
% 计算Wigner-Ville分布
% [tfr(Wigner-Ville分布), t(时间坐标), f(频率坐标)] = tfrwv(离散信号x, 时间t, 频率点数N)
%也可以使用wvd函数

%% 单步二维
%提取一步周围时间和位置的信号，作为备用的二维信号
step_sig1_group2 = get_each_step_sig2(peak1_pos,peak1_index,intensity1);
step_sig2_group2 = get_each_step_sig2(peak2_pos,peak2_index,intensity2);
step_sig3_group2 = get_each_step_sig2(peak3_pos,peak3_index,intensity3);

% mesh(step_sig1_group2{2,1})
% xlabel('时间n');
% ylabel('以最大位置为中心的附近9个传感器');

%% 时域二维特征尝试
% [pattern12,~] = eigendivide(step_sig1_group2);
% [pattern22,~] = eigendivide(step_sig2_group2);
% [pattern32,~] = eigendivide(step_sig3_group2);
% timef1 = gatpatternf(pattern12);
% timef2 = gatpatternf(pattern22);
% timef3 = gatpatternf(pattern32);
% timef = [timef1;timef2;timef3];
% feature = [feature timef];
%输出欧式几何距离作为分裂标准
%% WT
[cA1,cD1] = dwt_3_wave(step_sig1_group2,'db4',used_fig_num); %一次调用 出三张图
[cA2,cD2] = dwt_3_wave(step_sig2_group2,'db4',used_fig_num); %一次调用 出三张图
[cA3,cD3] = dwt_3_wave(step_sig3_group2,'db4',used_fig_num); %一次调用 出三张图

% wtf = [get_feature(cA1);get_feature(cA2);get_feature(cA3)];
% feature = [feature wtf];
% [temp1.temp2,feature] = image_compare(matrix_12,matrix_32,'sym4',used_fig_num+3);
%% 二维Gabor变换
% 二维
% I =step_sig2_group2;
% w = 5;
% theta = [0,30,60,90];
% [~,gaborfeature,gaborfidx] = gabortrans(I,w,theta);
%需要保存的矩阵
%行名称

% feature = table(feature);
% %保存表格
% writetable(feature, 'test.csv');








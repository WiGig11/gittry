close all;clear all;clc;
%% �������� 
% startpos1 = 100 ;endpos1 = 290; 
startpos1 = 185 ;endpos1 = 232; 
startpos23 = 185;endpos23 = 212;  
starttime  = 1;

%% ���ݵ��� & Ԥ����ȥ������+�����жϡ������и�+�Ƴ���ֹʱ�䣩
intensity1 = importdata('B2.mat');   
intensity2 = importdata('B1.mat');
intensity3 = importdata('B3.mat');
noise_reducted1 = datapre(intensity1,startpos1,endpos1,starttime,length(intensity1));
noise_reducted2 = datapre(intensity2,startpos23,endpos23,starttime,length(intensity2));
noise_reducted3 = datapre(intensity3,startpos23,endpos23,starttime,length(intensity3));

% num_walker1 = get_wallker_num(noise_reducted1(:,2401:15000),starttime);
num_walker1 = get_wallker_num(noise_reducted1,starttime);
num_walker2 = get_wallker_num(noise_reducted2,starttime);
num_walker3 = get_wallker_num(noise_reducted3,starttime);

%To be debugged later
% [cell_of_matrix_sig1,cell_of_matrix_pos1] = matrix_div_and_reconstr2(noise_reducted1,num_walker1);
% cell_of_matrix_sig2 = matrix_div_and_reconstr2(noise_reducted2,num_walker2);
% cell_of_matrix_sig3 = matrix_div_and_reconstr2(noise_reducted3,num_walker3);

% figure(1);
% mesh(noise_reducted1);
% subplot(311);mesh(noise_reducted1(:,1:7200));title('Person A+B')
% subplot(311);mesh(noise_reducted1);title('Person A+B')
% subplot(312);mesh(cell_of_matrix_sig1{1});title('After Division: Person A')
% subplot(313);mesh(cell_of_matrix_sig1{2});title('After Division: Person B')

%%% Silence Removal

% max11=max_pre(max(cell_of_matrix_sig1{1}));
% max12=max_pre(max(cell_of_matrix_sig1{2}));
% max2=max_pre(max(cell_of_matrix_sig2{1}));
% max3=max_pre(max(cell_of_matrix_sig3{1}));
max1=max_pre(max(noise_reducted1));
max2=max_pre(max(noise_reducted2));
max3=max_pre(max(noise_reducted3));
%ʱ���ֵ�ּ�����>Interval_THREAD
%Silence Removal:Interval >= 2*Interval_THREAD �ж�ΪSilence

% pure_noise = max3(1680:1979);%300������
% max11 = zeros(1,5500);
% max11(1:3000) = max1(1:3000); 
% for k = 1:5
%     max11(3001+(k-1)*300:3300+(k-1)*300) = pure_noise;
% end        
% max11(4501:5500)= max1(4001:5000);

% figure(10);mesh(intensity1);    % h1=title("����");h1.FontSize = 25;
% figure(14);mesh(intensity2);
% figure(15);mesh(intensity3);
% % 
figure(1);
subplot(3,1,1);plot(max1);
subplot(3,1,2);plot(max2);
subplot(3,1,3);plot(max3);

%% ������ȡ ʱ��-���ǿ��ͼ �Ĳ���  (��������,���ڸ�������ƽ���źſ��ã�
%����? ��ͳ�����������ֵ�ȡ���ֵϵ��   
% n = 2500;
% mydata1 = yuanbaoshuzu(max1,n);features1 = extractf(mydata1,max1,n);
% mydata2 = yuanbaoshuzu(max2,n);features2 = extractf(mydata2,max2,n);
% mydata3 = yuanbaoshuzu(max3,n);features3 = extractf(mydata3,max3,n);

%% ��Ƶ�����ھ�                 
%����ֵ������ֵ��������ֵ��  ��ƽ���źſ��ã�
figure(3);
subplot(3,1,1);plot(xcorr(max1));
subplot(3,1,2);plot(xcorr(max2));
subplot(3,1,3);plot(xcorr(max3));
% 
[freq1,num_peak1,~,~,delta_peak_time1] =  Rx_ana(max1,410);  % NOTE:main_peak_index = length(max)
[freq2,num_peak2,~,~,delta_peak_time2] =  Rx_ana(max2,410);
[freq3,num_peak3,~,~,delta_peak_time3] =  Rx_ana(max3,410);  % RUNNING! GAP = 300   ̤�� GAP = 350 

[f1,peak1_pos,peak1_value,~,delta_step_time_var1] = get_peak_pos(max1,noise_reducted1,num_peak1,delta_peak_time1,startpos1,500);  %f���ٽ��ʱ��-���ǿ��ͼ�õ��Ĳ�Ƶ������׼
[f2,peak2_pos,peak2_value,~,delta_step_time_var2] = get_peak_pos(max2,noise_reducted2,num_peak2,delta_peak_time2,startpos23,500);
[f3,peak3_pos,peak3_value,~,delta_step_time_var3] = get_peak_pos(max3,noise_reducted3,num_peak3,delta_peak_time3,startpos23,500);

% % delta_step_time_mean��freq��Ч,��ʱ��ȥ  
% % peak_value ��ӳ������������������أ������ڼ򵥼������������޷��������ƫ�;��е��߷�
freq = [f1,f2,f3];
disp(freq);  
%% ���������ھ�       debug
[~,average_stride1,var_stride1] = get_stride(peak1_pos);
[~,average_stride2,var_stride2] = get_stride(peak2_pos);
[~,average_stride3,var_stride3] = get_stride(peak3_pos);

%% ���������ھ�       debug
% ͳ��time_range peak_pos_range�ڵ�ʱ������
[step_energy_array,left_step_energy_array,right_step_energy_array] = get_step_energy2(noise_reducted,startpos,peak_pos,peak_index)

% [step_energy_array1,left_side_E1,right_side_E1] = get_step_energy2(noise_reducted1,startpos1,peak1_pos,peak1_index);
% [step_energy_array2,left_side_E2,right_side_E2] = get_step_energy2(noise_reducted2,startpos23,peak2_pos,peak2_index);
% [step_energy_array3,left_side_E3,right_side_E3] = get_step_energy2(noise_reducted3,startpos23,peak3_pos,peak3_index);

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

% var_mean_ratio_E1 = var(step_energy_array1)/mean_E1;
% var_mean_ratio_E2 = var(step_energy_array2)/mean_E2;
% var_mean_ratio_E3 = var(step_energy_array3)/mean_E3;
%% ��λ:ֻ�ֱ�����/�ҹ�����ĳλ�õ�
% pos1 = get_each_step_pos(left_side_E1,right_side_E1,peak1_pos);
% pos2 = get_each_step_pos(left_side_E2,right_side_E2,peak2_pos);
% pos3 = get_each_step_pos(left_side_E3,right_side_E3,peak3_pos);
%% ײ����+���������ھ�:������ƽ���źŷ���
% used_fig_num = 6;
%% ��ȡ��ֵλ����Чʱ�䷶Χ�ڣ�256�㣩�����ź�,������˲�ǰ & ���ÿһ�������ź�
% [raw_sig1_group,step_sig1_group,after_hampel1] = get_each_step_sig(peak1_pos,peak1_index,intensity1);
% [raw_sig2_group,step_sig2_group,after_hampel2] = get_each_step_sig(peak2_pos,peak2_index,intensity2);
% [raw_sig3_group,step_sig3_group,after_hampel3] = get_each_step_sig(peak3_pos,peak3_index,intensity3);
% figure(20);plot(step_sig1_group(1,:));title("���ߵ�һ��");xlabel('ʱ��');ylabel('����')

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

%% �����ź�ʱ��������ȡ:
% after_pca1 = step_group_observe(raw_sig1_group,used_fig_num,after_hampel1);  %PCA
% after_pca2 = step_group_observe(raw_sig2_group,used_fig_num+1,after_hampel2);
% after_pca3 = step_group_observe(raw_sig3_group,used_fig_num+2,after_hampel3);

% after_pca1 = step_group_observe(raw_sig1_group,used_fig_num,Butterworth_LPF_45_50_1dB_50dB(after_hampel1));
% after_pca2 = step_group_observe(raw_sig2_group,used_fig_num+1,Butterworth_LPF_45_50_1dB_50dB(after_hampel2));
% after_pca3 = step_group_observe(raw_sig3_group,used_fig_num+2,Butterworth_LPF_45_50_1dB_50dB(after_hampel3));

% feature1_single_step_time_domain = extract_f_of_single_step(after_pca1);
% feature2_single_step_time_domain = extract_f_of_single_step(after_pca2);
% feature3_single_step_time_domain = extract_f_of_single_step(after_pca3);

%% DSTFT������Ŀǰ��Ҫ�����Ĳ������п��ܻ�ȡ׼ȷ����������
%parameter:��Чʱ����� & ��Ҫ�ɷ�������������Ƶ�� & ��Ч���� & ����Ƶ�ʵ�����������
% [stft_feature_matrix3,T_width3,Rayleigh_Freq3,BW3,LR_Ratio3] = get_stft_feature(num_peak3,step_sig3_group);
% [stft_feature_matrix2,T_width2,Rayleigh_Freq2,BW2,LR_Ratio2] = get_stft_feature(num_peak2,step_sig2_group);
% [stft_feature_matrix1,T_width1,Rayleigh_Freq1,BW1,LR_Ratio1] = get_stft_feature(num_peak1,step_sig1_group);
% 
% [Spec_1,~] = DSTFT(after_pca1,866*2,45,866);stft_feature_pca1 = stft_ana(Spec_1,after_pca1); 
% [Spec_2,~] = DSTFT(after_pca2,866*2,45,866);stft_feature_pca2 = stft_ana(Spec_2,after_pca2); 
% [Spec_3,~] = DSTFT(after_pca3,866*2,45,866);stft_feature_pca3 = stft_ana(Spec_3,after_pca3); 
% figure(188);mesh(Spec_1);
%% WT

%% HHT��
%% ��άGabor�任��
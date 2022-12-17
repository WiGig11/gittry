close all;clear all;clc;
%% �������� 
startpos1 = 100 ;endpos1 = 299;     %9 10 12 
starttime = 1;Observe_Window_LEN = 500;
%% ���ݵ��� & Ԥ����ȥ������+�Ƴ���ֹʱ��+�����ж�+�����и
% intensity1 = importdata('1107_10_1w5.mat');   
intensity1 = importdata('4-1.mat');   
noise_deducted1 = datapre(intensity1,startpos1,endpos1,starttime,length(intensity1));

silence_removed1 = silence_removal(noise_deducted1); 

num_walker1 = pcount2(max(silence_removed1(:,starttime:Observe_Window_LEN),[],2),0);

[cell_of_matrix_sig1,cell_of_matrix_pos1] = matrix_div_and_reconstr4(silence_removed1,num_walker1);

% figure(1)
% subplot(311);mesh(silence_removed1(:,1:5000));title('Person A+B')  %9
% % subplot(311);mesh(silence_removed1);title('Person A+B')  %10
% % subplot(311);mesh(noise_deducted1);title('Person A+B')
% subplot(312);mesh(cell_of_matrix_sig1{1});title('After Division: Person A')
% subplot(313);mesh(cell_of_matrix_sig1{2});title('After Division: Person B')

%% Get Max Intensity Vector of Time Domain
% max11=max(cell_of_matrix_sig1{1});
% max12=max(cell_of_matrix_sig1{2});

% max1=max(noise_reducted1);
% max2=max(noise_reducted2);
% max3=max(noise_reducted3);

% figure(8);
% subplot(3,1,1);plot(max1);
% subplot(3,1,2);plot(max2);
% subplot(3,1,3);plot(max3);

%% ��Ƶ�����ھ�                 
% 
% [~,num_peak1,~,~,delta_peak_time1] =  Rx_ana(max11,410);  % NOTE:main_peak_index = length(max)
% [~,num_peak2,~,~,delta_peak_time2] =  Rx_ana(max12,410);
% 
% [f1,peak1_pos,peak1_value,peak1_index,delta_step_time_var1] = get_peak_pos(max11,cell_of_matrix_sig1{1},num_peak1,delta_peak_time1,startpos1,500);  %f���ٽ��ʱ��-���ǿ��ͼ�õ��Ĳ�Ƶ������׼
% [f2,peak2_pos,peak2_value,peak2_index,delta_step_time_var2] = get_peak_pos(max12,cell_of_matrix_sig1{2},num_peak2,delta_peak_time2,startpos1,500);
% 

%% ���������ھ�       
% [~,average_stride1,var_stride1] = get_stride(peak1_pos);
% [~,average_stride2,var_stride2] = get_stride(peak2_pos);

%% ���������ھ�       
% ͳ��time_range peak_pos_range�ڵ�ʱ������
% [step_energy_array1,left_side_E1,right_side_E1] = get_step_energy2(cell_of_matrix_sig1{1},startpos1,peak1_pos,peak1_index);
% [step_energy_array2,left_side_E2,right_side_E2] = get_step_energy2(cell_of_matrix_sig1{2},startpos1,peak2_pos,peak2_index);
% 
% mean_E1 = mean(step_energy_array1);
% mean_E2 = mean(step_energy_array2);

%% ��λ:ֻ�ֱ�����/�ҹ�����ĳλ�õ�
% pos1 = get_each_step_pos(left_side_E1,right_side_E1,peak1_pos);
% pos2 = get_each_step_pos(left_side_E2,right_side_E2,peak2_pos);

%% ƫ��ä���ж�
% warning1 = deviation_judge(1,left_side_E1,right_side_E1);
% warning2 = deviation_judge(1,left_side_E2,right_side_E2);

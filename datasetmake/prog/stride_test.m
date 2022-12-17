close all;clear all;clc;
%%%
%ע��ѵ��������Ҫ����ô��Ԥ�����˹���ѡ��ʱ������
%%%
%% ���ݵ���
cd 'D:\����\MATLAB��������\mat����\mat����\'
intensity1 = importdata('0905D7.mat');   
figure(99);mesh(intensity1);
cd 'D:\����\MATLAB��������\������ȡ+��λƫ��\����\'
%% ��������
GAP=410;
startpos1 = 100 ;endpos1 = 299; starttime = 1; Observe_Window_LEN = 500;
%% ����Ԥ����
noise_deducted1 = datapre(intensity1,startpos1,endpos1,starttime,length(intensity1));
% silence_removed1 = silence_removal(noise_deducted1,800); 
% num_walker1 = get_walker_num(silence_removed1);
cell_of_matrix_sig1 = matrix_div_and_reconstr4(noise_deducted1,1);
maxsig =max(cell_of_matrix_sig1{1});

features = [];
%% �������
%%%%%%%%%%%%%%%%%%%
%% ʱ��-���ǿ��ֱ��ͼ ����  �����ֵ�ȡ���ֵϵ��   
mydata1 = yuanbaoshuzu(maxsig,length(maxsig));
feature1 = extractf(mydata1,maxsig,length(maxsig));
features = [features feature1];
%% ��Ƶ
[~,num_peak,~,~,delta_peak_time] =  Rx_ana(maxsig,GAP);
[f,peak_pos,~,peak_index,delta_time_var] = get_peak_pos(maxsig,cell_of_matrix_sig1{1},num_peak,delta_peak_time,startpos1,500);  %f���ٽ��ʱ��-���ǿ��ͼ�õ��Ĳ�Ƶ������׼
ave_time_width = get_time_width(maxsig,num_peak,peak_index);
features = [features,f,delta_time_var,ave_time_width];
disp(peak_pos);
%% ����
[~,average_stride] = get_stride(peak_pos);
features = [features,average_stride];
disp("��������λcm����");disp(average_stride);
step_pos_vec = round(step_pos_ana(cell_of_matrix_sig1{1},peak_index)+startpos1);
disp(step_pos_vec);
[~,average_stride2] = get_stride(step_pos_vec);
disp("��������λcm����");disp(average_stride2);
ave = get_stride2(step_pos_vec,peak_pos);

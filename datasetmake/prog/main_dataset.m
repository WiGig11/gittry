close all;clear all;clc;
%%%                                                 %%%
%%%  ע��ѵ��������Ҫ����ô��Ԥ�����˹���ѡ��ʱ������   %%%
%%%                                                 %%%
%% ���ݵ���
cd 'D:\����\MATLAB��������\mat����\mat����\'
intensity1 = importdata('0905D20.mat');   
% figure(99);mesh(intensity1);
cd 'D:\����\MATLAB��������\������ȡ+��λƫ��\����\'
%% �������� 
startpos1 = 100 ;endpos1 = 299; starttime = 1; Observe_Window_LEN = 500;
%% ����Ԥ����
noise_deducted1 = datapre(intensity1,startpos1,endpos1,starttime,length(intensity1));
% silence_removed1 = silence_removal(noise_deducted1,800); 
% num_walker1 = get_walker_num(silence_removed1);
cell_of_matrix_sig1 = matrix_div_and_reconstr4(noise_deducted1,1);
maxsig =max(cell_of_matrix_sig1{1});
%% ������ȡ
features =  featureall(intensity1,startpos1,maxsig,cell_of_matrix_sig1{1},410);     
features = table(features');
%% ������
writetable(features,'0905D20.csv');

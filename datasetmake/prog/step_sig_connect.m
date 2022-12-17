function [output_vec1,output_vec2] = step_sig_connect(step_sig_matrix,used_fig_num)
%STEP_SIG_CONNECT ƴ�Ӹ������ź�
%output_vec1��0�ָ���output_vec2����0
Thread = 0.90;
[N_step,Sig_LEN] = size(step_sig_matrix);
LS_index = zeros(1,N_step);
RS_index = zeros(1,N_step);
len_count = 0;
%% ����ÿ���ź�����edge
for i = 1:N_step
    temp_E = 0;
    E = energy_count(step_sig_matrix(i,:));
    [~,peak_index] = max(step_sig_matrix(i,:));
    count = 1;
    temp_LS = peak_index-1;
    temp_RS = peak_index+1;
    temp_E = temp_E + step_sig_matrix(i,peak_index)^2;
    while(count < Sig_LEN && temp_E <= Thread*E)
        if mod(count,2) ==1
            temp_E = temp_E + step_sig_matrix(i,temp_LS)^2;
            temp_LS = temp_LS-1;
        else
            temp_E = temp_E + step_sig_matrix(i,temp_RS)^2;
            temp_RS = temp_RS+1;
        end
        count = count+1;
    end
    if mod(count,2)==1
        LS_index(i) = temp_LS;
        RS_index(i) = temp_RS-1;
    else
            LS_index(i) = temp_LS+1;
            RS_index(i) = temp_RS;
    end
    len_count = len_count + count;
end
%% ƴ��
output_vec1 = zeros(1,len_count+(N_step-1)*100);  %��0
output_vec2 = zeros(1,len_count);                 %����0
%%%
temp_start = 1;
for i = 1:N_step                
    single_step_len = RS_index(i)-LS_index(i)+1;
    output_vec1(temp_start:temp_start+single_step_len-1) = step_sig_matrix(i,LS_index(i):RS_index(i));
    output_vec1(temp_start+single_step_len:temp_start+single_step_len+99) = zeros(1,100);
    temp_start = temp_start+single_step_len+100;
end
%%%
temp_start = 1;
for i = 1:N_step           
    single_step_len = RS_index(i)-LS_index(i)+1;
    output_vec2(temp_start:temp_start+single_step_len-1) = step_sig_matrix(i,LS_index(i):RS_index(i));
    temp_start = temp_start+single_step_len;
end
%% ��ͼ
% figure(used_fig_num+1)
% subplot(211);plot(output_vec1);
% title("����ƴ�Ӻ��ź�(��0�ָ�)")
% subplot(212);plot(output_vec2);
% title("����ƴ�Ӻ��ź�")
end


function output_matrix = silence_removal(raw_matrix,Frame_LEN)
%SILENCE_REMOVAL:Remove Silence periods in raw Sig. Matrix
%basic logic:t-max_intensityΪ�գ���������POS��Χ�ڿ�
%��ԭSilence Removal�㷨�Ͻ�������Ӧ�Ľ������Ƶ�֡����Frame_LEN ��������ֵEnergy_THread   1207Ч��һ��
%NEW VERSION to be updated:����ԭ���Ӽ��   1207���
[row,~]=size(raw_matrix);
output_matrix = [];
output_matrix_temp = [];
max_vector = max(raw_matrix);
N = length(max_vector);
%% ����������ֵ
Energy_THread = 0.008;                              %����
%% ��֡ && ���֡����   NOTE:floor
N_frame = floor(N/Frame_LEN);
flag = zeros(1,N_frame);              %0:WALKING      1:SILENCE
Frame_E = zeros(1,N_frame);
for i = 1:N_frame
    for j = 1+(i-1)*Frame_LEN:i*Frame_LEN-1
        Frame_E(i) = max_vector(j)^2+Frame_E(i); 
    end
end

%% �ж�
for i = 1:N_frame
    if Frame_E(i) > Energy_THread
        flag(i) = 0;
    else
        flag(i) = 1;
    end
end
%% ��ͣ��������
walk_stop_walk_Counter = 0;
before_silence_index = [];
after_silence_index =[];
for i = 1:N_frame-2
    if flag(i)==0
        if flag(i+1)==1
            j=i+1;
            while(j<=N_frame-1 && flag(j)==1)
                j=j+1;
            end
            if j+1 < N_frame && flag(j+1)==0
                walk_stop_walk_Counter = walk_stop_walk_Counter+1;
                before_silence_index = [before_silence_index i];
                after_silence_index =[after_silence_index j];
            end
        end
    end
end

%% ��֡�ϳɣ��������
frame_num_selected = [];
for i = 1:N_frame
    if flag(i) == 0
        output_matrix_temp = [output_matrix_temp raw_matrix(:,1+(i-1)*Frame_LEN:i*Frame_LEN)];
        frame_num_selected = [frame_num_selected i];
%         output_matrix = output_matrix_temp;%
    end
end
max_temp = max(output_matrix_temp);
%% ��ͣ���������
if walk_stop_walk_Counter ~=0
    %get delta time
    delta_time = [];
    [~,num_peak_temp,~,~,delta_t] = Rx_ana(max_vector(1+(frame_num_selected(1)-1)*Frame_LEN:before_silence_index(1)*Frame_LEN),410);
    
    if num_peak_temp >=2
        delta_time = [delta_time mean(delta_t)];
    else
        delta_time = [delta_time 410];
    end
    
    if walk_stop_walk_Counter >=2
        for i=2:1:walk_stop_walk_Counter
            [~,num_peak_temp,~,~,delta_t] = Rx_ana(max_vector(1+(after_silence_index(i-1)-1)*Frame_LEN:before_silence_index(i)*Frame_LEN),410);
            if num_peak_temp >=2
                delta_time = [delta_time mean(delta_t)];
            else
                delta_time = [delta_time 410];
            end
        end
    end
    
    %����ع��� ��ͣ�ߡ�>���� �ļ�������貹��
    count = 0;
    for k = 1:length(frame_num_selected)-1
        zero_zero_gap = 0;
        if frame_num_selected(k+1)-frame_num_selected(k) ~= 1                    %��ͣ�ߡ�>����
            count = count+1; 
            LS_index = k*Frame_LEN;
            RS_index = k*Frame_LEN+1;
            while(LS_index>=0 && max_temp(LS_index) == 0)                         %����������0��λ��
                LS_index = LS_index-1;
            end
            while(RS_index<=length(max_temp) && max_temp(RS_index) == 0)          %����������0��λ��
                RS_index = RS_index+1;
            end
            zero_zero_gap = RS_index-LS_index;
            %%%�Ƚ�
            if zero_zero_gap < delta_time(count)
                %%%insert 0 to output_matrix_temp
                insert_num = round(delta_time(count)-zero_zero_gap);
                output_matrix = [output_matrix_temp(:,1:LS_index) zeros(row,insert_num) output_matrix_temp(:,LS_index+1:length(max_temp))];
            end
        end
    end
else
    output_matrix = output_matrix_temp;
end
%% ����
end
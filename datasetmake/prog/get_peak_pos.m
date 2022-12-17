function [step_freq_accurate,peak_pos,peak_value,peak_index,delta_step_time_var] = get_peak_pos(vec,matrix,num_peak,delta_peak_time,startpos,Obsv_WIN_LEN)
%get_peak_pos �õ����ǿ�ȵĲ��������������
THREAD = 0.025;
%% Version 2�� ͨ������ָʾ��get first peak    
for i = 1:floor(length(vec)/Obsv_WIN_LEN)
    temp = 0;
    for j = 1+(i-1)*Obsv_WIN_LEN:Obsv_WIN_LEN*i
        temp = vec(j)^2 + temp;
    end
    if(temp >= THREAD)
        pointer = i;
        break;
    end
end

[first_peak,first_peak_index] = max(vec(1+(pointer-1)*Obsv_WIN_LEN:Obsv_WIN_LEN*pointer));%��������һ����ֵ�㣬��Ϊ1��Obsv_WIN_LEN��ֻ��1����

%% Get other peaks'time-index & parameters related
suspect_peak_index = zeros(1,num_peak);   %�洢������������㣺���������ط������
peak_index = zeros(1,num_peak);
peak_value = zeros(1,num_peak);
peak_pos = zeros(1,num_peak);
delta_step_time = zeros(1,num_peak-1);
peak_value(1) = first_peak;
peak_index(1) = first_peak_index;
suspect_peak_index(1) = first_peak_index;

SEARCH_RANGE_H = 300;        %���������Χ��11.21�޸ģ���Ϊ����ط��������С��ʱ��Բ�׼��delta_peak_time���������⣬������Ҫ�����ֵ

for i = 2:num_peak                               
    suspect_peak_index(i) = peak_index(i-1)+delta_peak_time(i-1);   %�㾦֮�ʣ�peak_index���suspect_peak_index����û������ۻ�
    %������
    if suspect_peak_index(i)+SEARCH_RANGE_H > length(vec)
        M = length(vec);
    else
        M = suspect_peak_index(i)+SEARCH_RANGE_H;
    end
    %���������
    [peak_value(i),peak_index(i)] = max(vec(suspect_peak_index(i)-SEARCH_RANGE_H:M));
    peak_index(i) = peak_index(i) + suspect_peak_index(i)-SEARCH_RANGE_H-1;  %�ض�ȡmax���ӻ�ƫ����
end

for j = 1:num_peak-1
    delta_step_time(j) = peak_index(j+1)-peak_index(j);
end
delta_step_time_var = var(delta_step_time);
%% get pos of each peak                
for j = 1:num_peak
    [~,peak_pos(j)] = max(matrix(:,peak_index(j)));
    peak_pos(j) = peak_pos(j) + startpos - 1;
end
%% freq count
step_freq_accurate = (num_peak-1)/((peak_index(num_peak)-peak_index(1))/(866*60));
end



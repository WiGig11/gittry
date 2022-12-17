function [step_freq_accurate,peak_pos,peak_value,peak_index,delta_step_time_var] = get_peak_pos(vec,matrix,num_peak,delta_peak_time,startpos,Obsv_WIN_LEN)
%get_peak_pos 得到最大强度的采样传感器的序号
THREAD = 0.025;
%% Version 2： 通过能量指示器get first peak    
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

[first_peak,first_peak_index] = max(vec(1+(pointer-1)*Obsv_WIN_LEN:Obsv_WIN_LEN*pointer));%简单搜索第一个峰值点，认为1：Obsv_WIN_LEN内只有1个峰

%% Get other peaks'time-index & parameters related
suspect_peak_index = zeros(1,num_peak);   %存储各峰搜索的起点：起点由自相关峰间隔算得
peak_index = zeros(1,num_peak);
peak_value = zeros(1,num_peak);
peak_pos = zeros(1,num_peak);
delta_step_time = zeros(1,num_peak-1);
peak_value(1) = first_peak;
peak_index(1) = first_peak_index;
suspect_peak_index(1) = first_peak_index;

SEARCH_RANGE_H = 300;        %半边搜索范围，11.21修改，因为自相关峰在信噪比小的时候对不准，delta_peak_time部分有问题，所以需要增大该值

for i = 2:num_peak                               
    suspect_peak_index(i) = peak_index(i-1)+delta_peak_time(i-1);   %点睛之笔，peak_index替代suspect_peak_index，就没有误差累积
    %输入检查
    if suspect_peak_index(i)+SEARCH_RANGE_H > length(vec)
        M = length(vec);
    else
        M = suspect_peak_index(i)+SEARCH_RANGE_H;
    end
    %输入检查结束
    [peak_value(i),peak_index(i)] = max(vec(suspect_peak_index(i)-SEARCH_RANGE_H:M));
    peak_index(i) = peak_index(i) + suspect_peak_index(i)-SEARCH_RANGE_H-1;  %截断取max，加回偏移量
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



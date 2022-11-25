function [flag,average_stride] = stride_ana(vec)
%stride_ana 步幅分析:获得行走状态+平均每步的距离
flag_low_group = -1;
flag_high_group = -1;           % 0:原地踏步  1：前进  2：后退
N = length(vec);
mean_vec = mean(vec);
MAX_RANGE = 80;
MAX_DELTA = 2;
MID=200;          %203.5
low_group = [];
low_group_raw_num = [];
high_group = [];
high_group_raw_num = [];
trash_group = [];
%% 分组
for i = 1:N
    if vec(i)> MID
        high_group = [high_group vec(i)];
        high_group_raw_num = [high_group_raw_num i];
    else
        low_group = [low_group vec(i)];
        low_group_raw_num = [low_group_raw_num i];
    end
end
%% 剔除low group异常点
for j = 1:length(low_group)    
    if abs(low_group(j) - mean_vec) >= MAX_RANGE
        trash_group = [trash_group low_group(j)];
        low_group(j) = 0;
    end
end
%% 判断2组各自走势
k = 1;   %high:k<->x
release = 0;
while(k < length(high_group) && release == 0)
    if high_group(k) > 0
        release = 1;
    else
        k = k + 1;
    end
end

x = length(high_group);
release = 0;
while(x > k && release == 0)
    if high_group(x) > 0
        release = 1;
        flag_high_group = compare1(high_group(k),high_group(x),MAX_DELTA);
    else
        x = x-1;
    end
end

g = 1;    %low:g<->p
release = 0;
while(g < length(low_group) && release == 0)
    if low_group(g) > 0
        release = 1;
    else
        g = g + 1;
    end
end

p = length(low_group);
release = 0;
while(p > k && release == 0)
    if low_group(p) > 0
        release = 1;
        flag_low_group = compare1(low_group(g),low_group(p),MAX_DELTA);
    else
        p = p-1;
    end
end   

%% 计算平均步幅
if flag_high_group + flag_low_group ~= 0
    step_num_high = high_group_raw_num(x) - high_group_raw_num(k);   
    step_num_low = low_group_raw_num(p) - low_group_raw_num(g);

    average_stride1 = abs(high_group(x)-high_group(k))/step_num_high;
    average_stride2 = abs(low_group(p)-low_group(g))/step_num_low;    
end

if length(high_group) > length(low_group)
    average_stride = average_stride1;
    flag = flag_high_group;
elseif length(high_group) < length(low_group)
    average_stride = average_stride2;
    flag = flag_low_group;
else
    average_stride = 0.5*(average_stride1 + average_stride2);
    flag = flag_low_group;
end
end

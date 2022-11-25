function [flag,average_stride,var_stride] = get_stride(vec)
%stride_ana 步幅分析:获得行走状态+平均每步的距离
%low group 左光纤  high_group 右光纤
%flag = -1:未检测到步数  0:原地踏步  1：相对左光纤向上  2：相对左光纤向下
%输入peak_pos
flag_low_group = -1;
flag_high_group = -1;
MAX_DELTA = 2;
MID=200;      %197.5
N = length(vec);

low_group = [];
low_group_raw_num = [];
high_group = [];
high_group_raw_num = [];
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
N_high = length(high_group);
N_low = length(low_group);
if N_high > 1
    stride_high_group = zeros(1,N_high-1);
end
if N_low > 1
    stride_low_group = zeros(1,N_low-1);
end

%% 判断2组各自走势 && 分组计算POS差分值 
if(~isempty(high_group))
    flag_high_group = compare1(high_group(1),high_group(N_high),MAX_DELTA);
end

if(~isempty(low_group))
        flag_low_group = compare1(low_group(1),low_group(N_low),MAX_DELTA);
end 

if N_high > 1
    for k = 1:N_high-1
        stride_high_group(k)= abs(high_group(k) - high_group(k+1))/(high_group_raw_num(k+1)-high_group_raw_num(k));
    end
else
    stride_high_group = 0;
end
if N_low > 1
    for k = 1:N_low-1
        stride_low_group(k)= abs(low_group(k) - low_group(k+1))/(low_group_raw_num(k+1)-low_group_raw_num(k));
    end
else
    stride_low_group = 0;
end

var_stride = var(stride_high_group) + var(stride_low_group);
%% 计算平均步幅
if flag_high_group > 0 
    step_num_high = high_group_raw_num(N_high) - high_group_raw_num(1);
    average_stride1 = 50*abs(high_group(1)-high_group(N_high))/step_num_high;
else
    average_stride1 = 0;
end

if flag_low_group > 0 
    step_num_low = low_group_raw_num(N_low) - low_group_raw_num(1);
    average_stride2 = 50*abs(low_group(1)-low_group(N_low))/step_num_low;
else
    average_stride2 = 0;
end

if flag_high_group+flag_low_group == 0  
    disp("检测到原地踏步！");
    flag = 0;
    average_stride = 0;
elseif flag_high_group+flag_low_group == -2
    error("未检测到步数!");
elseif average_stride1*average_stride2 ~= 0 
    average_stride = 0.5*(average_stride1 + average_stride2);
    flag = flag_low_group;
    if flag_low_group == 1
        disp("检测到相对左光纤向上移动！");
    else
        disp("检测到相对左光纤向下移动！");
    end
else
    average_stride =average_stride1 + average_stride2;
    flag = flag_low_group;
    if flag_low_group == 1
        disp("检测到相对左光纤向上移动！");
    else
        disp("检测到相对左光纤向下移动！");
    end
end   

end
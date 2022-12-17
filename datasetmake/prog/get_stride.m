function [flag,average_stride,var_stride] = get_stride(vec)
%stride_ana 步幅分析:获得行走状态+平均每步的距离（单位cm）
%low group 左光纤  high_group 右光纤
%flag = -1:未检测到步数  0:原地踏步  1：相对左光纤向上  2：相对左光纤向下
%输入vec为peak_pos

%% 参数、存储结构的初始化
flag_low_group = -1;
flag_high_group = -1;
MAX_DELTA = 0;
MID=200;                  %200;      %197.5
N = length(vec);

low_group = [];
low_group_raw_NUM = [];             %存储原序号
high_group = [];
high_group_raw_NUM = [];
%% 分组
for i = 1:N
    if vec(i)> MID
        high_group = [high_group vec(i)];
        high_group_raw_NUM = [high_group_raw_NUM i];
    else
        low_group = [low_group vec(i)];
        low_group_raw_NUM = [low_group_raw_NUM i];
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
% 判断2组各自走势
if(N_high > 1)
    flag_high_group = compare1(high_group(1),high_group(N_high),MAX_DELTA);
    pointer = N_high;
    exit = 0;
    while(pointer >= 2 && exit == 0)
        flag_check = compare2(high_group(pointer-1),high_group(pointer));
        if flag_check == 0 || flag_check == flag_high_group
            exit =1;
        else
            pointer = pointer-1;
        end
    end
    N_high_last = pointer;
end

if(N_low > 1)
    flag_low_group = compare1(low_group(1),low_group(N_low),MAX_DELTA);
    pointer = N_low;
    exit = 0;
    while(pointer >= 2 && exit == 0)
        flag_check = compare2(low_group(pointer-1),low_group(pointer));
        if flag_check == 0 || flag_check == flag_low_group
            exit =1;
        else
            pointer = pointer-1;
        end
    end
    N_low_last = pointer;
end

% 分组计算POS差分值
if N_high > 1
    for k = 1:N_high-1
        stride_high_group(k)= 50*abs(high_group(k) - high_group(k+1))/(high_group_raw_NUM(k+1)-high_group_raw_NUM(k));
    end
else
    stride_high_group = 0;
    flag_high_group = -1;
end
if N_low > 1
    for k = 1:N_low-1
        stride_low_group(k)= 50*abs(low_group(k) - low_group(k+1))/(low_group_raw_NUM(k+1)-low_group_raw_NUM(k));
    end
else
    stride_low_group = 0;
    flag_low_group = -1;
end

var_stride = var(stride_high_group) + var(stride_low_group);    % 由于“采样抖动”的存在，该特征参数不一定有效
% 计算平均步幅
if flag_high_group > 0
    step_num_high = high_group_raw_NUM(N_high_last) - high_group_raw_NUM(1);
    average_stride_high = 50*abs(high_group(1)-high_group(N_high_last))/step_num_high;
else
    average_stride_high = 0;
end

if flag_low_group > 0
    step_num_low = low_group_raw_NUM(N_low_last) - low_group_raw_NUM(1);
    average_stride_low = 50*abs(low_group(1)-low_group(N_low_last))/step_num_low;
else
    average_stride_low = 0;
end

% 状态显示
if flag_high_group == 0 && flag_low_group == 0
    disp("检测到原地踏步！");
    flag = 0;
    average_stride = 0;
elseif flag_high_group+flag_low_group == -2                     %（-1）+（-1）
    error("未检测到步数!");
elseif average_stride_high*average_stride_low ~= 0                     % flag_low > 0 & flag_high > 0
    if average_stride_high/average_stride_low > 1.25 || average_stride_high/average_stride_low < 0.8   %考虑少数的组可能受到抖动影响大，二者不可差太远！
        if N_high >= N_low
            average_stride = average_stride_high;
        else
            average_stride = average_stride_low;
        end
    else
        average_stride = 0.5*(average_stride_high + average_stride_low);
    end
    flag = flag_low_group;
    if flag_low_group == 1
        disp("检测到相对左光纤向上移动！");
    else
        disp("检测到相对左光纤向下移动！");
    end
elseif flag_low_group ~= -1
    average_stride =average_stride_high + average_stride_low;
    flag = flag_low_group;
    if flag_low_group == 1
        disp("检测到相对左光纤向上移动！");
    else
        disp("检测到相对左光纤向下移动！");
    end
else
    average_stride =average_stride_high + average_stride_low;
    flag = flag_high_group;
    if flag == 1
        disp("检测到相对左光纤向下移动！");
    else
        disp("检测到相对左光纤向上移动！");
    end
end
end
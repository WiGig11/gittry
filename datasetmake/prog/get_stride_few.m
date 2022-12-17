function [flag,average_stride,var_stride] = get_stride_few(vec)
%stride_ana ��������:�������״̬+ƽ��ÿ���ľ��루��λcm��
%low group �����  high_group �ҹ���
%flag = -1:δ��⵽����  0:ԭ��̤��  1��������������  2��������������
%����vecΪpeak_pos

%% �������洢�ṹ�ĳ�ʼ��
flag_low_group = -1;
flag_high_group = -1;
MAX_DELTA = 2;
MID=200;                  %200;      %197.5
N = length(vec);

low_group = [];
low_group_raw_NUM = [];             %�洢ԭ���
high_group = [];
high_group_raw_NUM = [];
%% ����
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

%% �ж�2��������� 
if(N_high > 1)
    flag_high_group = compare1(high_group(1),high_group(N_high),MAX_DELTA);
end

if(N_low > 1)
    flag_low_group = compare1(low_group(1),low_group(N_low),MAX_DELTA);
end

%% �������POS���ֵ
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

var_stride = var(stride_high_group) + var(stride_low_group);    % ���ڡ������������Ĵ��ڣ�������������һ����Ч
%% ����ƽ������
if flag_high_group > 0 
    step_num_high = high_group_raw_NUM(N_high) - high_group_raw_NUM(1);
    average_stride_high = 50*abs(high_group(1)-high_group(N_high))/step_num_high;
else
    average_stride_high = 0;
end

if flag_low_group > 0 
    step_num_low = low_group_raw_NUM(N_low) - low_group_raw_NUM(1);
    average_stride_low = 50*abs(low_group(1)-low_group(N_low))/step_num_low;
else
    average_stride_low = 0;
end

% ״̬��ʾ
if flag_high_group == 0 && flag_low_group == 0                         
    disp("��⵽ԭ��̤����");
    flag = 0;
    average_stride = 0;
elseif flag_high_group+flag_low_group == -2                     %��-1��+��-1��
    error("δ��⵽����!");
elseif average_stride_high*average_stride_low ~= 0                     % flag_low > 0 & flag_high > 0   
    if average_stride_high/average_stride_low > 1.25 || average_stride_high/average_stride_low < 0.8   %����������������ܵ�����Ӱ��󣬶��߲��ɲ�̫Զ��
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
        disp("��⵽�������������ƶ���");
    else
        disp("��⵽�������������ƶ���");
    end
elseif flag_low_group ~= -1
    average_stride =average_stride_high + average_stride_low;
    flag = flag_low_group;
    if flag_low_group == 1
        disp("��⵽�������������ƶ���");
    else
        disp("��⵽�������������ƶ���");
    end
else
    average_stride =average_stride_high + average_stride_low;
    flag = flag_high_group;
    if flag == 1
        disp("��⵽�������������ƶ���");
    else
        disp("��⵽�������������ƶ���");
    end
end   

end

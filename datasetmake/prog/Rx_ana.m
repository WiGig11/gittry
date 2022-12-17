function [step_freq_minute,num_peak,main_peak,second_peak,delta_t] = Rx_ana(Vec,GAP)
%   输入Rx行向量
%   取中main_max 取滑动时间窗口LEN = 80 挪动值INT = 15 窗口均值是极大值 
%   落步间隔GAP >= 410    在允许观测范围内（取前6/7步）计算步频
%   走路/踏步 GAP = 410;          % 跑步GAP = 310
    PEAK_num = 6;
    %PEAK_num = 7;
    
%VERSION 2022-11-08 需要保证输入xcorr的VEC“停留”时间不太长，防止错峰对应，形成伪峰 
%Solution：
%输入xcorr前检测（具体？），剪裁“停留时间长度”并记录，将剪裁后的VEC_CUT输入xcorr，计算步频时加入剪裁掉的空档期。
%检验：停走停 走停停走
%正常情况下，从左开始到主峰，各个峰值应该逐级增加，因为有新的振动峰对应上而加入sum。

%实验者若长时间逗留某处，不迈步，会出现错峰对应，原x-1峰对应x峰，导致sum出现小变化  

    Rx = xcorr(Vec);
    N = length(Rx);
    Roll_INT = 15;          %   滑动位数  可调
    Roll_Window_LEN = 80;   %   滑动窗口长度  可调
    
    [main_peak,main_peak_index] = max(Rx);
    last_peak = main_peak;
    last_peak_index = main_peak_index;
    second_peak = 0;
    peak_index = [];
    index1_left = [];
    index2_right = [];
    num_peak = 1;
    rolling_time = floor(((N/2)-Roll_Window_LEN)/Roll_INT);
    flag =zeros(1,rolling_time);       % 1:up -1:down      
    
    %滑动窗口升降趋势
    for i = 1:1:rolling_time
        if(mean(Rx(main_peak_index+(i-1)*Roll_INT:main_peak_index+(i-1)*Roll_INT +Roll_Window_LEN))>=mean(Rx(main_peak_index+i*Roll_INT:main_peak_index+i*Roll_INT +Roll_Window_LEN)))
            flag(i) = -1;
        else
            flag(i) = 1;
        end
    end
    
    %滑动窗口峰值坐标获取 & 步频计算
    index = 1;
    peak_index = [peak_index,last_peak_index];
    
    while(index < rolling_time-6 )
        tick = 0;
        if(flag(index)+flag(index+1)+flag(index+2)==3)
            k = 1;
            while(flag(index+2+k) == 1)
                k= k+1;
            end
%             if(flag(index+2+k)+flag(index+3+k)+flag(index+4+k)==-3)
            if(flag(index+2+k)+flag(index+3+k)==-2)

                tick = 1;
                want1 = index+k-1;
                want2 = index+k;  %滑动次数
                index1_left = [index1_left main_peak_index + want1 * Roll_INT];
                index2_right = [index2_right main_peak_index + want2 * Roll_INT + Roll_Window_LEN];
                %当前峰值获取
                [temp_peak,temp] = max(Rx(main_peak_index + want1 * Roll_INT:main_peak_index + want2 * Roll_INT + Roll_Window_LEN));
                if ((temp + main_peak_index + want1 * Roll_INT - 1 )- last_peak_index > GAP)
                    last_peak_index = temp + main_peak_index + want1 * Roll_INT - 1;
                    last_peak = temp_peak;
                    num_peak = num_peak + 1;
                    if(num_peak == 2)
                        second_peak = last_peak;
                    end
                    peak_index = [peak_index last_peak_index];
                end 
            end
        end        
        if(tick == 0)
            index = index + 1;
        else 
            index = index + k + 4;
        end     
    end
    %计算每分钟步数，左脚->右脚为1步
    if( num_peak < PEAK_num)
        step_freq_minute = 0;
    else
        delta_minute = (peak_index(PEAK_num)- peak_index(1))/(866*60);
        step_freq_minute = (PEAK_num-1)/delta_minute;
    end
    N_delta_t = length(peak_index)-1;
    delta_t = zeros(1,N_delta_t);
    for k = 1:N_delta_t
        delta_t(k)=peak_index(k+1)-peak_index(k);
    end     
end
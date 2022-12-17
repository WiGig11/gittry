function [step_freq_minute,num_peak,main_peak,second_peak,delta_t] = Rx_ana(Vec,GAP)
%   ����Rx������
%   ȡ��main_max ȡ����ʱ�䴰��LEN = 80 Ų��ֵINT = 15 ���ھ�ֵ�Ǽ���ֵ 
%   �䲽���GAP >= 410    ������۲ⷶΧ�ڣ�ȡǰ6/7�������㲽Ƶ
%   ��·/̤�� GAP = 410;          % �ܲ�GAP = 310
    PEAK_num = 6;
    %PEAK_num = 7;
    
%VERSION 2022-11-08 ��Ҫ��֤����xcorr��VEC��ͣ����ʱ�䲻̫������ֹ����Ӧ���γ�α�� 
%Solution��
%����xcorrǰ��⣨���壿�������á�ͣ��ʱ�䳤�ȡ�����¼�������ú��VEC_CUT����xcorr�����㲽Ƶʱ������õ��Ŀյ��ڡ�
%���飺ͣ��ͣ ��ͣͣ��
%��������£�����ʼ�����壬������ֵӦ�������ӣ���Ϊ���µ��񶯷��Ӧ�϶�����sum��

%ʵ��������ʱ�䶺��ĳ����������������ִ���Ӧ��ԭx-1���Ӧx�壬����sum����С�仯  

    Rx = xcorr(Vec);
    N = length(Rx);
    Roll_INT = 15;          %   ����λ��  �ɵ�
    Roll_Window_LEN = 80;   %   �������ڳ���  �ɵ�
    
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
    
    %����������������
    for i = 1:1:rolling_time
        if(mean(Rx(main_peak_index+(i-1)*Roll_INT:main_peak_index+(i-1)*Roll_INT +Roll_Window_LEN))>=mean(Rx(main_peak_index+i*Roll_INT:main_peak_index+i*Roll_INT +Roll_Window_LEN)))
            flag(i) = -1;
        else
            flag(i) = 1;
        end
    end
    
    %�������ڷ�ֵ�����ȡ & ��Ƶ����
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
                want2 = index+k;  %��������
                index1_left = [index1_left main_peak_index + want1 * Roll_INT];
                index2_right = [index2_right main_peak_index + want2 * Roll_INT + Roll_Window_LEN];
                %��ǰ��ֵ��ȡ
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
    %����ÿ���Ӳ��������->�ҽ�Ϊ1��
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
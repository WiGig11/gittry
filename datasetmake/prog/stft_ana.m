function single_step_para_list = stft_ana(stft_matrix,sig_vec)
%STFT_ANA ��STFT^2��ͼ����ȡ�����źŵ���Чʱ�� & ��Ҫ�ɷ�������������Ƶ�� & ��Ч���� & ����Ƶ�����ҵ�������
%����866x256����
MAX_FREQ = 100;
TIME_EDGE = 60;
N = length(sig_vec);
E = sum(sig_vec.^2);

%get max_t
max_t = 0;
[row,column] = size(stft_matrix);
temp = 0;
for i = 1:row
    for j = 1:column
        if stft_matrix(i,j) >= temp
            temp = stft_matrix(i,j);
            max_t = j;
        end
    end
end
%get max_t����

%����t0
temp = 0;
for i = 1:N
    temp = temp + i*sig_vec(i)^2;
end
t0 = temp/E;
%����t0����

%����ʱ��
temp = 0;
for i = 1:N
    temp = temp + ((i-t0)^2)*sig_vec(i)^2;
end
time_width = sqrt(temp/E);
%time_width = time_width/866;                %����Ϊʱ��
%����ʱ�����

%��������Ƶ��
temp = 0;
energy = 0;
for t = max_t-TIME_EDGE:1:max_t+TIME_EDGE
    %����ʱ����
    if max_t-TIME_EDGE <=0
        index_t = max_t+TIME_EDGE;
    else
        index_t = max_t-TIME_EDGE;
    end
    if max_t + TIME_EDGE > column
        index_t = max_t-TIME_EDGE;
    else
        index_t = max_t+TIME_EDGE;
    end
    %����ʱ�������
    for f = 1:1:MAX_FREQ
        temp = temp + f*(stft_matrix(f,index_t)^2);
        energy = energy + stft_matrix(f,index_t)^2;
    end
end
center_freq = temp/energy;
%��������Ƶ�ʽ���

%������Ч����
temp = 0;
for t = max_t-TIME_EDGE:1:max_t+TIME_EDGE
        %����ʱ����
    if max_t-TIME_EDGE <=0
        index_t = max_t+TIME_EDGE;
    else
        index_t = max_t-TIME_EDGE;
    end
    if max_t + TIME_EDGE > column
        index_t = max_t-TIME_EDGE;
    else
        index_t = max_t+TIME_EDGE;
    end
    %����ʱ�������
    for f = 1:1:MAX_FREQ
        temp = temp + ((f-center_freq)^2)*(stft_matrix(f,index_t)^2);
    end
end
bandwidth = sqrt(temp/energy);
%������Ч�������

%�������ұ�
temp = 0;
energy_L = 0;
energy_R = 0;
for t = max_t-TIME_EDGE:1:max_t+TIME_EDGE
    %����ʱ����
    if max_t-TIME_EDGE <=0
        index_t = max_t+TIME_EDGE;
    else
        index_t = max_t-TIME_EDGE;
    end
    if max_t + TIME_EDGE > column
        index_t = max_t-TIME_EDGE;
    else
        index_t = max_t+TIME_EDGE;
    end
    %����ʱ�������
    for f = 1:1:round(center_freq)
        energy_L = energy_L + stft_matrix(f,index_t)^2;
    end
    for f = round(center_freq):1:MAX_FREQ
        energy_R = energy_R + stft_matrix(f,index_t)^2;
    end
end
LR_ratio = energy_L/energy_R;

%�������ұȽ���
single_step_para_list = [time_width center_freq bandwidth LR_ratio];
end


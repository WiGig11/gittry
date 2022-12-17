function [stft_feature_matrix,average_T_width,average_center_Freq,average_BW,average_LR_ratio] = get_stft_feature(num_step,step_sig_group)
%GET_STFT_FEATURE 获取N步信号的时频分析特征矩阵
%返回矩阵N行4列：
%每行parameter:有效时宽点数 & 主要成分瑞利波的中心频率 & 有效带宽

N_step = num_step;
stft_feature_matrix = zeros(N_step,4);
[N,~] = size(step_sig_group);
Spec = cell(1,N);

if N ~= N_step
    error("峰值检测或步数检测错误");
end

for i = 1:N
    [Spec{i},~] = DSTFT(step_sig_group(i,:),866*2,45,866); 
    stft_feature_matrix(i,:) = stft_ana(Spec{i},step_sig_group(i,:)); 
end

average_T_width = mean(stft_feature_matrix(:,1));
average_center_Freq = mean(stft_feature_matrix(:,2));
average_BW = mean(stft_feature_matrix(:,3));
average_LR_ratio = mean(stft_feature_matrix(:,4));
end


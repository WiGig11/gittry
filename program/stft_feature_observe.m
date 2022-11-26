function stft_feature_observe(para_matrix,used_fig,raw_sig,filtered_sig)
%single_step_stft_observe 画图观察单步信号与对应STFT提取的特征
N = length(para_matrix);
for j = 1:N
    str = num2str(para_matrix(j,:));
    figure(used_fig + j)
    subplot(211)
    plot(raw_sig(j,:));
    subplot(212)
    plot(filtered_sig(j,:));
    suptitle(str);
end
end


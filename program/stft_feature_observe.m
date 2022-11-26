function stft_feature_observe(para_matrix,used_fig,raw_sig,filtered_sig)
%single_step_stft_observe ��ͼ�۲쵥���ź����ӦSTFT��ȡ������
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


function [restructed_sig]=step_group_observe(raw_step_group,used_fig_num,after_hampel_step_group)
%STEP_GROUO_OBSEVER 把各步一维信号时域波形画在一张图上:raw+filtered+PCA
%输入raw_step_group为N*256矩阵
%PCA 输入数据为n行p列的多变量数据，n为观测次数，p为变量维度

[N,~] = size(raw_step_group);
% after_LPF = zeros(N,Sig_LEN);

% figure(used_fig_num+1)
% subplot(311)
% for i = 1:N
%     plot(raw_step_group(i,:));
%     hold on
% end
% title("原信号")

% subplot(312)
% for j = 1:N
%     plot(after_hampel_step_group(j,:));
%     hold on
% end
% title("after Hampel ")

%PCA
NumComponents = 1;
[coeff,score,~,~,explained,mu]= pca(after_hampel_step_group,'NumComponents',NumComponents);
S_centered = score * coeff';
L = length(S_centered);
restructed_sig = zeros(1,L); 
for j = 1:L
    restructed_sig = max(S_centered);
end
% subplot(313)
% plot(restructed_sig);
% title("after PCA")

% subplot(224)
% plot(Butterworth_LPF_45_50_1dB_50dB(restructed_sig));
% title("after Butterworth LPF 50Hz")

end


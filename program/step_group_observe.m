function [restructed_sig]=step_group_observe(raw_step_group,used_fig_num,after_hampel_step_group)
%STEP_GROUO_OBSEVER �Ѹ���һά�ź�ʱ���λ���һ��ͼ��:raw+filtered+PCA
%����raw_step_groupΪN*256����
%PCA ��������Ϊn��p�еĶ�������ݣ�nΪ�۲������pΪ����ά��

[N,~] = size(raw_step_group);
% after_LPF = zeros(N,Sig_LEN);

% figure(used_fig_num+1)
% subplot(311)
% for i = 1:N
%     plot(raw_step_group(i,:));
%     hold on
% end
% title("ԭ�ź�")

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


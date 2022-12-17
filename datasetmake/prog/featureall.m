function features =  featureall(intensity,startpos,maxsig,pre_processed_Sig,GAP)
features = [];
%% 宏观特征
%%%%%%%%%%%%%%%%%%%
%% 时间-最大强度直方图 参数  方差均值比、峰值系数   
mydata1 = yuanbaoshuzu(maxsig,length(maxsig));
feature1 = extractf(mydata1,maxsig,length(maxsig));
features = [features feature1];
%% 步频
[~,num_peak,~,~,delta_peak_time] =  Rx_ana(maxsig,GAP);
[f,peak_pos,~,peak_index,delta_time_var] = get_peak_pos(maxsig,pre_processed_Sig,num_peak,delta_peak_time,startpos,500);  %f是再结合时间-最大强度图得到的步频，更精准
ave_time_width = get_time_width(maxsig,num_peak,peak_index);
features = [features,f,delta_time_var,ave_time_width];
disp(f)
%% 步幅
step_pos_vec = round(step_pos_ana(pre_processed_Sig,peak_index)+startpos);
average_stride = get_stride2(step_pos_vec,peak_pos);
features = [features,average_stride];
disp(average_stride)
%% 能量
[step_energy_array,~,~] = get_step_energy(pre_processed_Sig,startpos,peak_pos,peak_index);
features = [features,mean(step_energy_array)];
%% 振动跨度
ave_pos_width = get_pos_width(pre_processed_Sig,500);
features = [features ave_pos_width];

%% 单步信号
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[raw_sig_group,~,after_hampel] = get_each_step_sig(peak_pos,peak_index,intensity);
%% PCA based
%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%
used_fig_num = 0;
after_pca = step_group_observe(raw_sig_group,used_fig_num,after_hampel); 
%% 时域特征
feature_single_step_time_domain = extract_f_of_single_step(after_pca);
features = [features feature_single_step_time_domain];
%% STFT
[Spec,~] = DSTFT(after_pca,866*2,45,866);
stft_feature_pca = stft_ana(Spec,after_pca);
features = [features stft_feature_pca];
%% HHT
[~,hhtfeature] = hhtfretrans(hht(after_pca),0);
features = [features hhtfeature];
%% 二维获取
step_sig_group2 = get_each_step_sig2(peak_pos,peak_index,intensity);
%% 时域特征分解
[pattern2,~] = eigendivide(step_sig_group2);
timef = gatpatternf(pattern2);
features = [features timef];
%% 小波变换
[cA,~] = dwt_3_wave(step_sig_group2,'db4');
wtf = get_feature(cA);
features = [features wtf];

%% 联合统计 based
%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%
% [~,connected_Sig2] = step_sig_connect(raw_sig_group,1);
%% 时域特征
% feature_time_domain = extract_f_of_single_step(connected_Sig2);
% features = [features feature_time_domain];
%% STFT
% [Spec_1,~] = DSTFT(resampled_Sig,433*2,45,433);
% stft_feature = stft_ana(Spec_1,resampled_Sig);

function features =  featureall(intensity,startpos,endpos,starttime,endtime,GAP)
features = [];%特征值数组
%% 数据预处理
noise_reducted = datapre(intensity,startpos,endpos,starttime,endtime);
% max1=max(noise_reducted);
% maxsig =max_pre(max(noise_reducted));
maxsig =max(noise_reducted);
%% 步频
[freq,num_peak,~,~,delta_peak_time] =  Rx_ana(maxsig,GAP); 
features = [features,freq];
%% 步幅
% delta_time_para1 = get_delta_time_para(delta_peak_time);
[~,peak_pos,~,peak_index] = get_peak_pos_2(maxsig,noise_reducted,num_peak,delta_peak_time,startpos,GAP);  %f是再结合时间-最大强度图得到的步频，更精准
[~,average_stride,var_stride] = get_stride(peak_pos);
features = [features,average_stride,var_stride];
%% 能量
[step_energy_array,~,~] = get_step_energy(noise_reducted,startpos,peak_pos,peak_index);
features = [features,mean(step_energy_array)];
%% 单步特征
[raw_sig_group,~,after_hampel] = get_each_step_sig(peak_pos,peak_index,intensity);
used_fig_num = 0;
after_pca = step_group_observe(raw_sig_group,used_fig_num,after_hampel); 
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
[cA,~] = dwt_3_wave(step_sig_group2,'db4',used_fig_num); %一次调用 出三张图
wtf = get_feature(cA);
features = [features wtf];



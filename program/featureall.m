function features =  featureall(intensity,startpos,endpos,starttime,endtime,GAP)
features = [];%����ֵ����
%% ����Ԥ����
noise_reducted = datapre(intensity,startpos,endpos,starttime,endtime);
% max1=max(noise_reducted);
% maxsig =max_pre(max(noise_reducted));
maxsig =max(noise_reducted);
%% ��Ƶ
[freq,num_peak,~,~,delta_peak_time] =  Rx_ana(maxsig,GAP); 
features = [features,freq];
%% ����
% delta_time_para1 = get_delta_time_para(delta_peak_time);
[~,peak_pos,~,peak_index] = get_peak_pos_2(maxsig,noise_reducted,num_peak,delta_peak_time,startpos,GAP);  %f���ٽ��ʱ��-���ǿ��ͼ�õ��Ĳ�Ƶ������׼
[~,average_stride,var_stride] = get_stride(peak_pos);
features = [features,average_stride,var_stride];
%% ����
[step_energy_array,~,~] = get_step_energy(noise_reducted,startpos,peak_pos,peak_index);
features = [features,mean(step_energy_array)];
%% ��������
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
%% ��ά��ȡ
step_sig_group2 = get_each_step_sig2(peak_pos,peak_index,intensity);
%% ʱ�������ֽ�
[pattern2,~] = eigendivide(step_sig_group2);
timef = gatpatternf(pattern2);
features = [features timef];
%% С���任
[cA,~] = dwt_3_wave(step_sig_group2,'db4',used_fig_num); %һ�ε��� ������ͼ
wtf = get_feature(cA);
features = [features wtf];



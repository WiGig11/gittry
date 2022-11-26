function para_list = extract_f_of_single_step(vec)
%EXTRACT_F_OF_POSA 计算单步信号时域统计特征:方均比、峰值系数、自相关系数均值
    mean_vec = mean(vec);
    var_vec = var(vec);
    peak_vec = max(vec);
    y = autocorr(vec);
    N_y = length(y);
    %方差均值比
    var_mean_ratio = mean_vec/var_vec;
    %峰值系数
    peak_para = peak_vec/mean_vec;
    %自相关系数均值
    temp = 0;
    sum = 0;
    for j = 1:N_y
        temp = j*y(j);
        sum = sum+j;
    end
    mean_autocorr = temp/sum;
    %结束
    para_list = [var_mean_ratio peak_para mean_autocorr];
end



   
   
    
%     N2 = length(vec2);
%     rms2 = sqrt(sum(vec2)^2/N2);
%     sqrt_v2 = zeros(1,N2);
%     s_v2 = zeros(1,N2);
%     M2 = mean(vec2);
%     for i = 1:N2
%         sqrt_v2(i) = sqrt(vec2(i));
%         s_v2(i) = (vec(i)-M2);
%     end
%    
%     wave_para2 = rms2/M2;
%     peak_para2 = max(vec2)/M2;
%     yudu_para2 = (sum(sqrt_v2)/N2)^2;
%     xie_para2 = sum(s_v2^3)/((N2-1)*sqrt(var(vec2))^3);
%     qiaodu_para2 = sum(s_v2^4)/((N2-1)*sqrt(var(vec2))^4);
%     
%     para2_list = [wave_para2 peak_para2 yudu_para2 xie_para2 qiaodu_para2 ];


function [raw_sig_group,step_sig_group,after_hampel_sig] = get_each_step_sig(peak_pos,peak_index,raw)
%返回值为矩阵 行数=N 列数= 256
N = length(peak_pos);
TIME_RANGE_H = 128;   %256 点
Sig_LEN = length(raw);
step_sig_group = zeros(N,2*TIME_RANGE_H);
raw_sig_group = zeros(N,2*TIME_RANGE_H);
after_hampel_sig = zeros(N,2*TIME_RANGE_H);

for i =1:N
    y = zeros(1,2*TIME_RANGE_H);
    if peak_index(i)+TIME_RANGE_H-1 > Sig_LEN
       %向后补零
       y(1:Sig_LEN-(peak_index(i)-TIME_RANGE_H)+1) = raw(peak_pos(i),peak_index(i)-TIME_RANGE_H:Sig_LEN);
       y(Sig_LEN-(peak_index(i)-TIME_RANGE_H)+2:2*TIME_RANGE_H) = zeros(1,2*TIME_RANGE_H-(Sig_LEN-(peak_index(i)-TIME_RANGE_H)+2)+1);
    elseif peak_index(i)-TIME_RANGE_H <= 0
        %向前补零
        y(1:TIME_RANGE_H - peak_index(i)+1) = zeros(1,TIME_RANGE_H - peak_index(i)+1);
        y(TIME_RANGE_H - peak_index(i)+2:2*TIME_RANGE_H) = raw(1:peak_index(i)+TIME_RANGE_H-1);    
    else
        y = raw(peak_pos(i),peak_index(i)-TIME_RANGE_H:peak_index(i)+TIME_RANGE_H-1);
    end
    
       step_sig_group(i,:) = Butterworth_LPF50_60(hampel(y',3));
       after_hampel_sig(i,:) = hampel(y',7)';
       raw_sig_group(i,:) = y;
end
end


function step_sig_group = get_each_step_sig2(peak_pos,peak_index,raw)
%返回值为矩阵 行数=N 列数= 256
N = length(peak_pos);
TIME_RANGE_H = 128;   %256 点
Sig_LEN = length(raw);
SENSOR_LENGTH =  9;
step_sig_group = cell(N,1);
for k  = 1:N
    step_sig_group{k,1} = zeros(SENSOR_LENGTH,2*TIME_RANGE_H);
end

y = zeros(SENSOR_LENGTH,2*TIME_RANGE_H);
for i =1:N
    for j = 1:SENSOR_LENGTH
        if peak_index(i)+TIME_RANGE_H-1 > Sig_LEN
            %向后补零
            y(j,1:Sig_LEN-(peak_index(i)-TIME_RANGE_H)+1) = raw(peak_pos(i)+j-round(SENSOR_LENGTH/2)-1,peak_index(i)-TIME_RANGE_H:Sig_LEN);
            y(j,Sig_LEN-(peak_index(i)-TIME_RANGE_H)+2:2*TIME_RANGE_H) = zeros(1,2*TIME_RANGE_H-(Sig_LEN-(peak_index(i)-TIME_RANGE_H)+2)+1);
        elseif peak_index(i)-TIME_RANGE_H <= 0
            %向前补零
            y(j,1:TIME_RANGE_H - peak_index(i)+1) = zeros(1,TIME_RANGE_H - peak_index(i)+1);
            y(j,TIME_RANGE_H - peak_index(i)+2:2*TIME_RANGE_H) = raw(peak_pos(i)+j-round(SENSOR_LENGTH/2)-1,1:peak_index(i)+TIME_RANGE_H-1);
        else
            y(j,:) = raw(peak_pos(i)+j-round(SENSOR_LENGTH/2)-1,peak_index(i)-TIME_RANGE_H:peak_index(i)+TIME_RANGE_H-1);
        end
         y (j,:)= Butterworth_LPF50_60(hampel(y(j,:)',3)); %%！滤波了
    end
    step_sig_group{i,1} = y;
end


end


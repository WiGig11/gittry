function step_pos_vec = step_pos_ana(matrix,peak_time_index)
%STEP_POS_ANA 分析各步的POS
N_step = length(peak_time_index);
[~,N] = size(matrix);
Observe_Range_H = 200;
step_pos_vec = zeros(1,N_step);

for i = 1:N_step
    if peak_time_index(i)-Observe_Range_H >0
        index_L = peak_time_index(i)-Observe_Range_H;
    else
        index_L = 1;
    end
    if peak_time_index(i)+Observe_Range_H >N
        index_R = N;
    else
        index_R = peak_time_index(i)+Observe_Range_H;
    end
    temp_max = max(matrix(:,index_L:index_R),[],2);
    
    %分析该POS-max_intensity向量
    index = pcount3(temp_max);
    sum = 0;
    sum2 = 0;   
    for j = index(1):index(2)
        sum = temp_max(j)^2+sum;
        sum2 = sum2 + temp_max(j)^2*j;
    end
    step_pos_vec(i) = sum2/sum;  
end


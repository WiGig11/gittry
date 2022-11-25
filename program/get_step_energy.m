function [step_energy_array,left_step_energy_array,right_step_energy_array] = get_step_energy2(noise_reducted,startpos,peak_pos,peak_index)
%GET_STEP_ENERGY ����ͳ�Ʒ�Χ�ڵ�ÿ����������ܺ͵�����   VERSION2:ADD�����������
%�ٷ���ÿ�������ҹ�����������
LEFT_RIGHT_SUM = 400;   
POS_RANGE_H = 4;
TIME_RANGE_H = 120;    

N = length(peak_pos);
step_energy_array = zeros(1,N);
left_step_energy_array = zeros(1,N);
right_step_energy_array = zeros(1,N);

[row,column] = size(noise_reducted);
mirror_peak_pos = LEFT_RIGHT_SUM - peak_pos;

time_index = zeros(N,2*TIME_RANGE_H +1);
pos_index = zeros(N,2*POS_RANGE_H +1);
pos_index_m = zeros(N,2*POS_RANGE_H +1);

for j = 1:N
    sum1 = 0;
    sum2 = 0;
    for x = -POS_RANGE_H:POS_RANGE_H
       %����pos���
        if peak_pos(j)-startpos+x <= 0
            pos_index(j,x+POS_RANGE_H+1) = 1;
        elseif peak_pos(j)-startpos+x > row
            pos_index(j,x+POS_RANGE_H+1) = row;
        else
            pos_index(j,x+POS_RANGE_H+1) = peak_pos(j)-startpos+x;
        end
        %����pos������
        for y = -TIME_RANGE_H:TIME_RANGE_H      
            %����time���
            if peak_index(j)+y <= 0 || peak_index(j)+y > column
                time_index(j,y+TIME_RANGE_H+1) = peak_index(j)-y;
            else
                time_index(j,y+TIME_RANGE_H+1) = peak_index(j)+y;
            end
            %����time������
            sum1 = sum1 + noise_reducted(pos_index(j,x+POS_RANGE_H+1),time_index(j,y+TIME_RANGE_H+1))^2;   
        end
    end
    
    % Add ����������� below
    for x = -POS_RANGE_H:POS_RANGE_H
        %����pos���
        if mirror_peak_pos(j)-startpos+x <= 0
            pos_index_m(j,x+POS_RANGE_H+1) = 1;
        elseif mirror_peak_pos(j)-startpos+x > row
            pos_index_m(j,x+POS_RANGE_H+1) = row;
        else
            pos_index_m(j,x+POS_RANGE_H+1) = mirror_peak_pos(j)-startpos+x;
        end     
        %����pos������
        for y = -TIME_RANGE_H:TIME_RANGE_H
            sum2 = sum2 + noise_reducted(pos_index_m(j,x+POS_RANGE_H+1),time_index(j,y+TIME_RANGE_H+1))^2;
        end
    end
    step_energy_array(j) = sum1 + sum2;
    %�洢ÿ�������ҹ�������
    if peak_pos(j) < LEFT_RIGHT_SUM/2  %��    
       left_step_energy_array(j) = sum1;
       right_step_energy_array(j) = sum2;
    else
        right_step_energy_array(j) = sum1;
        left_step_energy_array(j) = sum2;
    end
end

end


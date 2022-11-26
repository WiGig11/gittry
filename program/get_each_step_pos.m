function pos = get_each_step_pos(left_side_E,right_side_E,peak_pos)
%GET_EACH_STEP_POS 比较左右光纤能量，确定位置
N = length(left_side_E);
LEFT_RIGHT_SUM = 400;%395
MID=197.5;
pos = zeros(1,N);

for j = 1:N
    if(left_side_E(j) > right_side_E(j))
        if(peak_pos(j) < MID)
            pos(j) = peak_pos(j);
        else
            pos(j) = LEFT_RIGHT_SUM - peak_pos(j);
        end
    else
        if(peak_pos(j) > MID)
            pos(j) = peak_pos(j);
        else
            pos(j) = LEFT_RIGHT_SUM - peak_pos(j);
        end
    end
end
end

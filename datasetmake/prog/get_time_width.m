function mean_time_width = get_time_width(vec,num_peak,peak_index)
%GET_POS_WIDTH 输入单人t-max_intensity向量vec，获取mean_time_width
N = length(vec);
MAX_GAP = 30;
time_width = zeros(1,num_peak);

for i=1:num_peak
    pointer = peak_index(i);
    %向左搜索edge_L
    while((i==1 && pointer>MAX_GAP) || (i>1 && pointer > peak_index(i-1)))
        if vec(pointer) > 0
            pointer = pointer-1;
        else
            counter = 1;
            while(vec(pointer-counter)==0 && counter < MAX_GAP)
                counter = counter+1;
            end
            if counter < MAX_GAP
                pointer = pointer -counter;
                if i == 1
                    edge_L = pointer;
                end
            else
                edge_L = pointer - MAX_GAP;
                break;                              %
            end
        end
    end
    %向右搜索edge_R
    while((i==num_peak && pointer<N) || (i<num_peak && pointer < peak_index(i+1)))
        if vec(pointer) > 0
            pointer = pointer+1;
        else
            counter = 1;
            while(vec(pointer+counter)==0 && counter < MAX_GAP && pointer+counter<N)
                counter = counter+1;
            end
            if counter < MAX_GAP
                pointer = pointer +counter;
            else
                edge_R = pointer + MAX_GAP;
                break;                              %
            end
        end
    end        
    time_width(i) = edge_R-edge_L;
end
mean_time_width = mean(time_width);
end
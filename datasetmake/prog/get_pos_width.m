function mean_pos_width = get_pos_width(matrix,Observe_Window_LEN)
%GET_POS_WIDTH 输入单人步行振动信号矩阵，获取POS_WIDTH
[~,TIME_LEN]=size(matrix);
N_window = floor(TIME_LEN/Observe_Window_LEN)-1;
pos_width = [];
mean_pos_width = 0;
for i = 1:N_window
    vec = max(matrix(:,1+(i-1)*Observe_Window_LEN:i*Observe_Window_LEN),[],2);
    edge_index = pcount1(vec);
    if length(edge_index) == 4
        temp_width = 0.5*(edge_index(2)-edge_index(1))+0.5*(edge_index(4)-edge_index(3));
        if temp_width < 15
            pos_width = [pos_width temp_width];
        end
    elseif length(edge_index) == 2
        temp_width = edge_index(2)-edge_index(1);
        if temp_width < 15
            pos_width = [pos_width temp_width];
        end
    end
end
if ~isempty(pos_width)
    mean_pos_width = mean(pos_width); 
end
end


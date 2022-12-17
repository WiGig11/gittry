function [num_person,edge_index_LS,edge_index_RS,count,min_edge_intvl] = pcount2(vec,attribute)
%P_COUNT 观察窗口内有效人数，判断行人是否相遇，并返回左右两边的峰脚点，对应关系未知
%输入vec:观察窗口内max_intensity_by_pos
%NEW VERSION:细化小峰、裂峰、噪峰处理；引入min_bound_gap辅助切割
N = length(vec);
MID = N/2;    
i = 1;                  %从低位向高位
peak_kind = [];         %1:完整+高峰 2：裂+高峰  3：完整+低峰  裂+低峰（舍）
edge_index_LS = [];
edge_index_RS = [];
count = 0;
%搜索与存储峰脚点
if attribute == 0
    while(i<N)
        if vec(i)>0
            flagA = 1;
            flag_fix = 0;
            j = i+1;
            while(j<=N-6 && flagA >0)
                if vec(j)>0
                    j = j+1;
                elseif vec(j+1)>0
                    if j-i+1 >= 5
                        flag_fix = 0;
                    else
                        flag_fix = 1;
                    end
                    j=j+2;
                elseif vec(j+1)==0 && vec(j+2)>0
                    if j-i+1 >= 5
                        flag_fix = 0;
                    else
                        flag_fix = 1;
                    end
                    j = j+3;
                elseif vec(j+1)+vec(j+2)==0 && vec(j+3)>0
                    if j-i+1 >= 5
                        flag_fix = 0;
                    else
                        flag_fix = 1;
                    end
                    j=j+4;
                elseif vec(j+1)+vec(j+2)+vec(j+3)==0 && vec(j+4)>0  %
                    if j-i+1 >= 5
                        flag_fix = 0;
                    else
                        flag_fix = 1;
                    end
                    j=j+5;
                elseif vec(j+1)+vec(j+2)+vec(j+3)+vec(j+4)==0 && vec(j+5)>0
                    if j-i+1 >= 5
                        flag_fix = 0;
                    else
                        flag_fix = 1;
                    end
                    j=j+6;
                else
                    flagA = 0;
                end
            end
            intvl_1 = j-(i-1);  % 0的pos：i-1、j
            temp_peak = max(vec(i:j-1));
            if intvl_1 >= 5
                %存储各峰性质
                if flag_fix ==0 && temp_peak >= 0.06
                    peak_kind = [peak_kind 1];
                    %存储峰脚点
                    if i-1 <= MID && i ~= 1
                        edge_index_LS = [edge_index_LS i-1];
                    elseif i == 1
                        edge_index_LS = [edge_index_LS 1];
                    else
                        edge_index_RS = [edge_index_RS i-1];
                    end
                    if j <= MID
                        edge_index_LS = [edge_index_LS j];
                    else
                        edge_index_RS = [edge_index_RS j];
                    end
                elseif flag_fix ==1 && temp_peak >= 0.06
                    peak_kind = [peak_kind 2];
                    %存储峰脚点
                    if i-1 <= MID && i ~= 1
                        edge_index_LS = [edge_index_LS i-1];
                    elseif i == 1
                        edge_index_LS = [edge_index_LS 1];
                    else
                        edge_index_RS = [edge_index_RS i-1];
                    end
                    if j <= MID
                        edge_index_LS = [edge_index_LS j];
                    else
                        edge_index_RS = [edge_index_RS j];
                    end
                elseif flag_fix ==0 && temp_peak < 0.06
                    peak_kind = [peak_kind 3];
                    %存储峰脚点
                    if i-1 <= MID && i ~= 1
                        edge_index_LS = [edge_index_LS i-1];
                    elseif i == 1
                        edge_index_LS = [edge_index_LS 1];
                    else
                        edge_index_RS = [edge_index_RS i-1];
                    end
                    if j <= MID
                        edge_index_LS = [edge_index_LS j];
                    else
                        edge_index_RS = [edge_index_RS j];
                    end
                end
            elseif intvl_1 == 4
                if flag_fix ==0 && temp_peak >= 0.04
                    peak_kind = [peak_kind 1];
                    %存储峰脚点
                    if i-1 <= MID && i ~= 1
                        edge_index_LS = [edge_index_LS i-1];
                    elseif i == 1
                        edge_index_LS = [edge_index_LS 1];
                    else
                        edge_index_RS = [edge_index_RS i-1];
                    end
                    if j <= MID
                        edge_index_LS = [edge_index_LS j];
                    else
                        edge_index_RS = [edge_index_RS j];
                    end
                end
            end
            i=j;
        else
            i = i+1;
        end
    end
else
    while(i<N)
    temp_l = 0;
    temp_r = 0;
    if vec(i)>0.045      % 阈值修改于11.23
        flag = 1;%某POS在观察窗口内有人出现 
        %向左边搜索峰脚点
        t = i-1;
        if t == 0
            temp_l = 1;
        end
        while(t >0 && flag == 1)
            if vec(t) == 0 
                flag = 0;
                temp_l = t;
            elseif vec(t) ~= 0 && t == 1
                flag = 0;
                temp_l = 1;
                t = t - 1;
            else
                t = t - 1;
            end
        end
        %向右边搜索峰脚点
        flag = 1;
        j = i+1;                     
        while(j<=N && flag == 1)
            if vec(j) == 0 
                flag = 0;
                temp_r = j;
             elseif vec(j) ~= 0 && j == N
                flag = 0;
                temp_r = N;
                j = j + 1;
            else
                j = j + 1;
            end
        end
        
        if temp_r ~= 0 && temp_l ~=0
            if temp_r - temp_l > 6           %防止记录伪峰
                count = count + 1;
                if temp_l >= MID    %Right Side
                    edge_index_RS = [edge_index_RS temp_l];
                else
                    edge_index_LS = [edge_index_LS temp_l];
                end
                if temp_r >= MID    %Right Side
                    edge_index_RS = [edge_index_RS temp_r];
                else
                    edge_index_LS = [edge_index_LS temp_r];
                end
            end
            i = j + 1;
        else
            break;
        end
    else
        i = i+1;
    end   
    end
end

%% 镜像换算
if attribute == 0
    count = length(peak_kind);
end
num_person = round(count/2);

%% min_edge_intvl 计算
N_LS = length(edge_index_LS);
N_RS = length(edge_index_RS);
if mod(N_LS,2)*mod(N_RS,2) == 0
    if N_LS/4 >=1
        N_differ_LS = (N_LS-2)/2;
        differ_LS = zeros(1,N_differ_LS);
        temp_pointer = 2;
        while(temp_pointer <= N_LS-2)
            differ_LS(temp_pointer/2) = edge_index_LS(temp_pointer+1)-edge_index_LS(temp_pointer);
            temp_pointer = temp_pointer+2;
        end
        min_LS = min(differ_LS);
    else
        min_LS = 0;
    end
    
    if N_RS/4 >=1
        N_differ_RS = (N_RS-2)/2;
        differ_RS = zeros(1,N_differ_RS);
        temp_pointer = 2;
        while(temp_pointer <= N_RS-2)
            differ_RS(temp_pointer/2) = edge_index_RS(temp_pointer+1)-edge_index_RS(temp_pointer);
            temp_pointer = temp_pointer+2;
        end
        min_RS = min(differ_RS);
    else
        min_RS = 0;
    end
    
    if min_LS*min_RS ~= 0
        min_edge_intvl = min(min_LS,min_RS);
    else
        min_edge_intvl = max(min_LS,min_RS);
    end
else
    edge_index = [edge_index_LS edge_index_RS];
    N_edge = length(edge_index);
    N_differ = (N_edge-2)/2;
        differ = zeros(1,N_differ);
        temp_pointer = 2;
        while(temp_pointer <= N_edge-2)
            differ(temp_pointer/2) = edge_index(temp_pointer+1)-edge_index(temp_pointer);
            temp_pointer = temp_pointer+2;
        end
        min_edge_intvl = min(differ);
end
end
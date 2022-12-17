function [cell_of_matrix_sig,cell_of_matrix_pos] = matrix_div_and_reconstr4(raw_matrix,num_person)
%MATRIX_DIV_AND_RECONSTR 切割POS×TIME矩阵到各人
%BACKGROUND 相交问题只存在于测试集，所以只需要一段信号（取相交前、后二者中时间间隔长的），而不需要拼接
%VERSION3:更新了pcount
%VERSION4:利用min_edge_intvl指示pcount效果，辅助分割
%首窗  找4*num_person个脚点  分组
%退避后的尾窗   发现走向+决定可定边界组是哪组+待定组用相应的元素替换首窗元素
%假设单组数据只有一种人数结构（不太适合流分析）
%每个元胞数组都是矩阵，列数为点数，行数为POS数(同noise_reducted)
%% 参数及存储结构设置
Observe_Win_LEN = 500;
[POS,n] = size(raw_matrix);
directions = zeros(1,num_person); %1:沿着左光纤向上:LS ascending  -1:沿着左光纤向下:LS descending
LS_B_index = zeros(1,num_person);
RS_B_index = zeros(1,num_person);
LS_R_index = zeros(1,num_person);
RS_R_index = zeros(1,num_person);
%% 切割
if num_person > 1                 %需要进行切割重构：测试集的复杂情况
    cross_flag = 0;             
    cross_time = 0;
    cell_of_matrix_sig = cell(1,num_person);
    cell_of_matrix_pos = cell(1,num_person);
    %% 搜索相交时间、再次分离时间    VERSION2：include case of No crossing √
    i = 1;
    while(i<=n && cross_flag == 0 )
        temp_num = pcount2(max(raw_matrix(:,i:i+Observe_Win_LEN-1),[],2),0);
        if temp_num ~= num_person
            temp_num = pcount2(max(raw_matrix(:,i+Observe_Win_LEN:i+2*Observe_Win_LEN-1),[],2),0);
            if temp_num ~= num_person
                temp_num = pcount2(max(raw_matrix(:,i+2*Observe_Win_LEN:i+3*Observe_Win_LEN-1),[],2),0);
                if temp_num ~= num_person
                cross_flag = 1;
                cross_time = i;
                end
            end
        end
        i = i+Observe_Win_LEN;
    end
    
    if cross_time ~= 0                      %有相交
        i = cross_time;
        disp(cross_time);
        while(i<=n-2*Observe_Win_LEN+1 && cross_flag == 1 )
            temp_num = pcount2(max(raw_matrix(:,i:i+Observe_Win_LEN-1),[],2),0);
            if temp_num == num_person
                temp_num = pcount2(max(raw_matrix(:,i+Observe_Win_LEN:i+2*Observe_Win_LEN-1),[],2),0);
                if temp_num == num_person         %连续不等，避免能量外溢的假相交情况
                    cross_flag = 0;
                    re_seperate_time = i;
                end
            end
            i = i+Observe_Win_LEN;
        end
        if cross_flag ~= 0                  %直到最后都没分离
            re_seperate_time = n;
        end
        disp(re_seperate_time);    
        %% 判断输出的时段 && 分离信号
        if cross_time-Observe_Win_LEN > n-re_seperate_time     %取相交前的信号，分离后进行输出
            flag_period = 1;
            
            %%%
            start_time = 1;
            ST_intvl = 0;
            while(start_time<cross_time && ST_intvl < 15)
                [~,~,~,~,ST_intvl] = pcount2(max(raw_matrix(:,start_time:start_time+Observe_Win_LEN-1),[],2),0); 
                attribute_ST = 0;
                if ST_intvl < 15
                    [~,~,~,~,ST_intvl] = pcount2(max(raw_matrix(:,start_time:start_time+Observe_Win_LEN-1),[],2),1);
                    attribute_ST = 1;
                end
                if ST_intvl < 15
                    start_time = start_time + Observe_Win_LEN;
                end
            end
            
            end_time = cross_time-Observe_Win_LEN-1;
            ET_intvl = 0;
            while(end_time>start_time && ET_intvl < 10)
                [~,~,~,~,ET_intvl] = pcount2(max(raw_matrix(:,end_time-Observe_Win_LEN+1:end_time),[],2),0);
                attribute_ET = 0;
                if ET_intvl < 10
                    [~,~,~,~,ET_intvl] = pcount2(max(raw_matrix(:,end_time-Observe_Win_LEN+1:end_time),[],2),1);
                    attribute_ET = 1;
                end
                if ET_intvl < 10
                    end_time = end_time - Observe_Win_LEN;
                end
            end
            n_time = end_time-start_time+1;
            %%%
            
            %初始化输出的存储结构
            for k = 1:num_person
                cell_of_matrix_sig{k} = zeros(POS,n_time);
            end
            %首窗、尾窗分析
            Win1_Bottom = get_WIN_bottom(num_person,max(raw_matrix(:,start_time:start_time+Observe_Win_LEN-1),[],2),attribute_ST);
            WinLAST_Bottom = get_WIN_bottom(num_person,max(raw_matrix(:,end_time-Observe_Win_LEN+1:end_time),[],2),attribute_ET);
            directions = zeros(1,num_person);
            for k = 1:num_person
                if Win1_Bottom{k}(1) < WinLAST_Bottom{k}(1)  %沿着左光纤向上
                    directions(k) = 1;
                    LS_B_index(k) = Win1_Bottom{k}(1);       %B:BEST
                    RS_B_index(k) = Win1_Bottom{k}(4);
                    LS_R_index(k) = WinLAST_Bottom{k}(2);    %R:Replaced
                    RS_R_index(k) = WinLAST_Bottom{k}(3);
                else
                    directions(k) = -1;
                    LS_B_index(k) = Win1_Bottom{k}(2);
                    RS_B_index(k) = Win1_Bottom{k}(3);
                    LS_R_index(k) = WinLAST_Bottom{k}(1);
                    RS_R_index(k) = WinLAST_Bottom{k}(4);
                end
            end          
        else                                %取相交并再次分开后的信号，分离后进行输出
            flag_period = 2;
            %%%
            start_time = re_seperate_time;
            ST_intvl = 0;
            while(start_time<n && ST_intvl < 15)
                [~,~,~,~,ST_intvl] = pcount2(max(raw_matrix(:,start_time:start_time+Observe_Win_LEN-1),[],2),0); 
                attribute_ST = 0;
                if ST_intvl < 15
                    [~,~,~,~,ST_intvl] = pcount2(max(raw_matrix(:,start_time:start_time+Observe_Win_LEN-1),[],2),1);
                    attribute_ST = 1;
                end
                if ST_intvl < 15
                    start_time = start_time + Observe_Win_LEN;
                end
            end
            
            end_time = n;
            ET_intvl = 0;
            while(end_time>start_time && ET_intvl < 10)
                [~,~,~,~,ET_intvl] = pcount2(max(raw_matrix(:,end_time-Observe_Win_LEN+1:end_time),[],2),0);
                attribute_ET = 0;
                if ET_intvl < 10
                    [~,~,~,~,ET_intvl] = pcount2(max(raw_matrix(:,end_time-Observe_Win_LEN+1:end_time),[],2),1);
                    attribute_ET = 1;
                end
                if ET_intvl < 10
                    end_time = end_time - Observe_Win_LEN;
                end
            end   
            n_time = end_time-start_time+1;
            %%%

            %初始化输出的存储结构
            for k = 1:num_person
                cell_of_matrix_sig{k} = zeros(POS,n_time);
            end
            %首窗、尾窗分析
            Win1_Bottom = get_WIN_bottom(num_person,max(raw_matrix(:,start_time:start_time+Observe_Win_LEN-1),[],2),attribute_ST);
            WinLAST_Bottom = get_WIN_bottom(num_person,max(raw_matrix(:,end_time-Observe_Win_LEN+1:end_time),[],2),attribute_ET);
            for k = 1:num_person
                if Win1_Bottom{k}(1) < WinLAST_Bottom{k}(1)  %沿着左光纤向上
                    directions(k) = 1;
                    LS_B_index(k) = Win1_Bottom{k}(1);       %B:BEST
                    RS_B_index(k) = Win1_Bottom{k}(4);
                    LS_R_index(k) = WinLAST_Bottom{k}(2);    %R:Replaced
                    RS_R_index(k) = WinLAST_Bottom{k}(3);
                else
                    directions(k) = -1;
                    LS_B_index(k) = Win1_Bottom{k}(2);
                    RS_B_index(k) = Win1_Bottom{k}(3);
                    LS_R_index(k) = WinLAST_Bottom{k}(1);
                    RS_R_index(k) = WinLAST_Bottom{k}(4);
                end
            end
        end
    else                    %始终无相交
            start_time = 1;
            end_time = n;
            n_time = n;
            flag_period = 3;
            %初始化输出的存储结构
            for k = 1:num_person
                cell_of_matrix_sig{k} = zeros(POS,n_time);
            end
            %首窗、尾窗分析
            Win1_Bottom = get_WIN_bottom(num_person,max(raw_matrix(:,1:Observe_Win_LEN),[],2),0);
            WinLAST_Bottom = get_WIN_bottom(num_person,max(raw_matrix(:,end_time-Observe_Win_LEN+1:end_time),[],2),0);
            directions = zeros(1,num_person);
            for k = 1:num_person
                if Win1_Bottom{k}(1) < WinLAST_Bottom{k}(1)  %沿着左光纤向上
                    directions(k) = 1;
                    LS_B_index(k) = Win1_Bottom{k}(1);       %B:BEST
                    RS_B_index(k) = Win1_Bottom{k}(4);
                    LS_R_index(k) = WinLAST_Bottom{k}(2);    %R:Replaced
                    RS_R_index(k) = WinLAST_Bottom{k}(3);
                else
                    directions(k) = -1;
                    LS_B_index(k) = Win1_Bottom{k}(2);
                    RS_B_index(k) = Win1_Bottom{k}(3);
                    LS_R_index(k) = WinLAST_Bottom{k}(1);
                    RS_R_index(k) = WinLAST_Bottom{k}(4);
                end
            end
    end
        %% 按行人序号划分POS上下界、重构切割后的信号矩阵
        for k = 1:num_person
            LS_low_bound  = compare0(1,LS_B_index(k),LS_R_index(k));
            LS_high_bound = compare0(2,LS_B_index(k),LS_R_index(k));
            RS_low_bound  = compare0(1,RS_B_index(k),RS_R_index(k));
            RS_high_bound = compare0(2,RS_B_index(k),RS_R_index(k));
            
            cell_of_matrix_sig{k}(LS_low_bound:LS_high_bound,:) = raw_matrix(LS_low_bound:LS_high_bound,start_time:end_time);
            cell_of_matrix_sig{k}(RS_low_bound:RS_high_bound,:) = raw_matrix(RS_low_bound:RS_high_bound,start_time:end_time);
            cell_of_matrix_pos{k}=[LS_low_bound,LS_high_bound,RS_low_bound,RS_high_bound];
        
        end
        
        if flag_period == 1 || flag_period == 3 
            for k = 1:num_person
                temp = cell_of_matrix_sig{k};
                if length(temp)>=5000
                    temp = temp(:,1:5000);
                    cell_of_matrix_sig{k} = temp;
                end
            end
        else
            for k = 1:num_person
                temp = cell_of_matrix_sig{k};
                N_temp = length(temp);
                temp = temp(:,N_temp-5000+1,N_temp);
                cell_of_matrix_sig{k} = temp;
            end
        end
else                        %单人行：无干扰情况
    cell_of_matrix_sig{1} = raw_matrix;
    breakflag = 0;
    n = length(raw_matrix);
    counter_ST = 0;
    counter_ET = 0;
    %%%空间降噪:
    start_time = 1;
    while(start_time<n)
        Win1_Bottom = pcount1(max(raw_matrix(:,start_time:start_time+Observe_Win_LEN-1),[],2));
        if length(Win1_Bottom) == 4
            Win1_min = Win1_Bottom(1);
            Win1_max = Win1_Bottom(4);
            break;
        else
            start_time = start_time+Observe_Win_LEN;
            counter_ST = counter_ST + 1;
            if start_time+Observe_Win_LEN > n
                breakflag = 1;
                start_time = n;
                break;
            end
        end
    end
    
    end_time = n;
    while(end_time > start_time)
        WinLAST_Bottom = pcount1(max(raw_matrix(:,end_time-Observe_Win_LEN+1:end_time),[],2));
        if length(WinLAST_Bottom) == 4
            WinLAST_min = WinLAST_Bottom(1);
            WinLAST_max = WinLAST_Bottom(4);
            break;
        else
            end_time = end_time-Observe_Win_LEN;
            counter_ET = counter_ET + 1;
        end
    end
    if breakflag==0
        high_bound = max(Win1_max,WinLAST_max);
        low_bound = min(Win1_min,WinLAST_min);
        cell_of_matrix_pos{1} = {low_bound-counter_ST*5,high_bound+counter_ET*5};
        cell_of_matrix_sig{1} = zeros(POS,n);
        cell_of_matrix_sig{1}(low_bound-counter_ST*5:high_bound+counter_ET*5,:) = raw_matrix(low_bound-counter_ST*5:high_bound+counter_ET*5,:);
    else
        cell_of_matrix_sig{1} = raw_matrix;
    end
end
end

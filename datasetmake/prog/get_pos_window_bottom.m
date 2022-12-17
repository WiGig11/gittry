function cell_of_bottoms = get_pos_window_bottom(num_person,vec)
%get_pos_window_bottom 返回未相交时，各人的Bottom坐标
%返回值  cell_of_bottoms 是1*num_person元胞,每个元胞为1*4向量，元素是按低位到高位排列的Bottom
cell_of_bottoms = cell(1,num_person);
N = length(vec);
for k = 1:num_person
    cell_of_bottoms{k} = zeros(1,4);
end
[~,LS_array,RS_array,count] = p_count(vec);
N_RS_array = length(RS_array);
N_LS_array = length(LS_array);
TOLERANT_SPAN = 10;
if count == 2*num_person
    state = 0;
elseif count == 2*num_person - 1
    state = 1;
else
    state = 2;
end

switch(state)
    case 0
        %%%镜像配对
        for k = 1:num_person
            cell_of_bottoms{k}(1) = LS_array(1+(k-1)*2);
            cell_of_bottoms{k}(2) = LS_array(2*k);
            cell_of_bottoms{k}(3) = RS_array(N_RS_array-(k-1)*2-1);
            cell_of_bottoms{k}(4) = RS_array(N_RS_array-(k-1)*2);
        end
    case 1
        %%%配对num_person -1 
        for k = 1:num_person-1
            cell_of_bottoms{k}(1) = LS_array(1+(k-1)*2);
            cell_of_bottoms{k}(2) = LS_array(2*k);
            cell_of_bottoms{k}(3) = RS_array(N_RS_array-(k-1)*2-1);
            cell_of_bottoms{k}(4) = RS_array(N_RS_array-(k-1)*2);
        end       
        %%% 挖掘中间峰，三种情况
        if N_LS_array == 2*num_person && N_RS_array == 2*num_person-2      %右缺峰
            LS_index = LS_array(2*num_person-1);           
            cell_of_bottoms{num_person}(1) = LS_index;
            cell_of_bottoms{num_person}(2) = LS_array(2*num_person);
            RS_index = RS_array(1);      
            %%% analyze vec from MID to RS_index
            [~,max_index] = max(vec(round(N/2):RS_index));
            max_index = max_index + round(N/2)-1;              %添加偏移量
            suspect_bottom = [];
            
            j = round(N/2);
            while(j <= max_index-1)
                if vec(j) ~= 0 && vec(j) <= vec(j+1)
                    i = j+1;
                    flag = 1;
                    while(i < max_index && flag == 1)
                        if vec(i) >= vec(i+1)
                            flag = -1;
                            suspect_bottom =[suspect_bottom i];
                        end
                        i = i+1;
                    end
                    j = i;
                else
                    j = j+1;
                end
            end
            
            j = max_index;
            while(j <= RS_index-1)
                if vec(j) <= vec(j+1)
                    i = j+1;
                    flag = 1;
                    while(i < RS_index && flag == 1)
                        if vec(i) > vec(i+1)
                            flag = -1;
                            suspect_bottom =[suspect_bottom i];
                        end
                        i = i+1;
                    end
                    j = i;
                else
                    j = j+1;
                end
            end
            %%% choosing part
            N_sus = length(suspect_bottom);
            value1 = zeros(1,N_sus);
            value2 = zeros(1,N_sus);
            mirror_distance1 = zeros(1,N_sus);
            mirror_distance2 = zeros(1,N_sus);
            for u = 1:N_sus
                mirror_distance1(u) = abs(N-suspect_bottom(u)-cell_of_bottoms{num_person}(1));
                mirror_distance2(u) = abs(N-suspect_bottom(u)-cell_of_bottoms{num_person}(2));
                value1(u) = -0.8*(mirror_distance1(u))+0.2*vec(suspect_bottom(u));
                value2(u) = -0.8*(mirror_distance2(u))+0.2*vec(suspect_bottom(u));
            end
            [~,decision_index1] = max(value1);
            [~,decision_index2] = max(value2);
            cell_of_bottoms{num_person}(3) = suspect_bottom(decision_index1);
            cell_of_bottoms{num_person}(4) = suspect_bottom(decision_index2);
            
        elseif N_RS_array == 2*num_person && N_LS_array == 2*num_person-2        %左缺峰
            RS_index = RS_array(2*num_person-1);           
            cell_of_bottoms{num_person}(3) = RS_index;
            cell_of_bottoms{num_person}(4) = RS_array(2*num_person);
            LS_index = LS_array(2);      
            %%% analyze vec from LS_index to MID
            [~,max_index] = max(vec(LS_index:round(N/2)));
            max_index = max_index + LS_index-1;              %添加偏移量
            suspect_bottom = [];           
            j = LS_index;
            while(j <= max_index-1)
                if vec(j)>0 && vec(j) <= vec(j+1)
                    i = j+1;
                    flag = 1;
                    while(i < max_index && flag == 1)
                        if vec(i) >= vec(i+1)
                            flag = -1;
                            suspect_bottom =[suspect_bottom i];
                        end
                        i = i+1;
                    end
                    j = i;
                else
                    j = j+1;
                end
            end
            
            j = max_index;
            while(j <= MID)
                if vec(j) <= vec(j+1)
                    i = j+1;
                    flag = 1;
                    while(i < RS_index && flag == 1)
                        if vec(i) > vec(i+1)
                            flag = -1;
                            suspect_bottom =[suspect_bottom i];
                        end
                        i = i+1;
                    end
                    j = i;
                else
                    j = j+1;
                end
            end
            %%% choosing part
            N_sus = length(suspect_bottom);
            value1 = zeros(1,N_sus);
            value2 = zeros(1,N_sus);
            mirror_distance1 = zeros(1,N_sus);
            mirror_distance2 = zeros(1,N_sus);
            for u = 1:N_sus
                mirror_distance1(u) = abs(N-suspect_bottom(u)-cell_of_bottoms{num_person}(3));
                mirror_distance2(u) = abs(N-suspect_bottom(u)-cell_of_bottoms{num_person}(4));
                value1(u) = -0.8*(mirror_distance1(u))+0.2*vec(suspect_bottom(u));
                value2(u) = -0.8*(mirror_distance2(u))+0.2*vec(suspect_bottom(u));
            end
            [~,decision_index1] = max(value1);
            [~,decision_index2] = max(value2);
            cell_of_bottoms{num_person}(1) = suspect_bottom(decision_index1);
            cell_of_bottoms{num_person}(2) = suspect_bottom(decision_index2);
            
        else                                                                    %中粘峰
            LS_index = LS_array(2*num_person-1);           
            cell_of_bottoms{num_person}(1) = LS_index;
            RS_index = RS_array(1);
            cell_of_bottoms{num_person}(4) = RS_index;     
            %%% analyze vec from LS_index to RS_index
            [~,max_index] = max(vec(LS_index-TOLERANT_SPAN:RS_index+TOLERANT_SPAN));
            max_index = max_index + LS_index-TOLERANT_SPAN-1;              %添加偏移量
            suspect_bottom = [];
            j = LS_index;
            while(j <= max_index-1)
                if vec(j) >= vec(j+1)
                    i = j+1;
                    flag = -1;
                    while(i < max_index && flag == -1)
                        if vec(i) <= vec(i+1)
                            flag = 1;
                            suspect_bottom =[suspect_bottom i];
                        end
                        i = i+1;
                    end
                    j = i;
                else
                    j = j+1;
                end
            end
            
            j = max_index;
            while(j <= RS_index+TOLERANT_SPAN-1)
                if vec(j) <= vec(j+1)
                    i = j+1;
                    flag = 1;
                    while(i < RS_index && flag == 1)
                        if vec(i) > vec(i+1)
                            flag = -1;
                            suspect_bottom =[suspect_bottom i];
                        end
                        i = i+1;
                    end
                    j = i;
                else
                    j = j+1;
                end
            end
            %%% choosing part
            N_sus = length(suspect_bottom);
            if N_sus > 0
                value = zeros(1,N_sus);
                for u = 1:N_sus
                    value(u) = -0.7*(abs(suspect_bottom(u)-max_index))+0.3*vec(suspect_bottom(u));
                end
                [~,decision_index] = max(value);
                cell_of_bottoms{num_person}(2) = suspect_bottom(decision_index);
                cell_of_bottoms{num_person}(3) = suspect_bottom(decision_index)+1;
            else
                %%%  右邻近再搜索
            end
       
        end
        
    case 2
        error('WRONG COUNT!');
end

end


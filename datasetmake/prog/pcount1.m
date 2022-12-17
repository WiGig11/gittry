function edge_index = pcount1(vec)
%pcunt1 返回窗口内的峰脚点
%输入vec:观察窗口内max_intensity_by_pos

N = length(vec);
i = 1;                  %从低位向高位
edge_index = [];
%搜索与存储峰脚点
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
            if temp_r - temp_l > 3           %防止记录伪峰
                edge_index = [edge_index temp_l temp_r];
            end
            i = j + 1;
        else
            break;
        end
    else
        i = i+1;
    end   
   end
   edge_index = array_delete1(edge_index);
end




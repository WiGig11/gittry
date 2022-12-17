function average_stride = get_stride2(vec1,vec2)
%get_stride2 步幅分析:获得行走状态+平均每步的距离（单位cm）
%low group 左光纤  high_group 右光纤
%flag = -1:未检测到步数  0:原地踏步  1：相对左光纤向上  2：相对左光纤向下
%输入vec为peak_pos
%VERSION2:双输入，择优
STANDARD = 70;
H_RANGE = 120;
[~,ave1] = get_stride(vec1);
[~,ave2] = get_stride(vec2);
if ave1 >= STANDARD && ave2 >= STANDARD && min(ave1,ave2) < H_RANGE
    gap1 = abs(ave1-80);
    gap2 = abs(ave2-80);
    if gap1 <= gap2
        average_stride = ave1;
    else
        average_stride = ave2;
    end
elseif min(ave1,ave2) >= H_RANGE
    average_stride = 0;
elseif max(ave1,ave2) <= 35
    average_stride = 0;
elseif min(ave1,ave2) >35 && max(ave1,ave2) < 50
    average_stride = 0.6*max(ave1,ave2)+0.4*min(ave1,ave2);
elseif abs(ave1-ave2) >= 30
    gap1 = abs(ave1-80);
    gap2 = abs(ave2-80);
    if gap1 <= gap2
        average_stride = ave1;
    else
        average_stride = ave2;
    end
elseif min(ave1,ave2) >= 50 && max(ave1,ave2) < STANDARD
    average_stride = 0.7*max(ave1,ave2)+0.3*min(ave1,ave2);
else
    average_stride = 0.5*(ave1+ave2);
%     disp(ave1);
%     disp(ave2);
end
end


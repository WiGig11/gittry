function average_stride = get_stride2(vec1,vec2)
%get_stride2 ��������:�������״̬+ƽ��ÿ���ľ��루��λcm��
%low group �����  high_group �ҹ���
%flag = -1:δ��⵽����  0:ԭ��̤��  1��������������  2��������������
%����vecΪpeak_pos
%VERSION2:˫���룬����
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


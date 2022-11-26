function [step_freq_accurate,peak_pos,peak1,peak1_index] = get_peak_pos(vec,matrix,num_peak1,delta_peak_time1,startpos,GAP,THREAD)
%get_peak_pos 得到最大强度的采样传感器的序

for i = 1:floor(length(vec)/GAP)
    temp = 0;
    for j = 1+(i-1)*GAP:GAP*i
        temp = vec(j)^2 + temp;
    end
    if(temp >= THREAD)
        pointer = i;
        break;
    else
        error('输入不符合要求,阈值设置的太大');
        break;
    end
end

[first_peak1,first_peak1_index] = max(vec(1+(pointer-1)*GAP:GAP*pointer));%简单搜索第一个峰值点，认为1：GAP内只有1个峰
%Version 2： 通过能量指示器get first peak

% pos = zeros(1,num_peak1);
suspect_peak1_index = zeros(1,num_peak1);
peak1_index = zeros(1,num_peak1);
peak1 = zeros(1,num_peak1);
peak_pos=zeros(1,num_peak1);
peak1(1) = first_peak1;
peak1_index(1) = first_peak1_index;
suspect_peak1_index(1) = first_peak1_index;

H_RANGE = 80;
% DE_FACTOR = 0.85;                                 %衰减因子

for i = 2:num_peak1                               %双保险
    suspect_peak1_index(i) = suspect_peak1_index(i-1)+delta_peak_time1(i-1);
    if suspect_peak1_index(i)+H_RANGE > length(vec)
        M = length(vec);
    else
        M = suspect_peak1_index(i)+H_RANGE;
    end
    if isempty(find(vec(suspect_peak1_index(i)-H_RANGE:M)~=0, 1))==0  %有函数不是全0
        [peak1(i),peak1_index(i)] = max(vec(suspect_peak1_index(i)-H_RANGE:M));
    else
        peak1_index(i) = round(0.5*(suspect_peak1_index(i)-H_RANGE+M));
        peak1(i) = vec(round(0.5*(suspect_peak1_index(i)-H_RANGE+M)));
    end
    
    peak1_index(i) = peak1_index(i) + suspect_peak1_index(i)-H_RANGE-1;
end
                
for j = 1:num_peak1
    [~,peak_pos(j)] = max(matrix(:,peak1_index(j)));
    peak_pos(j) = peak_pos(j) + startpos - 1;
end

step_freq_accurate = (num_peak1-1)/((peak1_index(num_peak1)-peak1_index(1))/(866*60));

%     for k = 1:num_peak1
%         temp_s = [];
%         %输入检查
%         if peak1_index(k)+H_RANGE > length(vec)
%             M = length(vec);
%         else
%             M = peak1_index(k)+H_RANGE;
%         end
%         
%         if peak1_index(k)-H_RANGE < 0
%             SS = 1;
%         else
%             SS =  peak1_index(k)-H_RANGE;
%         end
%         %输入检查
%         for h =SS:1:M
%             if(vec(h)>= DE_FACTOR * peak1(k))
%                 temp_s = [temp_s h];          %可用的采样时间点
%             end
%         end
%         %搜索相应位置点
%         temp_x = length(temp_s);
%         temp_p = zeros(1,temp_x);
%         for j = 1:temp_x
%             [~,temp_p(j)] = max(matrix(:,temp_s(j)));  
%              temp_p(j) = temp_p(j) + startpos - 1;     
%         end
%         pos(k) = round(sum(temp_p)/temp_x);   %该变量无用 记录于11.01
%     end

end



function num = get_walker_num(matrix)
%GET_WALKER_NUM 获取步行人数
Observe_Window_LEN = 500;
vec1 = max(matrix(:,1:Observe_Window_LEN),[],2);
temp1 = length(pcount1(vec1))/2;
vec2 = max(matrix(:,1+Observe_Window_LEN:2*Observe_Window_LEN),[],2);
temp2 = length(pcount1(vec2))/2;

if temp1 == temp2
    num = temp1;
else
    num = temp2;
end
    
end


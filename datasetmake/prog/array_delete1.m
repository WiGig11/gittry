function output_vec = array_delete1(vec)
%ARRAY_DELETE1 对输入的向量，删除其中所有重复的元素，按原顺序输出
N = length(vec);
counter = 0;
j = 1;
while(j<=N-1)
    if vec(j) == vec(j+1)
        counter = counter + 2;
        vec(j) = 0;
        vec(j+1)= 0;
        j = j+2;
    else
        j = j+1;
    end
end
N_out= N-counter;
output_vec = zeros(1,N_out);
temp = 1;
for i = 1:N
    if vec(i) ~= 0
        output_vec(temp) = vec(i);
        temp = temp + 1;
    end
end
end
        
    




function output_array = array_delete2(Num,vec)
%ARRAY_DELETE2 删除VEC中序号属于Num的元素并按原顺序输出
N_delete = length(Num);
N = length(vec);
N_out = N-N_delete;
output_array = zeros(1,N_out);
for j = 1:N_delete
    vec(Num(j)) = -1;
end
temp = 1;
for i = 1:N
    if vec(i) ~= -1
        output_array(temp) = vec(i);
        temp = temp + 1;
    end
end
end


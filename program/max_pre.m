function output_vec = max_pre(vec)
%MAX_PRE ∂‘time-max_intensity‘ŸΩµ‘Î
N = length(vec);
output_vec = vec;
for i = 1:N
    if output_vec(i) < 0.025
        output_vec(i) = 0;
    end
end
end


function p_list = get_delta_time_para(vec)
%
mean_delta_time = mean(vec);
var_delta_time = var(vec);
p_list = [mean_delta_time,var_delta_time];
end


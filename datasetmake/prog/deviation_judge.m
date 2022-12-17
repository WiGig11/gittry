function warning = deviation_judge(blind_flag,LS_energy,RS_energy)
%DEVIATION_JUDGE 对盲人是否偏离盲道进行定性判断
%   偏离条件：L/R能量出现三个及以上的连“0”，值小于0.001算作“0”
%   warning = -1:非盲人，不予判断；   0：不偏    1：已偏   -2:步数少于3，不予判断
%   blind_flag 需由识别结果给出   0：非盲人     1：盲人 
N_LS = length(LS_energy);
N_RS = length(RS_energy);
warning = -3;

if N_LS < 3
    disp("步数太少，不可判断是否偏航");
    warning = -2;
else
    if (blind_flag)
        for j = 1:N_LS
            if LS_energy(j) < 0.001
                LS_energy(j) = 0;
            end
        end
        for j = 1:N_RS
            if RS_energy(j) < 0.001
                RS_energy(j) = 0;
            end
        end
        
        i = 1;
        while(i <= N_LS -2 )
            if LS_energy(i)+LS_energy(i+1)+LS_energy(i+2) == 0      %向左偏
                warning = 1;
                disp("检测到有偏离盲道的可能，请向右走位！");
                break;
            elseif RS_energy(i)+RS_energy(i+1)+RS_energy(i+2) == 0  %向右偏 
                warning = 1;
                disp("检测到有偏离盲道的可能，请向左走位！");
                break;
            else
                i = i+1;
            end
        end
        if warning ~= 1
            warning = 0;                                            %正常
            disp("正常，请继续行走！");
        end
        
    else
        warning = -1;    %非盲人，不予判断
    end
end
end


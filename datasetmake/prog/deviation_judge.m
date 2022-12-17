function warning = deviation_judge(blind_flag,LS_energy,RS_energy)
%DEVIATION_JUDGE ��ä���Ƿ�ƫ��ä�����ж����ж�
%   ƫ��������L/R�����������������ϵ�����0����ֵС��0.001������0��
%   warning = -1:��ä�ˣ������жϣ�   0����ƫ    1����ƫ   -2:��������3�������ж�
%   blind_flag ����ʶ��������   0����ä��     1��ä�� 
N_LS = length(LS_energy);
N_RS = length(RS_energy);
warning = -3;

if N_LS < 3
    disp("����̫�٣������ж��Ƿ�ƫ��");
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
            if LS_energy(i)+LS_energy(i+1)+LS_energy(i+2) == 0      %����ƫ
                warning = 1;
                disp("��⵽��ƫ��ä���Ŀ��ܣ���������λ��");
                break;
            elseif RS_energy(i)+RS_energy(i+1)+RS_energy(i+2) == 0  %����ƫ 
                warning = 1;
                disp("��⵽��ƫ��ä���Ŀ��ܣ���������λ��");
                break;
            else
                i = i+1;
            end
        end
        if warning ~= 1
            warning = 0;                                            %����
            disp("��������������ߣ�");
        end
        
    else
        warning = -1;    %��ä�ˣ������ж�
    end
end
end


function result = compare0(flag,inputArg1,inputArg2)
%COMPARE0 ��flag����������У���orС��һ����������򱨴�
if flag == 1   %ȡС��
    if inputArg1 < inputArg2
        result = inputArg1;
    elseif inputArg1 > inputArg2
        result = inputArg2;
    else
        error('CANNOT COMPARE!');
    end

elseif flag == 2    %ȡ���
    if inputArg1 < inputArg2
        result = inputArg2;
    elseif inputArg1 > inputArg2
        result = inputArg1;
    else
        error('CANNOT COMPARE!');
    end
else
    error('WRONG FLAG FOR COMPARING!');
end
       
end


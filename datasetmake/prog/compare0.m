function result = compare0(flag,inputArg1,inputArg2)
%COMPARE0 按flag输出两个数中，大or小的一个，若相等则报错
if flag == 1   %取小的
    if inputArg1 < inputArg2
        result = inputArg1;
    elseif inputArg1 > inputArg2
        result = inputArg2;
    else
        error('CANNOT COMPARE!');
    end

elseif flag == 2    %取大的
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


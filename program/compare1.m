function result = compare1(a,b,DELTA)
%compare1 DELTA ����ڱȽϴ�С

if abs(a-b) <= DELTA
    result = 0;
elseif a - b > DELTA
    result = 2;
else
    result = 1;
end
end


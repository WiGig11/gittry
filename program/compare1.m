function result = compare1(a,b,DELTA)
%compare1 DELTA 差距内比较大小

if abs(a-b) <= DELTA
    result = 0;
elseif a - b > DELTA
    result = 2;
else
    result = 1;
end
end


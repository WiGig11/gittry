function result = compare2(a,b)
%compare2  比较大小

if a== b
    result = 0;
elseif a - b > 0
    result = 2;
else
    result = 1;
end
end



function mydata = yuanbaoshuzu(max1,n)
%���������������ΪԪ������
mydata = cell(1, floor(length(max1)/n));
for i = 1:1:floor(length(max1)/n)
    if  i ==1
        mydata{1} = max1(1,1:n*i);
    else
        mydata{i} = max1(1,1+n*(i-1):n*i);
    end
end
end


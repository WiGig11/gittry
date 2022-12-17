function y = datapre(intensity1,startpos,endpos,starttime,endtime)

intensity1 = intensity1(startpos:1:endpos,starttime:1:endtime);
for i = 1:1:endpos-startpos+1
    for j = 1:1:endtime-starttime+1
        if intensity1(i,j)<0.028      %ÂË³ýµ×Ôë
            intensity1(i,j) = 0;
        else
        end
    end
end
y = intensity1;
end


function features = extractf(mydata,max1,n)
features = [];%特征值数组
for i = 1:1:floor(length(max1)/n)

    Xm = mean(mydata{i});%均值
    xf = max(mydata{i});%峰值
    
    %计算方差均值比
    temp = 0;
    for j = 1:1:length(mydata{i})
        temp = temp + (mydata{i}(j) - Xm)^2;
    end
    temp = temp / length(mydata{i});
    Xc = temp / Xm;
    
    %峰值系数
    Xr = mydata{i}*mydata{i}';
    Xr = sqrt(Xr/length(mydata{i}));
    Xf = xf/Xr;
    
    features = [features Xc Xf ]; 
end
      
end


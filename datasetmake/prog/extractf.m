function features = extractf(mydata,max1,n)
features = [];%����ֵ����
for i = 1:1:floor(length(max1)/n)

    Xm = mean(mydata{i});%��ֵ
    xf = max(mydata{i});%��ֵ
    
    %���㷽���ֵ��
    temp = 0;
    for j = 1:1:length(mydata{i})
        temp = temp + (mydata{i}(j) - Xm)^2;
    end
    temp = temp / length(mydata{i});
    Xc = temp / Xm;
    
    %��ֵϵ��
    Xr = mydata{i}*mydata{i}';
    Xr = sqrt(Xr/length(mydata{i}));
    Xf = xf/Xr;
    
    features = [features Xc Xf ]; 
end
      
end


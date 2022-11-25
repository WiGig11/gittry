function [features] = get_feature(sigcell)
%GET_FEATURE 此处显示有关此函数的摘要
%   此处显示详细说明
features = [];%特征值数组
%%
%能量特征
% for i = 1:1:round(length(vector)/gap)
if iscell(sigcell)==1
    bw = [];
    for i  = 1:length(sigcell)
        sum  = 0;
        count = 1;
        vector = sigcell{i,1};
        while(sum < 0.95*vector*vector')
            sum = sum + vector(count)^2;
            count = count+1;
        end
        %主值频率
        [peak,~] = max(vector);
        features = [features,count,peak];
    end
else
    vector = sigcell;
    while(sum < 0.95*vector*vector')
        sum = sum + vector(count)^2;
        count = count+1;
    end
    [peak,~] = max(vector);
    features = [count peak];
end
temp1=0;
temp2 = 0;

if length(features)>2
    for i = 1:length(features)/2
        temp1 = temp1+features(2*i-1);
        temp2 = temp2+features(2*i);
    end
    features = [2*temp1/length(features),2*temp2/length(features)];
else
    features = features;
end


% bw = count/length(vector);




end


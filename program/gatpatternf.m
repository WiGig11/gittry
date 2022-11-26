function [distance] = gatpatternf(patternmatrix)
%GATPATTERNF 此处显示有关此函数的摘要
%   此处显示详细说明
temp = [];
sip = size(patternmatrix);
for i = 1:length(sip(1,1))
    dist = pdist([patternmatrix(:,i)';zeros(1,length(patternmatrix))]);
    temp = [temp dist];
end
distance= mean(temp);
end


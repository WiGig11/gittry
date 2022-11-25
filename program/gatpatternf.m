function [distance] = gatpatternf(patternmatrix)
%GATPATTERNF �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
temp = [];
sip = size(patternmatrix);
for i = 1:length(sip(1,1))
    dist = pdist([patternmatrix(:,i)';zeros(1,length(patternmatrix))]);
    temp = [temp dist];
end
distance= mean(temp);
end


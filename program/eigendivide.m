function [pattern,patterncell] = eigendivide(step_sig2_group2)
%EIGENDIVIDE 此处显示有关此函数的摘要
%使用特征脸算法把每个单步二维信号投射到特征空间得到特种空间种的一个点，输出pattern和patterncell都是特征空间种的坐标，数据格式不同
%   此处显示详细说明
s = [];
L = length(step_sig2_group2);
sizcell = size(step_sig2_group2{1,1});
for k = 1:L
    s(:,k) = reshape(step_sig2_group2{k,1},sizcell(1,1)*sizcell(1,2),1);
end
s1 = 0;
for i = 1:L
    s1 = s1+s(:,i);
end
s1 = s1/L;
T = [];
for j =1:L
    T(:,j) = s(:,j)-s1;
end
C = T*T';
[E,D] = eig(C);
eigen_values = diag(D);
eigen_vectors = E;
[~, index] = sort(eigen_values, 'descend'); 
% 获取排序后的征值对应的特征向量    
sorted_eigen_vectors = eigen_vectors(:, index);
% 特征脸(所有）    
omega = sorted_eigen_vectors'*T;
pattern = [];
for i = 1:L
    temp = mean(omega(:,i),2);
    pattern = [pattern temp];
end
patterncell = cell(L,1);
for i = 1:L
    patterncell{i,1} = reshape(pattern(:,i),9,256);
end

end


function [pattern,patterncell] = eigendivide(step_sig2_group2)
%EIGENDIVIDE �˴���ʾ�йش˺�����ժҪ
%ʹ���������㷨��ÿ��������ά�ź�Ͷ�䵽�����ռ�õ����ֿռ��ֵ�һ���㣬���pattern��patterncell���������ռ��ֵ����꣬���ݸ�ʽ��ͬ
%   �˴���ʾ��ϸ˵��
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
% ��ȡ��������ֵ��Ӧ����������    
sorted_eigen_vectors = eigen_vectors(:, index);
% ������(���У�    
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


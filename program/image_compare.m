function [] = image_compare(signal_matrix1,signal_matrix2,wavelet,used_fig)
%IMAGE_COMPARE �˴���ʾ�йش˺�����ժҪ
%�ԱȲ�ͬ����С���任���
%   �˴���ʾ��ϸ˵��
%WAVELET �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
%DWT_3_WAVE ��ͬһʵ���ߵ���������С�������Ա�
%%
%��������Ա�����
N = 3;
LEN = length(signal_matrix1{1,1});
LEN_DWT = 5076;
cA_low1 = zeros(3,LEN_DWT);
cD_high1 = zeros(3,8);
y1 = cell(3,1);
for i = 1:N
    y1{i,1} = zeros(9,LEN);
end
temp = zeros(4,2);
for i = 1:N
    %    [cA(i,:),cD(i,:)]=dwt(signal_matrix(i,:),'db4'); %����db4С�������źŽ���һά��ɢС���ֽ⡣
    [cA,temp]=wavedec2(signal_matrix1{i,:},2,wavelet); %����db4С�������źŽ��ж�ά��ɢС���ֽ⡣
    cA_low1(i,:) = cA;
    cD_high1(i,:) = reshape(temp,1,8);
    y1{i,1}=wrcoef2('a',cA_low1(i,:),reshape(cD_high1(i,:),4,2),wavelet);
    %      y(i,:)=idwt(cA_low(i,:),reshape(cD_high(i,:),4,2),wavelet); %һά��ɢС�����任
end

cA_low2 = zeros(3,LEN_DWT);
cD_high2 = zeros(3,8);
y2 = cell(3,1);
for i = 1:N
    y2{i,1} = zeros(9,LEN);
end
temp = zeros(4,2);
for i = 1:N
    %    [cA(i,:),cD(i,:)]=dwt(signal_matrix(i,:),'db4'); %����db4С�������źŽ���һά��ɢС���ֽ⡣
    [cA,temp]=wavedec2(signal_matrix2{i,:},2,wavelet); %����db4С�������źŽ��ж�ά��ɢС���ֽ⡣
    cA_low2(i,:) = cA;
    cD_high2(i,:) = reshape(temp,1,8);
    y2{i,1}=wrcoef2('a',cA_low2(i,:),reshape(cD_high2(i,:),4,2),wavelet);
    %      y(i,:)=idwt(cA_low(i,:),reshape(cD_high(i,:),4,2),wavelet); %һά��ɢС�����任
end
%% ��ͼ
figure(used_fig +1)

subplot(2,3,1);
plot(cA_low1(1,:)); %��������ͼ
title('1��step1��Ƶ����dwt-cA');

subplot(2,3,2);
plot(cA_low1(2,:)); %��������ͼ
title('1��step2��Ƶ����dwt-cA');

subplot(2,3,3);
plot(cA_low1(3,:)); %��������ͼ
title('1��step3��Ƶ����dwt-cA');

subplot(2,3,4);
plot(cA_low2(1,:)); %��������ͼ
title('2��step1��Ƶ����dwt-cA');

subplot(2,3,5);
plot(cA_low2(2,:)); %��������ͼ
title('2��step2��Ƶ����dwt-cA');

subplot(2,3,6);
plot(cA_low2(3,:)); %��������ͼ
title('2��step2��Ƶ����dwt-cA');
%%

% subplot(3,3,7);
% plot(y{1,1}); %��������ͼ
% title('step1�ع�idwt');
% 
% subplot(3,3,8);
% plot(y{2,1}); %��������ͼ
% title('step2�ع�idwt');
% 
% subplot(3,3,9);
% plot(y{3,1}); %��������ͼ
% title('step3�ع�idwt');

end


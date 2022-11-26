function [cA_low,cD_high] = wavelet(signal_matrix,wavelet,used_fig)
%WAVELET �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
%DWT_3_WAVE ��ͬһʵ���ߵ������Ķ�ά�źŽ���С�������Ա�
N = 3;
LEN = length(signal_matrix{1,1});
LEN_DWT = 5076;
cA_low = zeros(3,LEN_DWT);
cD_high = zeros(3,8);
y = cell(3,1);
for i = 1:N
    y{i,1} = zeros(9,LEN);
end
temp = zeros(4,2);

%% С���任����
for i = 1:N
    %    [cA(i,:),cD(i,:)]=dwt(signal_matrix(i,:),'db4'); %����db4С�������źŽ���һά��ɢС���ֽ⡣
    [cA,temp]=wavedec2(signal_matrix{i,:},2,wavelet); %����db4С�������źŽ��ж�ά��ɢС���ֽ⡣
    cA_low(i,:) = cA;
    cD_high(i,:) = reshape(temp,1,8);
    y{i,1}=wrcoef2('a',cA_low(i,:),reshape(cD_high(i,:),4,2),wavelet);
    %      y(i,:)=idwt(cA_low(i,:),reshape(cD_high(i,:),4,2),wavelet); %һά��ɢС�����任
end

%% ��ͼ
figure(used_fig +1)

subplot(3,1,1);
plot(cA_low(1,:)); %��������ͼ
title('step1��Ƶ����dwt-cA');

subplot(3,1,2);
plot(cA_low(2,:)); %��������ͼ
title('step2��Ƶ����dwt-cA');

subplot(3,1,3);
plot(cA_low(3,:)); %��������ͼ
title('step3��Ƶ����dwt-cA');

% subplot(2,3,4);
% plot(cD_high(1,:)); %��������ͼ
% title('step1��Ƶ����dwt-cD');
% 
% subplot(2,3,5);
% plot(cD_high(2,:)); %��������ͼ
% title('step2��Ƶ����dwt-cD');
% 
% subplot(2,3,6);
% plot(cD_high(3,:)); %��������ͼ
% title('step3��Ƶ����dwt-cD');

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


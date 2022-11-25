function [cA_low,cD_high] = wavelet(signal_matrix,wavelet,used_fig)
%WAVELET 此处显示有关此函数的摘要
%   此处显示详细说明
%DWT_3_WAVE 对同一实验者的三步的二维信号进行小波分析对比
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

%% 小波变换计算
for i = 1:N
    %    [cA(i,:),cD(i,:)]=dwt(signal_matrix(i,:),'db4'); %采用db4小波并对信号进行一维离散小波分解。
    [cA,temp]=wavedec2(signal_matrix{i,:},2,wavelet); %采用db4小波并对信号进行二维离散小波分解。
    cA_low(i,:) = cA;
    cD_high(i,:) = reshape(temp,1,8);
    y{i,1}=wrcoef2('a',cA_low(i,:),reshape(cD_high(i,:),4,2),wavelet);
    %      y(i,:)=idwt(cA_low(i,:),reshape(cD_high(i,:),4,2),wavelet); %一维离散小波反变换
end

%% 画图
figure(used_fig +1)

subplot(3,1,1);
plot(cA_low(1,:)); %画出波形图
title('step1低频部分dwt-cA');

subplot(3,1,2);
plot(cA_low(2,:)); %画出波形图
title('step2低频部分dwt-cA');

subplot(3,1,3);
plot(cA_low(3,:)); %画出波形图
title('step3低频部分dwt-cA');

% subplot(2,3,4);
% plot(cD_high(1,:)); %画出波形图
% title('step1高频部分dwt-cD');
% 
% subplot(2,3,5);
% plot(cD_high(2,:)); %画出波形图
% title('step2高频部分dwt-cD');
% 
% subplot(2,3,6);
% plot(cD_high(3,:)); %画出波形图
% title('step3高频部分dwt-cD');

% subplot(3,3,7);
% plot(y{1,1}); %画出波形图
% title('step1重构idwt');
% 
% subplot(3,3,8);
% plot(y{2,1}); %画出波形图
% title('step2重构idwt');
% 
% subplot(3,3,9);
% plot(y{3,1}); %画出波形图
% title('step3重构idwt');

end


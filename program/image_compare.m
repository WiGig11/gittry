function [] = image_compare(signal_matrix1,signal_matrix2,wavelet,used_fig)
%IMAGE_COMPARE 此处显示有关此函数的摘要
%对比不同数据小波变换结果
%   此处显示详细说明
%WAVELET 此处显示有关此函数的摘要
%   此处显示详细说明
%DWT_3_WAVE 对同一实验者的三步进行小波分析对比
%%
%生成两组对比数据
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
    %    [cA(i,:),cD(i,:)]=dwt(signal_matrix(i,:),'db4'); %采用db4小波并对信号进行一维离散小波分解。
    [cA,temp]=wavedec2(signal_matrix1{i,:},2,wavelet); %采用db4小波并对信号进行二维离散小波分解。
    cA_low1(i,:) = cA;
    cD_high1(i,:) = reshape(temp,1,8);
    y1{i,1}=wrcoef2('a',cA_low1(i,:),reshape(cD_high1(i,:),4,2),wavelet);
    %      y(i,:)=idwt(cA_low(i,:),reshape(cD_high(i,:),4,2),wavelet); %一维离散小波反变换
end

cA_low2 = zeros(3,LEN_DWT);
cD_high2 = zeros(3,8);
y2 = cell(3,1);
for i = 1:N
    y2{i,1} = zeros(9,LEN);
end
temp = zeros(4,2);
for i = 1:N
    %    [cA(i,:),cD(i,:)]=dwt(signal_matrix(i,:),'db4'); %采用db4小波并对信号进行一维离散小波分解。
    [cA,temp]=wavedec2(signal_matrix2{i,:},2,wavelet); %采用db4小波并对信号进行二维离散小波分解。
    cA_low2(i,:) = cA;
    cD_high2(i,:) = reshape(temp,1,8);
    y2{i,1}=wrcoef2('a',cA_low2(i,:),reshape(cD_high2(i,:),4,2),wavelet);
    %      y(i,:)=idwt(cA_low(i,:),reshape(cD_high(i,:),4,2),wavelet); %一维离散小波反变换
end
%% 画图
figure(used_fig +1)

subplot(2,3,1);
plot(cA_low1(1,:)); %画出波形图
title('1号step1低频部分dwt-cA');

subplot(2,3,2);
plot(cA_low1(2,:)); %画出波形图
title('1号step2低频部分dwt-cA');

subplot(2,3,3);
plot(cA_low1(3,:)); %画出波形图
title('1号step3低频部分dwt-cA');

subplot(2,3,4);
plot(cA_low2(1,:)); %画出波形图
title('2号step1低频部分dwt-cA');

subplot(2,3,5);
plot(cA_low2(2,:)); %画出波形图
title('2号step2低频部分dwt-cA');

subplot(2,3,6);
plot(cA_low2(3,:)); %画出波形图
title('2号step2低频部分dwt-cA');
%%

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


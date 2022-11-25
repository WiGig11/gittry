function [cA,cD] = dwt_3_wave(signal_matrix,wavelet,used_fig)
%DWT_3_WAVE 对同一实验者的三步进行小波分析对比，% 完美适配三行矩阵和三元素元胞数组，报错需要调整画图函数，输入信号是矩阵，向量，元胞数组都可以
if iscell(signal_matrix)==1
    N = length(signal_matrix);
else
    if isvector(signal_matrix)
            N=1;
    else
        size_of_input = size(signal_matrix);
        N = size_of_input(1,1);
    end
end

    % LEN = length(signal_matrix);
% LEN_DWT = 5076;
cA = cell(N,1);
cD = cell(N,1);
y = [];

for i = 1:N
    if iscell(signal_matrix)==1
        [cA{i,:},cD{i,:}]=wavedec2(signal_matrix{i,:},2,wavelet); %采用db4小波并对信号进行一维离散小波分解。
    else
        [cA{i,:},cD{i,:}]=dwt(signal_matrix(i,:),wavelet); %采用db4小波并对信号进行一维离散小波分解。
        y(i,:)=idwt(cA{i,:},cD{i,:},wavelet); %一维离散小波反变换
    end   
end
%% 画图
% figure(used_fig +1)
% subplot(3,1,1);
% plot(cA{1,:}); %画出波形图
% title('step1低频部分dwt-cA');
% 
% subplot(3,1,2);
% plot(cA{2,:}); %画出波形图
% title('step2低频部分dwt-cA');
% 
% subplot(3,1,3);
% plot(cA{3,:}); %画出波形图
% title('step3低频部分dwt-cA');
% 
% %%
% figure(used_fig+2)
% subplot(3,1,1);
% plot(cD{1,:}); %画出波形图
% title('step1高频部分dwt-cD');
% 
% subplot(3,1,2);
% plot(cD{2,:}); %画出波形图
% title('step2高频部分dwt-cD');
% 
% subplot(3,1,3);
% plot(cD{3,:}); %画出波形图
% title('step3高频部分dwt-cD');
%%
% figure(used_fig+3)
% subplot(3,1,1);
% plot(y(1,:)); %画出波形图
% title('step1重构idwt');
% 
% subplot(3,1,2);
% plot(y(2,:)); %画出波形图
% title('step2重构idwt');
% 
% subplot(3,1,3);
% plot(y(3,:)); %画出波形图
% title('step3重构idwt');

end


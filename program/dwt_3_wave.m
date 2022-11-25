function [cA,cD] = dwt_3_wave(signal_matrix,wavelet,used_fig)
%DWT_3_WAVE ��ͬһʵ���ߵ���������С�������Աȣ�% �����������о������Ԫ��Ԫ�����飬������Ҫ������ͼ�����������ź��Ǿ���������Ԫ�����鶼����
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
        [cA{i,:},cD{i,:}]=wavedec2(signal_matrix{i,:},2,wavelet); %����db4С�������źŽ���һά��ɢС���ֽ⡣
    else
        [cA{i,:},cD{i,:}]=dwt(signal_matrix(i,:),wavelet); %����db4С�������źŽ���һά��ɢС���ֽ⡣
        y(i,:)=idwt(cA{i,:},cD{i,:},wavelet); %һά��ɢС�����任
    end   
end
%% ��ͼ
% figure(used_fig +1)
% subplot(3,1,1);
% plot(cA{1,:}); %��������ͼ
% title('step1��Ƶ����dwt-cA');
% 
% subplot(3,1,2);
% plot(cA{2,:}); %��������ͼ
% title('step2��Ƶ����dwt-cA');
% 
% subplot(3,1,3);
% plot(cA{3,:}); %��������ͼ
% title('step3��Ƶ����dwt-cA');
% 
% %%
% figure(used_fig+2)
% subplot(3,1,1);
% plot(cD{1,:}); %��������ͼ
% title('step1��Ƶ����dwt-cD');
% 
% subplot(3,1,2);
% plot(cD{2,:}); %��������ͼ
% title('step2��Ƶ����dwt-cD');
% 
% subplot(3,1,3);
% plot(cD{3,:}); %��������ͼ
% title('step3��Ƶ����dwt-cD');
%%
% figure(used_fig+3)
% subplot(3,1,1);
% plot(y(1,:)); %��������ͼ
% title('step1�ع�idwt');
% 
% subplot(3,1,2);
% plot(y(2,:)); %��������ͼ
% title('step2�ع�idwt');
% 
% subplot(3,1,3);
% plot(y(3,:)); %��������ͼ
% title('step3�ع�idwt');

end


function [maxidx,wvdfeature] = wvdfeature(vector)
%WVDFEATURE 此处显示有关此函数的摘要,产生与原函数最相关的模态函数的emd分解的wvd相关特征,只有一维没有二维
%   此处显示详细说明
imf = emd(vector);
r = [];
siimf = size(imf);
for i = 1: siimf(1,1)
    a = corrcoef(imf(i,:),vector);
    r = [r a(1,2)];
end %得到相关系数序列
[~,idx] = max(r);
maxidx = idx;
imf1 = emd(imf(idx,:));         %对最大的模态函数再次分解
[tfr1, t1, f1] = tfrwv(imf1');
[tfr, t, f] = tfrwv(vector');
imagesc(t,f,tfr);
colorbar;
axis xy;
temp = cell(1,1);
temp{1,1}=tfr;
wvdpattern = eigendivide(temp);

figure(2);
for i = 1:siimf(1,1)
    subplot(2,round(siimf(1,1)/2),i)
    [tfr, t, f] = tfrwv(imf(i,:)');
    imagesc(t,f,tfr');
    axis xy;
    xlabel('时间序列n');
    ylabel('频率');
    title(['imf个数为',num2str(i)]);
end

end


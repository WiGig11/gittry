function [maxidx,wvdfeature] = wvdfeature(vector)
%WVDFEATURE �˴���ʾ�йش˺�����ժҪ,������ԭ��������ص�ģ̬������emd�ֽ��wvd�������,ֻ��һάû�ж�ά
%   �˴���ʾ��ϸ˵��
imf = emd(vector);
r = [];
siimf = size(imf);
for i = 1: siimf(1,1)
    a = corrcoef(imf(i,:),vector);
    r = [r a(1,2)];
end %�õ����ϵ������
[~,idx] = max(r);
maxidx = idx;
imf1 = emd(imf(idx,:));         %������ģ̬�����ٴηֽ�
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
    xlabel('ʱ������n');
    ylabel('Ƶ��');
    title(['imf����Ϊ',num2str(i)]);
end

end


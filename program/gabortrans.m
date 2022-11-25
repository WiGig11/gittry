function [gaborpattern,gaborfeature,gaborfidx] = gabortrans(imageI,w,theta)
%GABORTRANS �˴���ʾ�йش˺�����ժҪ��ɶ�λ�����źŵ�gabor�任��ע��Ϊ���õı任������wΪ������thetaΪ��ת�Ƕȣ�����Ϊһ������
%��ͼ������Ҫ����ʹ�õ���
%   �˴���ʾ��ϸ˵��
gaborpattern = [];
g = gabor(w,theta);
if iscell(imageI) ==1
    N = length(imageI);
    for i = 1:length(imageI)
        outMag = imgaborfilt(imageI{i,1},g);
        siofm = size(outMag);
        gaborresult = cell(siofm(1,3),1);   %siofm�ĵ�����Ԫ���ǲ�����Ҫ��
        for i = 1:siofm(1,3)
            gaborresult{i,1} = outMag(:,:,i);
        end
        newgaborpattern = eigendivide(gaborresult);    %�Ա任���������ֵ�ֽ⡣
        gaborpattern = [gaborpattern newgaborpattern];
    end
else
    N =1;
    outMag = imgaborfilt(imageI,g);
    siofm = size(outMag);
    gaborresult = cell(siofm(1,3),1);   %siofm�ĵ�����Ԫ���ǲ�����Ҫ��
    for i = 1:siofm(1,3)
        gaborresult{i,1} = outMag(:,:,i);
    end
    gaborpattern = eigendivide(gaborresult);
end
%��ͼ������Ҫ����ʹ�õ���
% for i = 1:length(theta)
%     subplot(2,2,i)
%     mesh(outMag(:,:,i));
%     view([0 90]);
% end
% for i = 1:length(theta)
%     subplot(2,2,i)
%     mesh(reshape(gaborpattern(:,i),9,256));
% %     view([0 90]);
% end

%һ��ͼ�����4��pattern
sizeofg = size(gaborpattern);
gaborfidx = [];
gaborfeature = [];
for i = 1:1:sizeofg(1,2)
    [fe,idx]  = max(gaborpattern(:,i));
    gaborfidx = [gaborfidx idx];
    gaborfeature = [gaborfeature fe];
end
gaborfidx = reshape(gaborfidx,N,4);
gaborfeature = reshape(gaborfeature,N,4);

%�������
% 
% figure;
% subplot(2,2,1);
% for p = 1:length(g)
%     subplot(2,2,p);
%     imshow(real(g(p).SpatialKernel),[]);
%     lambda = g(p).Wavelength;
%     theta = g(p).Orientation;
%     title(sprintf('Re[h(x,y)], \\lambda = %d, \\theta = %d',lambda,theta));
% end
% end





%��ͼ������Ҫ����ʹ�õ���
% for i = 1:length(theta)
%     subplot(2,2,i)
%     mesh(outMag(:,:,i));
%     view([0 90]);
% end
% for i = 1:length(theta)
%     subplot(2,2,i)
%     mesh(reshape(gaborpattern(:,i),9,256));
% %     view([0 90]);
% end


% % gabor�˲�����������
% Sx = 2;
% Sy = 4;
% f  = 16;
% theta = 2*pi/3;
% %�˲�
% [G,gabout] = gaborfilter(I,Sx,Sy,f,theta);
% % ��ͼ
% subplot(1,2,1)
% mesh(I);
% view([0,90]);
% colorbar;
% title('����ʱ�մ�����άͼ');
% subplot(1,2,2)
% mesh(gabout);
% view([0,90]);
% title('gabor�任��άͼ');
% colorbar;



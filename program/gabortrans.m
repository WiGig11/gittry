function [gaborpattern,gaborfeature,gaborfidx] = gabortrans(imageI,w,theta)
%GABORTRANS 此处显示有关此函数的摘要完成二位单步信号的gabor变换，注释为备用的变换函数，w为波长，theta为旋转角度，可以为一个数列
%画图函数需要根据使用调整
%   此处显示详细说明
gaborpattern = [];
g = gabor(w,theta);
if iscell(imageI) ==1
    N = length(imageI);
    for i = 1:length(imageI)
        outMag = imgaborfilt(imageI{i,1},g);
        siofm = size(outMag);
        gaborresult = cell(siofm(1,3),1);   %siofm的第三个元素是层数不要改
        for i = 1:siofm(1,3)
            gaborresult{i,1} = outMag(:,:,i);
        end
        newgaborpattern = eigendivide(gaborresult);    %对变换结果做特征值分解。
        gaborpattern = [gaborpattern newgaborpattern];
    end
else
    N =1;
    outMag = imgaborfilt(imageI,g);
    siofm = size(outMag);
    gaborresult = cell(siofm(1,3),1);   %siofm的第三个元素是层数不要改
    for i = 1:siofm(1,3)
        gaborresult{i,1} = outMag(:,:,i);
    end
    gaborpattern = eigendivide(gaborresult);
end
%画图函数需要根据使用调整
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

%一张图能输出4列pattern
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

%画卷积核
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





%画图函数需要根据使用调整
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


% % gabor滤波器参数设置
% Sx = 2;
% Sy = 4;
% f  = 16;
% theta = 2*pi/3;
% %滤波
% [G,gabout] = gaborfilter(I,Sx,Sy,f,theta);
% % 画图
% subplot(1,2,1)
% mesh(I);
% view([0,90]);
% colorbar;
% title('单步时空传播三维图');
% subplot(1,2,2)
% mesh(gabout);
% view([0,90]);
% title('gabor变换三维图');
% colorbar;



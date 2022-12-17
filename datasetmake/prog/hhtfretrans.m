function [frequenvy_matrix,hhtfeature] = hhtfretrans(signal_matrix,flag)
%HHTFRETRANS %hht频谱变换，逐行做fft变换，利用内置函数做特征提取，输出matrix为对每个模态函数嘴的fft，特征为前三个模态函数的特征
%   此处显示详细说明
sizeofsignal = size(signal_matrix);
a = sizeofsignal(1,1);
fre = [];
% newsig = [];
% for i = 1:1:a
%     newsig(i,:) = signal_matrix(i,:)-mean(signal_matrix(i,:));
% end

for i = 1:1:a
    newfre = fft(signal_matrix(i,:));
    fre = [fre;newfre];
end
frequenvy_matrix = fre;

% maxvalue = max(max(abs(frequenvy_matrix(1:7,:))));
if flag == 1
    h = figure(1);
    for i = 1:1:a
        subplot(a,1,i)
        plot(abs(frequenvy_matrix(i,:)));
        maxvalue = max(abs(frequenvy_matrix(i,:)));
        axis([0,128,0,maxvalue]);
        
        if i~=a
            title(['fft-imf',num2str(i)]);
        else
            title('fft-res');
        end
        ylabel('幅度');
        
    end
    xlabel('时间n');
    suptitle('对各个模态分解的结果做fft');
    
else
end

%%
[hhtampli,hhtfre,hhttime] = hhspectrum(signal_matrix);
[im,~,~] = toimage(hhtampli,hhtfre,hhttime,length(hhttime));
% figure;
% set(gcf,'Color','w');
% % imagesc(hhttime/length(after_pca1),[0,0.5*fs],im);
% imagesc(im);
% set(gca,'YDir','normal')
% colormap('jet');colorbar;
% xlabel('时间(s)');
% ylabel('频率(Hz)');
% title('HHT谱') ;

%%
hhtfeature = [];
for k =1:3
    [~,idex3] = max(hhtampli(k,:));
    T = 1./hhtfre(k,idex3);
    [rc,~]  = rceps(hhtampli(k,:));
    cave = sum(rc(1,:))/length(rc);
    hhtfeature = [hhtfeature,T,cave];
end

end


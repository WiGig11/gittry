function [frequenvy_matrix,hhtfeature] = hhtfretrans(signal_matrix,flag)
%HHTFRETRANS %hhtƵ�ױ任��������fft�任���������ú�����������ȡ�����matrixΪ��ÿ��ģ̬�������fft������Ϊǰ����ģ̬����������
%   �˴���ʾ��ϸ˵��
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
        ylabel('����');
        
    end
    xlabel('ʱ��n');
    suptitle('�Ը���ģ̬�ֽ�Ľ����fft');
    
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
% xlabel('ʱ��(s)');
% ylabel('Ƶ��(Hz)');
% title('HHT��') ;

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


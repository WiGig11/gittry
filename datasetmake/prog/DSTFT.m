function [Spec,Freq] = DSTFT(Sig,nLevel,WinLen,SampFreq)
%DSTFT 计算离散信号的短时傅里叶变换
%Sig 待分析信号
%nLevel 频率轴长度划分（默认值512）
%WinLen 汉宁窗长度（默认值64）
%SampFreq 信号的采样频率（默认值1）
%used_fig 已使用的Figure数
%% 输入参数检查
if(nargin<1)
    error("At least one parameter required!");
end

Sig = real(Sig);
SigLen = length(Sig);

if(nargin < 4)
    SampFreq = 1;
end

if(nargin < 3)
    WinLen = 64;
end

if(nargin < 2)
    nLevel = 513;
end
%% D-STFT 参数设置与计算
nLevel=ceil(nLevel/2)*2+1;
WinLen=ceil(WinLen/2)*2+1;
WinFun=exp(-6*linspace(-1,1,WinLen).^2);
WinFun=WinFun/norm(WinFun);                % ??
Lh=(WinLen-1)/2;
Ln=(nLevel-1)/2;

Spec=zeros(nLevel,SigLen);
% wait=waitbar(0.05,'Under calculation,please wait...');
for iLoop=1:SigLen
%     waitbar(iLoop/SigLen,wait);
    iLeft=min([iLoop-1,Lh,Ln]);
    iRight=min([SigLen-iLoop,Lh,Ln]);
    iIndex=-iLeft:iRight;
    iIndex1=iIndex+iLoop;
    iIndex2=iIndex+Lh+1;
    Index=iIndex+Ln+1;
    Spec(Index,iLoop)=Sig(iIndex1).*conj(WinFun(iIndex2));
end

% close(wait);
Spec=fft(Spec);
Spec=abs(Spec(1:(end-1)/2,:)).^2;
Freq=(1:(nLevel-1)/2)*SampFreq/length(Spec);
%% 绘图
% t=(1:SigLen)/SampFreq;
% figure(used_fig + 1) %
% set(gcf,'Position',[20 100 500 430]);
% set(gcf,'Color','w');
% % axes('Position',[ ]);
% mesh(t,Freq,Spec);
% axis([min(t) max(t) 0 max(Freq)]);
% colorbar
% xlabel('t/s');
% ylabel('f/Hz');
% title('|STFT|^2时频谱图');
% % axes('Position',[ ]);
% 
% figure(used_fig + 2)
% subplot(2,1,1)
% plot(t,Sig);
% axis tight
% xlabel('t');
% ylabel('intensity');
% title('时域波形');
% % axes('Position',[ ]);
% 
% PSP=abs(fft(Sig));
% Freq=linspace(0,1,SigLen)*SampFreq;
% subplot(2,1,2)
% % plot(PSP(1:end/2),Freq(1:end/2));
% plot(Freq(1:end/2),PSP(1:end/2));
% xlabel('f/Hz');
% ylabel('Amplitute');
% title('频谱');

end


clc;
% clear all;
close all;
%% 数据读入
features = [];
fidin=fopen('test.csv');
c  = textscan(fidin,'%s');
f = c{1,1};
fclose(fidin);
fnames = {'ID','freq','ave_str','var_str','step_energy','var_mean_ratio','peakindex','mean_xocrr','timew','cw','bw','lr_ratio','T1','Cave1', 'T2','Cave2','T3','Cave3','timepdist2D','mean_bw','mean_peak_low','type'};
x  = find(f{1,1}==',');
typeof = zeros(length(f)-1,1);
re = zeros((length(f)-1),length(x)-1);
%% 数据转化为可处理的格式
for i = 2:length(f)
    temp = split(f{i,1},',');
    for j= 1:length(x)+1
        re(i-1,j) = str2num(temp{j,1});
    end
    %     a = temp{j+1,1};
    %     typeof(i,1) = str2num(a);
end
typeof = [0;1;1;1;0;0];
% re = re(2:length(f),2:length(x)+1);
%% 计算权值
[rank, weights] = relieff(re,typeof,2);
for i  = 1:length(f)-1
    for j = 1:length(rank)
        re(i,j) = re(i,j)*weights(1,j);
    end
end
%% 拼接ID和type
ID = 1:(length(f)-1);
ID = ID';
inf = [ID,re,typeof];

%% 去除负权值
for j = 1:length(inf(1,:))
    if length(find(inf(:,j)<0))==length(ID);
        inf(:,j)=0;
    else
    end
end
a = find(inf(2,:)==0);
b = 1:length(inf(1,:));
c = setdiff(b,a);
infnew= [];
for i = 1:length(c)
    infnew = [infnew inf(:,c(1,i))];
end
for i = 1:length(a)
    fnames{1,a(1,i)}=[];
end
fnames

%% %保存表格
%% 使用时请在这里设置断点，根据fnames手动调整圆点后的数据名称
feature = table;
feature.ID = inf(:,1);
feature.freq = inf(:,2);
feature.ave_str = inf(:,3);
feature.var_str = inf(:,4);
feature.step_energy  =inf(:,5);
% feature.var_mean_ratio = inf(:,6);
feature.peakindex = inf(:,7);
feature.mean_xocrr = inf(:,8);
% feature.timew = inf(:,9);
% feature.cw = inf(:,10);
% feature.bw = inf(:,11);
% feature.lr_ratio = inf(:,12);
feature.T1 = inf(:,13);
feature.Cave1 = inf(:,14);
% feature.T2 = inf(:,15);
feature.Cave2 = inf(:,16);
% feature.T3 = inf(:,17);
feature.Cave3 = inf(:,18);
% feature.timepdist2D = inf(:,19);
% feature.mean_bw = inf(:,20);
feature.mean_peak_low = inf(:,21);
feature.type = inf(:,22);
%%
% feature = removevars(feature,["ave_str","var_str","cw","bw","T2","T3","Cave3"]);
writetable(feature,'G:\硕士期间\光纤传感\数据\pythonProject1\test2.csv');
%% kmeans
tryinf1 = infnew(1:6,2:length(c));%去除负权值的
tryinf2 = re;

temp = infnew(:,length(c));
% 
% temp1 = find(temp==0);
% temp(temp1)=2

temp2 = find(temp==1);
temp(temp2)=2;
temp3 = find(temp==0);
temp(temp3)=1


re1 = kmeans(tryinf1,2)
re2 = kmeans(tryinf2,2)
%正确率
erro1 = length(find((re1-temp)==0))*100/length(re2)
erro2 = length(find((re2-temp)==0))*100/length(re2)

clc;
clear all;
close all;
%% 数据读入
features = [];
re = xlsread('G:\硕士期间\光纤传感\数据\reliefF算法\test1.xlsx','sheet1');
fnames = {'freq','ave_str','var_str','step_energy','var_mean_ratio','peakindex','mean_xocrr','timew','cw','bw','lr_ratio','T1','Cave1', 'T2','Cave2','T3','Cave3','timepdist2D','mean_bw','mean_peak_low'};
fnames1 = {'ID','freq','ave_str','var_str','step_energy','var_mean_ratio','peakindex','mean_xocrr','timew','cw','bw','lr_ratio','T1','Cave1', 'T2','Cave2','T3','Cave3','timepdist2D','mean_bw','mean_peak_low','type'};
typeof = [0;0;1;1;1;0];
re = re(:,2:21);
%% 计算权值
a = find(sum(re)==0);
b = 1:length(re(1,:));
c = setdiff(b,a);
renew= [];
for i = 1:length(c)
    renew = [renew re(:,c(1,i))];
end

temp2 = [];
for i = 1:length(renew(1,:))
    temp = [fnames{1,c(1,i)};num2cell(renew(:,i))];
    temp2 = [temp2,temp];
end
re=[];
[rank, weights] = relieff(renew,typeof,2);
for i  = 1:length(typeof)
    for j = 1:length(rank)
        re(i,j) = renew(i,j)*weights(1,j);
    end
end

%% 去除负权值
for j = 1:length(re(1,:))
    if length(find(re(:,j)<0))==length(typeof)
        re(:,j)=0;
    else
    end
end

%% 拼接ID和type
size1 = size(renew);
ID = (1:size1(1,1))';
a = find(sum(re)==0);
b = 1:length(re(1,:));
c = setdiff(b,a);
infnew= [];
for i = 1:length(c)
    infnew = [infnew re(:,c(1,i))];
end


inf = [ID,infnew,typeof];


te = [];
for i = 1:length(c)
    te = [te,temp2(:,c(1,i))];
end


% for i = 1:length(a)
%     fnames{1,a(1,i)}=[];
% end

te1 = [fnames1{1,1};num2cell(ID)];
te2 = [fnames1{1,length(fnames1)};num2cell(typeof)];
te = [te1,te,te2]

%%
% te = [];
%
% for i = 1:length(infnew(1,:))
%     temp = [fnames{1,c(1,i)};num2cell(infnew(:,i))];
%     te = [te,temp];
% end
te = [te(:,1),te(:,2),te(:,3),te(:,4),te(:,length(c)+2)]
fid = fopen('G:\硕士期间\光纤传感\数据\pythonProject1\try1.csv', 'w+');
for j =1 :length(te1)
    if j ==1
        for k = 1:3+2
            fprintf(fid, '%s,', te{j,k});
        end
        fprintf(fid,'\n');
    else
        for k = 1:3+2
            fprintf(fid, '%d,', te{j,k});
        end
        fprintf(fid,'\n');
    end
end
fclose(fid);

%% kmeans
tryinf1 = infnew(1:length(typeof),2:length(c)-1);%去除负权值的
tryinf2 = re;

temp = inf(:,length(c)+2);
%
temp1 = find(temp==0);
temp(temp1)=2;

% temp2 = find(temp==1);
% temp(temp2)=2;
% temp3 = find(temp==0);
% temp(temp3)=1


re1 = kmeans(tryinf1,2)
re2 = kmeans(tryinf2,2)
%正确率
erro1 = length(find((re1-temp)==0))*100/length(re2)
erro2 = length(find((re2-temp)==0))*100/length(re2)


% %% %保存表格
% %% 使用时请在这里设置断点，根据fnames手动调整圆点后的数据名称
% feature = table;
% feature.ID = inf(:,1);
% feature.freq = inf(:,2);
% feature.ave_str = inf(:,3);
% feature.var_str = inf(:,4);
% feature.step_energy  =inf(:,5);
% % feature.var_mean_ratio = inf(:,6);
% feature.peakindex = inf(:,7);
% feature.mean_xocrr = inf(:,8);
% % feature.timew = inf(:,9);
% % feature.cw = inf(:,10);
% % feature.bw = inf(:,11);
% % feature.lr_ratio = inf(:,12);
% feature.T1 = inf(:,13);
% feature.Cave1 = inf(:,14);
% % feature.T2 = inf(:,15);
% feature.Cave2 = inf(:,16);
% % feature.T3 = inf(:,17);
% feature.Cave3 = inf(:,18);
% % feature.timepdist2D = inf(:,19);
% % feature.mean_bw = inf(:,20);
% feature.mean_peak_low = inf(:,21);
% feature.type = inf(:,22);
% %%
% % feature = removevars(feature,["ave_str","var_str","cw","bw","T2","T3","Cave3"]);
% writetable(feature,'G:\硕士期间\光纤传感\数据\pythonProject1\test2.csv');


clc;
clear all;
close all;
%% 数据读入
features = [];
re = xlsread('G:\硕士期间\光纤传感\数据\gittry\testmat\test1.xlsx','sheet1');
fnames = {'freq','var_freq','ave_str','var_str','step_energy','var_mean_ratio','peakindex','mean_xocrr','timew','cw','bw','lr_ratio','T1','Cave1', 'T2','Cave2','T3','Cave3','timepdist2D','mean_bw','mean_peak_low'};
fnames1 = {'ID','freq','ave_str','var_str','step_energy','var_mean_ratio','peakindex','mean_xocrr','timew','cw','bw','lr_ratio','T1','Cave1', 'T2','Cave2','T3','Cave3','timepdist2D','mean_bw','mean_peak_low','type'};
%% 修改此处
typeof = [0;0;1;1;0;0;0;0;1;1;1;1;1;1;0;0;0;0;0];
% typeof = [0;0;1;1;0;0;0;0];
%%
re =re';
a = find(sum(re)==0);
b = 1:length(re(1,:));
c = setdiff(b,a);
renew= [];
for i = 1:length(c)
    renew = [renew re(:,c(1,i))];
end
fnames2 = [fnames re(:,c(1,i))];
for i = 1:length(c)
    fnames2{1,c(1,i)} = [];
end
fnames2
temp2 = [];
for i = 1:length(renew(1,:))
    temp = [fnames{1,c(1,i)};num2cell(renew(:,i))];
    temp2 = [temp2,temp];
end
temp2
re=[];
%% 修改此处
% tarnum = [1,2,3,5,11,21];
% %%
% renew = [renew(:,tarnum)];
[rank, weights] = relieff(renew,typeof,2);
count = 0;
while(~isempty(find(weights<0, 1)))
    [rank, weights] = relieff(renew,typeof,2)
    re = zeros(length(typeof),length(rank));
    for i  = 1:length(typeof)
        for j = 1:length(rank)
            re(i,j) = renew(i,j)*weights(1,j);
        end
    end
    % 去除负权值
    for j = 1:length(rank)
        if weights(1,j)<0
            re(:,j)=0;
        else
        end
    end
    % 拼接ID和type
    size1 = size(renew);
    ID = (1:size1(1,1))';
    a = find(sum(re)==0);
    b = 1:length(re(1,:));
    c = setdiff(b,a);
    infnew= [];
    
    for i = 1:length(c)
        infnew = [infnew re(:,c(1,i))];
        
        
        
    end
    
    temp2 = [];
    for i = 1:length(infnew(1,:))
        temp = [fnames{1,c(1,i)};num2cell(infnew(:,i))];
        temp2 = [temp2,temp];
    end
    inf = [ID,infnew,typeof];
    renew = infnew;
    % for i = 1:length(a)
    %     fnames{1,a(1,i)}=[];
    % end
    te1 = [fnames1{1,1};num2cell(ID)];
    te2 = [fnames1{1,length(fnames1)};num2cell(typeof)];
    te = [te1,temp2,te2];
    pause(1);
    count = count+1;
end

%%
% te = [];
%
% for i = 1:length(infnew(1,:))
%     temp = [fnames{1,c(1,i)};num2cell(infnew(:,i))];
%     te = [te,temp];
% end
% te = [te(:,1),te(:,2),te(:,3),te(:,4),te(:,length(c)+2)]
fid = fopen('G:\硕士期间\光纤传感\数据\gittry\pythonProject1\allfeatures1.csv', 'w+');
for j =1 :length(te1)
    if j ==1
        for k = 1:length(c)+2
            fprintf(fid, '%s,', te{j,k});
        end
        fprintf(fid,'\n');
    else
        for k = 1:length(c)+2
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


re = kmeans(tryinf1,2)
re2 = kmeans(tryinf2,2)
%正确率
erro1 = length(find((re-temp)==0))*100/length(re2)
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


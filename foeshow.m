clc;
clear all;
close all;
%%
features = [];
fidin=fopen('test.csv');
c  = textscan(fidin,'%s');
f = c{1,1};
fclose(fidin);
fnames = {'ID','freq','ave_str','var_str','var_mean_ratio','peakindex','mean_xocrr','timew','cw','bw','lr_ratio','T1','Cave1', 'T2','Cave2','T3','Cave3','timepdist2D','mean_bw','mean_peak_low','type'};
x  = find(f{1,1}==',');
typeof = zeros(length(f)-1,1);
re = zeros((length(f)-1),length(x)-1);
%%
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
ID = 1:(length(f)-1);
ID = ID';
inf = [ID,re,typeof];
%%
feature = table;
feature.ID = inf(:,1);
feature.freq = inf(:,2);
feature.ave_str = inf(:,3);
feature.var_str = inf(:,4);
feature.step_energy  =inf(:,5);
feature.var_step_energy=inf(:,6);
feature.lr_ene_ratio=inf(:,7);
feature.var_mean_ratio = inf(:,8);
feature.peakindex = inf(:,9);
feature.mean_xocrr = inf(:,10);
feature.timew = inf(:,11);
feature.cw = inf(:,12);
feature.bw = inf(:,13);
feature.lr_ratio = inf(:,14);
feature.T1 = inf(:,15);
feature.Cave1 = inf(:,16);
feature.T2 = inf(:,17);
feature.Cave2 = inf(:,18);
feature.T3 = inf(:,19);
feature.Cave3 = inf(:,20);
feature.timepdist2D = inf(:,21);
feature.mean_bw = inf(:,22);
feature.mean_peak_low = inf(:,23);
feature.type = inf(:,24);
%%
[rank, weights] = relieff(re,typeof,1);
for i  = 1:length(f)-1
    for j = 1:length(rank)
        re(i,j) = re(i,j)*weights(1,j);
    end
end
%%
writetable(feature,'G:\硕士期间\光纤传感\数据\reliefF算法\show.csv');

% feature = removevars(feature,["ave_str","var_str","cw","bw","T2","T3","Cave3"]);


function imf = aver(vector)
%HHT %hht:函数上下移动复合hht要求后做模态分解
%   此处显示详细说明
%%
vector = vector-mean(vector);
imf = emd(vector);

end


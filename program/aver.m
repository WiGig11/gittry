function imf = aver(vector)
%HHT %hht:���������ƶ�����hhtҪ�����ģ̬�ֽ�
%   �˴���ʾ��ϸ˵��
%%
vector = vector-mean(vector);
imf = emd(vector);

end


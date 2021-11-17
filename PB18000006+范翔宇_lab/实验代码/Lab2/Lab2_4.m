%clear
clc, clear, close all

rgb_old = imread('G:/360MoveData/Users/Lenovo/Desktop/实验图像/pout.bmp');
w = size(rgb_old, 1);
h = size(rgb_old, 2);
n = zeros(256,1);
%--------------求概率------------
[n, bin] = imhist(rgb_old);
%求和
sum = sum(n);
%概率
p = n / sum;
t = p;
rgb_new = rgb_old;
finalp = zeros(256,1);
%-------------原始累加直方图--------------
for i = 2 : 256
    t(i) = t(i - 1) + t(i);
end
%-------------取整扩展----------------
intk = uint8(255 * t + 0.5);
%-------------计算均衡化直方图----------
%按照intk关系映射
for i = 1 : 256
    finalp(intk(i)) = finalp(intk(i)) + p(i); 
end
for i = 1 : w
    for j = 1 : h
        rgb_new(i,j) = intk(rgb_old(i,j));
    end
end

%----------------------规定化----------------
x = 0:255;
%高斯函数
a = exp(-((x-127.5).^2)/(2*40^2));
sum = 0;
for i = 1 : 256
    sum = sum + a(i);
end
a = a / sum;
%高斯函数的概率
s = a;
%--------------------规定累积直方图------------
for i = 2 : 256
    s(i) = s(i - 1) + s(i);
end
SML = zeros([256,1],'uint8');
%---------------------SML映射-----------------
for i = 1 : 256
    min = realmax;
    for j = 1 : 256
        %寻找最小，最贴近的s(j)
        if(abs(t(i) - s(j)) < min)
            min = abs(t(i) - s(j));
            SML(i) = j - 1;
        end
    end
end
rgb_normalize = rgb_old;
%按照SML映射
for i = 1 : w
    for j = 1 : h
        rgb_normalize(i,j) = SML(rgb_old(i,j) + 1);
    end
end
%输出
f = figure();
subplot(3,2,3)
histogram(rgb_new);
title('均衡化直方图');
hold on
subplot(3,2,4);
imshow(rgb_new)
title('均衡化图像')
hold on
subplot(3,2,1)
histogram(rgb_old);
title('原直方图');
hold on
subplot(3,2,2);
imshow(rgb_old)
title('原图像')
hold on
subplot(3,2,5)
histogram(rgb_normalize);
title('规定化直方图');
hold on
subplot(3,2,6)
imshow(rgb_normalize);
title('规定化图像');
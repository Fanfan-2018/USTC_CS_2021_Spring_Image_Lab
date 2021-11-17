%clear
clc, clear, close all

x1 = input('please input x1:');
y1 = input('please input y1:');
x2 = input('please input x2:');
y2 = input('please input y2:');
rgbold = imread('G:/360MoveData/Users/Lenovo/Desktop/实验图像/lena.bmp');
%默认x1 < x2
k1 = y1 / x1;
k2 = (y1 - y2) / (x1 - x2);
k3 = (255 - y2) / (255 - x2);
%求得图像长宽
w = size(rgbold, 1);
h = size(rgbold, 2);

rgbnew = rgbold;
%遍历
for i = 1:w
    for j = 1:h
        %判断处于哪个区间，不同区间不同处理
        x = rgbold(i, j);
        if x < x1
            rgbnew(i, j) = k1 * x1;
        elseif x < x2
            rgbnew(i, j) = k2 * (x - x1) + y1;
        else
            rgbnew(i, j) = k3 * (x - x2) + y2;
        end
    end
end
%展示图像
f = figure();
subplot(1, 2, 1);
imshow(rgbold);
title('origin');
subplot(1, 2, 2);
imshow(rgbnew);
title('gray expanding');
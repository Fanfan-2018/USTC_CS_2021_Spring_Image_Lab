%clear
clc, clear, close all

%输入缩放规格
x = input('please input x:');
y = input('please input y:');
rgbold = imread('G:\\360MoveData\\Users\\Lenovo\\Desktop\\实验图像\\lena.bmp');
[h, w] = size(rgbold);

%调用库函数
%最近邻插值
rgb_nearest = imresize(rgbold, [x * h, y * w], 'nearest');
%双线性插值
rgb_bilinear = imresize(rgbold, [x * h, y * w], 'bilinear');

f = figure();
subplot(1, 3, 1);
imshow(rgbold);
title('origin');
subplot(1, 3, 2);
imshow(rgb_nearest);
title('nearest');
subplot(1, 3, 3);
imshow(rgb_bilinear);
title('bilinear');
%clear
clc,clear,close all

x = input('please input x:');
y = input('please input y:');
%读取原图像
rgbold = imread('G:\\360MoveData\\Users\\Lenovo\\Desktop\\实验图像\\lena.bmp');
f = figure();
%平移调用库函数
se = translate(strel(1), [y,x]);
rgbnew = imdilate(rgbold, se);
subplot(1, 2, 1);
imshow(rgbold);
title('origin');
subplot(1, 2, 2);
imshow(rgbnew);
title('translation');
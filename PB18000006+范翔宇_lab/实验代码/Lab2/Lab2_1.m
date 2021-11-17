%clear
clc, clear, close all

%斜率
k = input('please input k:');
%截距
b = input('please input b:');
rgbold = imread('G:/360MoveData/Users/Lenovo/Desktop/实验图像/lena.bmp');
%进行线性变换
rgbnew = rgbold * k + b;

f = figure();
subplot(1, 2, 1);
imshow(rgbold);
title('origin');
subplot(1, 2, 2);
imshow(rgbnew);
title('linear trans');
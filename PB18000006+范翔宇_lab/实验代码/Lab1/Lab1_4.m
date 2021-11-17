%clear
clc, clear, close all

%读取图像
%origin
rgb1 = imread('G:/360MoveData/Users/Lenovo/Desktop/实验图像/alphabet1.jpg');
%失真图象
rgb2 = imread('G:/360MoveData/Users/Lenovo/Desktop/实验图像/alphabet2.jpg');
%选择控制点对
[mp, fp] = cpselect(rgb2, rgb1, 'Wait', true);
%推断几何变换
t = fitgeotrans(mp, fp, 'projective');
%变换未校正的图像
Rfixed = imref2d(size(rgb1));
rgb3 = imwarp(rgb2, t, 'OutputView', Rfixed);
imshow(rgb3);
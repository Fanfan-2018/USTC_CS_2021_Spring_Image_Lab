%clear
clc, clear, close all
%输入下界上界
low = input('please input low:');
high = input('please input high:');
rgbold = imread('G:/360MoveData/Users/Lenovo/Desktop/实验图像/lena.bmp');
%长宽
w = size(rgbold, 1);
h = size(rgbold, 2);
%统计矩阵
counter = zeros(1, high - low + 1);
%遍历
for i = 1 : w
    for j = 1 : h
        %对应像素处于[low,high]之间，即统计
        if(rgbold(i, j) >= low && rgbold(i, j) <= high)
            counter(rgbold(i, j) - low + 1) = counter(rgbold(i, j) - low + 1) + 1;
        end
    end
end
%展示直方图
x = low : 1 : high;
bar(x, counter)
hold on
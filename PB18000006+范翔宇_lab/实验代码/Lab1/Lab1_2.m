%cleaer
clc, clear, close all

theat = input('please input theat:');
rgbold = imread('G:\\360MoveData\\Users\\Lenovo\\Desktop\\实验图像\\lena.bmp');
f = figure;
%调用库函数
%最近邻插值 调整大小
rgb_nearest_crop = imrotate(rgbold, theat, 'nearest', 'crop');
%最近邻插值 不调整大小
rgb_nearest_loose = imrotate(rgbold, theat, 'nearest', 'loose');
%双线性插值 调整大小
rgb_bilinear_crop = imrotate(rgbold, theat, 'bilinear', 'crop');
%双线性插值 不调整大小
rgb_bilinear_loose = imrotate(rgbold, theat, 'bilinear', 'loose');
%展示图像
subplot(2, 3, 1);
imshow(rgbold);
title('origin');
subplot(2, 3, 2);
imshow(rgb_nearest_crop);
title('nearest & crop');
subplot(2, 3, 3);
imshow(rgb_nearest_loose);
title('nearest & loose');
subplot(2, 3, 4);
imshow(rgb_bilinear_crop);
title('bilinear & crop');
subplot(2, 3, 5);
imshow(rgb_bilinear_loose);
title('bilinear & loose');

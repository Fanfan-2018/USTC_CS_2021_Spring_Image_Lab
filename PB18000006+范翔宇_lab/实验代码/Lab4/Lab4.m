%clear
clc, clear, close all
figure(1);
img1 = imread('G:/360MoveData/Users/Lenovo/Desktop/实验图像/rect1.bmp');
img2 = imread('G:/360MoveData/Users/Lenovo/Desktop/实验图像/rect2.bmp');
subplot(3,4,1)
imshow(img1);
title('rect1');
subplot(3,4,2)
imshow(img2);
title('rect2');
%-------------------step 1-----------------
%傅里叶变换
F1 = fft2(img1);
F2 = fft2(img2);
%低频移到中心
shiftF1 = fftshift(F1);
%对数处理，清晰显示
LF1 = log(1 + abs(shiftF1));
shiftF2 = fftshift(F2);
LF2 = log(1 + abs(shiftF2));
subplot(3,4,3)
imshow(real(shiftF1));
title('rect1 FFT 频域');
subplot(3,4,4)
imshow(real(shiftF2));
title('rect2 FFT 频域');
%获取实部
R1 = real(LF1);
R2 = real(LF2);
%获取虚部
I1 = imag(LF1);
I2 = imag(LF2);
%计算幅度
A1 = sqrt(R1.^2 + I1.^2);
A2 = sqrt(R2.^2 + I2.^2);
A1 = (A1 - min(min(A1))) / (max(max(A1)) - min(min(A1)))*255;%归一化
A2 = (A2 - min(min(A2))) / (max(max(A2)) - min(min(A2)))*255;%归一化
subplot(3,4,5)
imshow(uint8(A1));
title('rect1 FFT 频谱');
subplot(3,4,6)
imshow(uint8(A2));
title('rect2 FFT 频谱');

%-------------------step 2 & 3-----------------
%计算幅度
R1 = real(F1);
R2 = real(F2);
I1 = imag(F1);
I2 = imag(F2);
A1 = sqrt(R1.^2 + I1.^2);
A2 = sqrt(R2.^2 + I2.^2);
AF1 = ifft2(A1);
%对数处理
AF1 = log(1 + abs(AF1));
AF1 = (AF1 - min(min(AF1))) / (max(max(AF1)) - min(min(AF1)))*255;%归一化
%相位直接调用angle
%ifft2傅里叶反变换
PF1 = ifft2(angle(F1));
PF1 = (PF1 - min(min(PF1))) / (max(max(PF1)) - min(min(PF1)))*255;%归一化
AF2 = ifft2(A2);
AF2 = log(1 + abs(AF2));
AF2 = (AF2 - min(min(AF2))) / (max(max(AF2)) - min(min(AF2)))*255;%归一化
PF2 = ifft2(angle(F2));
PF2 = (PF2 - min(min(PF2))) / (max(max(PF2)) - min(min(PF2)))*255;%归一化
subplot(3,4,7)
imshow(AF1,[]);
title('rect1 幅度IFFT');
subplot(3,4,8)
imshow(AF2,[]);
title('rect2 幅度IFFT');
subplot(3,4,9)
imshow(uint8(PF1));
title('rect1 相位IFFT');
subplot(3,4,10)
imshow(uint8(PF2));
title('rect2 相位IFFT');

%-------------------step 4-----------------
%conj求共轭
CF1 = conj(F1);
CF2 = conj(F2);
%求反变换
OF1 = ifft2(CF1);
OF2 = ifft2(CF2);
subplot(3,4,11)
imshow(OF1,[]);
title('rect1 共轭IFFT');
subplot(3,4,12)
imshow(OF2,[]);
title('rect2 共轭IFFT');

%-------------------step 5-----------------
figure(2);
img3 = imread('G:/360MoveData/Users/Lenovo/Desktop/实验图像/pout.bmp');
img4 = imread('G:/360MoveData/Users/Lenovo/Desktop/实验图像/Girl.bmp');
subplot(2,4,1);
imshow(img3);
title('pout');
subplot(2,4,2);
imshow(img4);
title('Girl');
D0 = 10;
n = 1;
%傅里叶变换并将低频移到中心
shiftF3 = fftshift(fft2(img3));
[m1,n1] = size(shiftF3);
shiftF4 = fftshift(fft2(img4));
[m2,n2] = size(shiftF4);
%确定中心
M1 = round(m1/2);
N1 = round(n1/2);
M2 = round(m2/2);
N2 = round(n2/2);
for i = 1 : m1
    for j = 1 : n1
        %计算距离
        distance = sqrt((i - M1) ^ 2 + (j - N1) ^ 2);
        %定义h
        if distance <= D0
            h = 1;
        else
            h = 0;
        end
        %相乘处理
        shiftF3(i,j) = shiftF3(i,j) * h;
    end
end
for i = 1 : m2
    for j = 1 : n2
        %计算距离
        distance = sqrt((i - M2) ^ 2 + (j - N2) ^ 2);
        %定义h
        if distance <= D0
            h = 1;
        else
            h = 0;
        end
        %相乘处理
        shiftF4(i,j) = shiftF4(i,j) * h;
    end
end
%反变换
shiftF3 = uint8(real(ifft2(ifftshift(shiftF3))));
shiftF4 = uint8(real(ifft2(ifftshift(shiftF4))));
subplot(2,4,3);
imshow(shiftF3);
title('理想低通滤波器pout')
subplot(2,4,4);
imshow(shiftF4);
title('理想低通滤波器Girl')

%其他地方同上，就不加注释了
shiftF3 = fftshift(fft2(img3));
[m1,n1] = size(shiftF3);
shiftF4 = fftshift(fft2(img4));
[m2,n2] = size(shiftF4);
M1 = round(m1/2);
N1 = round(n1/2);
M2 = round(m2/2);
N2 = round(n2/2);
for i = 1 : m1
    for j = 1 : n1
        distance = sqrt((i - M1) ^ 2 + (j - N1) ^ 2);
        %更改h对应巴特沃斯低通滤波
        h = 1 / (1 + (distance / D0) ^ (2 * n));
        shiftF3(i,j) = shiftF3(i,j) * h;
    end
end
for i = 1 : m2
    for j = 1 : n2
        distance = sqrt((i - M2) ^ 2 + (j - N2) ^ 2);
        %更改h对应巴特沃斯低通滤波
        h = 1 / (1 + (distance / D0) ^ (2 * n));
        shiftF4(i,j) = shiftF4(i,j) * h;
    end
end
%傅里叶反变换
shiftF3 = uint8(real(ifft2(ifftshift(shiftF3))));
shiftF4 = uint8(real(ifft2(ifftshift(shiftF4))));
subplot(2,4,5);
imshow(shiftF3);
title('巴特沃斯低通滤波器pout')
subplot(2,4,6);
imshow(shiftF4);
title('巴特沃斯低通滤波器Girl')
%傅里叶变换，并确认中心
shiftF3 = fftshift(fft2(img3));
[m1,n1] = size(shiftF3);
shiftF4 = fftshift(fft2(img4));
[m2,n2] = size(shiftF4);
M1 = round(m1/2);
N1 = round(n1/2);
M2 = round(m2/2);
N2 = round(n2/2);
for i = 1 : m1
    for j = 1 : n1
        distance = sqrt((i - M1) ^ 2 + (j - N1) ^ 2);
        %更改h对应高斯低通滤波
        h = exp(-(distance ^ 2)/(2 * D0 ^ 2));
        shiftF3(i,j) = shiftF3(i,j) * h;
    end
end
for i = 1 : m2
    for j = 1 : n2
        distance = sqrt((i - M2) ^ 2 + (j - N2) ^ 2);
        %更改h对应高斯低通滤波
        h = exp(-(distance ^ 2)/(2 * D0 ^ 2));
        shiftF4(i,j) = shiftF4(i,j) * h;
    end
end
%傅里叶反变换
shiftF3 = uint8(real(ifft2(ifftshift(shiftF3))));
shiftF4 = uint8(real(ifft2(ifftshift(shiftF4))));
subplot(2,4,7);
imshow(shiftF3);
title('高斯低通滤波器pout')
subplot(2,4,8);
imshow(shiftF4);
title('高斯低通滤波器Girl')

%-------------------step 6-----------------
figure(3)
%添加噪声
salt = imnoise(img4,'salt & pepper',0.03);
gauss = imnoise(img4,'gauss',0.03);
subplot(2,4,1);
imshow(salt);
title('salt Girl')
subplot(2,4,2);
imshow(gauss);
title('gauss Girl')
%傅里叶变换
shiftF3 = fftshift(fft2(salt));
[m1,n1] = size(shiftF3);
shiftF4 = fftshift(fft2(gauss));
[m2,n2] = size(shiftF4);
M1 = round(m1/2);
N1 = round(n1/2);
M2 = round(m2/2);
N2 = round(n2/2);
D0 = 30;
n = 2;
for i = 1 : m1
    for j = 1 : n1
        %更改h条件
        distance = sqrt((i - M1) ^ 2 + (j - N1) ^ 2);
        if distance <= D0
            h = 1;
        else
            h = 0;
        end
        shiftF3(i,j) = shiftF3(i,j) * h;
    end
end
for i = 1 : m2
    for j = 1 : n2
        distance = sqrt((i - M2) ^ 2 + (j - N2) ^ 2);
        if distance <= D0
            h = 1;
        else
            h = 0;
        end
        shiftF4(i,j) = shiftF4(i,j) * h;
    end
end
%傅里叶反变换
shiftF3 = uint8(real(ifft2(ifftshift(shiftF3))));
shiftF4 = uint8(real(ifft2(ifftshift(shiftF4))));
subplot(2,4,3);
imshow(shiftF3);
title('理想低通滤波器salt')
subplot(2,4,4);
imshow(shiftF4);
title('理想低通滤波器gauss')

shiftF3 = fftshift(fft2(salt));
[m1,n1] = size(shiftF3);
shiftF4 = fftshift(fft2(img4));
[m2,n2] = size(shiftF4);
M1 = round(m1/2);
N1 = round(n1/2);
M2 = round(m2/2);
N2 = round(n2/2);
for i = 1 : m1
    for j = 1 : n1
        %更改h条件
        distance = sqrt((i - M1) ^ 2 + (j - N1) ^ 2);
        h = 1 / (1 + (distance / D0) ^ (2 * n));
        shiftF3(i,j) = shiftF3(i,j) * h;
    end
end
for i = 1 : m2
    for j = 1 : n2
        distance = sqrt((i - M2) ^ 2 + (j - N2) ^ 2);
        h = 1 / (1 + (distance / D0) ^ (2 * n));
        shiftF4(i,j) = shiftF4(i,j) * h;
    end
end
%傅里叶反变换
shiftF3 = uint8(real(ifft2(ifftshift(shiftF3))));
shiftF4 = uint8(real(ifft2(ifftshift(shiftF4))));
subplot(2,4,5);
imshow(shiftF3);
title('巴特沃斯salt')
subplot(2,4,6);
imshow(shiftF4);
title('巴特沃斯gauss')

shiftF3 = fftshift(fft2(salt));
[m1,n1] = size(shiftF3);
shiftF4 = fftshift(fft2(img4));
[m2,n2] = size(shiftF4);
M1 = round(m1/2);
N1 = round(n1/2);
M2 = round(m2/2);
N2 = round(n2/2);
for i = 1 : m1
    for j = 1 : n1
        distance = sqrt((i - M1) ^ 2 + (j - N1) ^ 2);
        h = exp(-(distance ^ 2)/(2 * D0 ^ 2));
        shiftF3(i,j) = shiftF3(i,j) * h;
    end
end
for i = 1 : m2
    for j = 1 : n2
        distance = sqrt((i - M2) ^ 2 + (j - N2) ^ 2);
        h = exp(-(distance ^ 2)/(2 * D0 ^ 2));
        shiftF4(i,j) = shiftF4(i,j) * h;
    end
end
shiftF3 = uint8(real(ifft2(ifftshift(shiftF3))));
shiftF4 = uint8(real(ifft2(ifftshift(shiftF4))));
subplot(2,4,7);
imshow(shiftF3);
title('高斯低通滤波器salt')
subplot(2,4,8);
imshow(shiftF4);
title('高斯低通滤波器gauss')

%-------------------step 7------------------
figure(4);
subplot(2,4,1);
imshow(img3);
title('pout');
subplot(2,4,2);
imshow(img4);
title('Girl');
D0 = 5;
n = 1;
shiftF3 = fftshift(fft2(img3));
[m1,n1] = size(shiftF3);
shiftF4 = fftshift(fft2(img4));
[m2,n2] = size(shiftF4);
M1 = round(m1/2);
N1 = round(n1/2);
M2 = round(m2/2);
N2 = round(n2/2);
for i = 1 : m1
    for j = 1 : n1
        distance = sqrt((i - M1) ^ 2 + (j - N1) ^ 2);
        %将h与低通反过来
        if distance <= D0
            h = 0;
        else
            h = 1;
        end
        shiftF3(i,j) = shiftF3(i,j) * h;
    end
end
for i = 1 : m2
    for j = 1 : n2
        distance = sqrt((i - M2) ^ 2 + (j - N2) ^ 2);
        if distance <= D0
            h = 0;
        else
            h = 1;
        end
        shiftF4(i,j) = shiftF4(i,j) * h;
    end
end
shiftF3 = uint8(real(ifft2(ifftshift(shiftF3))));
shiftF4 = uint8(real(ifft2(ifftshift(shiftF4))));
subplot(2,4,3);
imshow(shiftF3);
title('理想高通滤波器pout')
subplot(2,4,4);
imshow(shiftF4);
title('理想高通滤波器Girl')

%------------------------------------------
%下面都是复制粘贴前面的，唯一更改的就是h的条件
%------------------------------------------
shiftF3 = fftshift(fft2(img3));
[m1,n1] = size(shiftF3);
shiftF4 = fftshift(fft2(img4));
[m2,n2] = size(shiftF4);
M1 = round(m1/2);
N1 = round(n1/2);
M2 = round(m2/2);
N2 = round(n2/2);
for i = 1 : m1
    for j = 1 : n1
        distance = sqrt((i - M1) ^ 2 + (j - N1) ^ 2);
        h = 1 / (1 + (D0 / distance) ^ (2 * n));
        shiftF3(i,j) = shiftF3(i,j) * h;
    end
end
for i = 1 : m2
    for j = 1 : n2
        distance = sqrt((i - M2) ^ 2 + (j - N2) ^ 2);
        h = 1 / (1 + (D0 / distance) ^ (2 * n));
        shiftF4(i,j) = shiftF4(i,j) * h;
    end
end
shiftF3 = uint8(real(ifft2(ifftshift(shiftF3))));
shiftF4 = uint8(real(ifft2(ifftshift(shiftF4))));
subplot(2,4,5);
imshow(shiftF3);
title('巴特沃斯高通滤波器pout')
subplot(2,4,6);
imshow(shiftF4);
title('巴特沃斯高通滤波器Girl')

shiftF3 = fftshift(fft2(img3));
[m1,n1] = size(shiftF3);
shiftF4 = fftshift(fft2(img4));
[m2,n2] = size(shiftF4);
M1 = round(m1/2);
N1 = round(n1/2);
M2 = round(m2/2);
N2 = round(n2/2);
for i = 1 : m1
    for j = 1 : n1
        distance = sqrt((i - M1) ^ 2 + (j - N1) ^ 2);
        h = 1 - exp(-(distance ^ 2)/(2 * D0 ^ 2));
        shiftF3(i,j) = shiftF3(i,j) * h;
    end
end
for i = 1 : m2
    for j = 1 : n2
        distance = sqrt((i - M2) ^ 2 + (j - N2) ^ 2);
        h = 1 - exp(-(distance ^ 2)/(2 * D0 ^ 2));
        shiftF4(i,j) = shiftF4(i,j) * h;
    end
end
shiftF3 = uint8(real(ifft2(ifftshift(shiftF3))));
shiftF4 = uint8(real(ifft2(ifftshift(shiftF4))));
subplot(2,4,7);
imshow(shiftF3);
title('高斯高通滤波器pout')
subplot(2,4,8);
imshow(shiftF4);
title('高斯高通滤波器Girl')

%-------------------step 8------------------
figure(5);
%直方图均衡化
A1 = histeq(img3);
%傅里叶变换
shiftF3 = fftshift(fft2(A1));
[m1,n1] = size(shiftF3);
M1 = round(m1/2);
N1 = round(n1/2);
for i = 1 : m1
    for j = 1 : n1
        distance = sqrt((i - M1) ^ 2 + (j - N1) ^ 2);
        %选择高斯高通滤波
        h = 1 - exp(-(distance ^ 2)/(2 * D0 ^ 2));
        %对h进行扩展
        h = 2 * h + 0.5;%a = 2 b = 0.5
        shiftF3(i,j) = shiftF3(i,j) * h;
    end
end
%傅里叶反变换
shiftF3 = uint8(real(ifft2(ifftshift(shiftF3))));
subplot(1,2,1);
imshow(shiftF3);
title('先直方图均衡化后高频增强滤波')
%傅里叶变换
shiftF3 = fftshift(fft2(img3));
[m1,n1] = size(shiftF3);
M1 = round(m1/2);
N1 = round(n1/2);
for i = 1 : m1
    for j = 1 : n1
        %高斯高通滤波
        distance = sqrt((i - M1) ^ 2 + (j - N1) ^ 2);
        h = 1 - exp(-(distance ^ 2)/(2 * D0 ^ 2));
        h = 2 * h + 0.5;%a = 2 b = 0.5
        shiftF3(i,j) = shiftF3(i,j) * h;
    end
end
shiftF3 = uint8(real(ifft2(ifftshift(shiftF3))));
%直方图均衡化
A1 = histeq(shiftF3);
subplot(1,2,2);
imshow(A1);
title('先高频增强滤波后直方图均衡化')
%clear
clc, clear, close all

%读取图像
%origin
T = 2;
origin = imread('G:\\360MoveData\\Users\\Lenovo\\Desktop\\实验图像\\lena.bmp');
%椒盐噪声
salt = imnoise(origin,'salt & pepper',0.03);
subplot(3,2,1);
imshow(origin);
title('origin');
subplot(3,2,2);
imshow(salt);
title('salt');
mean_filter = salt;
%---------Mean Filter----------
w = size(origin, 1);
h = size(origin, 2);
%边角仍等于原值
for i = 2 : (w - 1)
    for j = 2 : (h - 1)
        %求平均值
        mean_filter(i,j) = mean(mean(salt(i - 1 : i + 1, j - 1 : j + 1)));
    end
end
subplot(3,2,3);
imshow(mean_filter)
title('answer 1');
%---------Transfinite neighborhood average----------
neighbor = salt;
%边角仍等于原值
for i = 2 : (w - 1)
    for j = 2 : (h - 1)
        %求平均值
        tmp_mean = mean(mean(salt(i - 1 : i + 1, j - 1 : j + 1)));
        if(abs(salt(i,j) - tmp_mean) > T)
            %相差大于阈值则更新
            neighbor(i,j) = tmp_mean;
        end
    end
end
subplot(3,2,4);
imshow(neighbor)
title('answer 2');
%---------Mid Filter----------
mid_filter = salt;
for i = 2 : (w - 1)
    for j = 2 : (h - 1)
        %将子矩阵转换为向量
        sub = salt(i - 1 : i + 1, j - 1 : j + 1);
        sub = sub(:);
        %求中位数
        mid_filter(i,j) = median(sub);
    end
end
subplot(3,2,5);
imshow(mid_filter)
title('answer 3');
%-----------------4--------------
mid_filter = salt;
for i = 2 : (w - 1)
    for j = 2 : (h - 1)
        %将子矩阵转换为向量
        sub = salt(i - 1 : i + 1, j - 1 : j + 1);
        subb = sub(:);
        for m = 1 : 3
            for n = 1 : 3
                %大于阈值则更新
                if(abs(sub(m,n) - median(subb)) > T)
                    mid_filter(i,j) = median(subb);
                end
            end
        end
    end
end
subplot(3,2,6);
imshow(mid_filter)
title('answer 4');

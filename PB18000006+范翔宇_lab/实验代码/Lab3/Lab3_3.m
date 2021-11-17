%clear
clc, clear, close all

%读取图像
%origin
T = 10;
origin = imread('G:\\360MoveData\\Users\\Lenovo\\Desktop\\实验图像\\lena.bmp');
w = size(origin, 1);
h = size(origin, 2);
subplot(3,2,1);
imshow(origin);
title('origin');
low = min(min(origin));
high = max(max(origin));
R = zeros(w,h);
%随机噪声
for i = 1 : w
    for j = 1 : h
        %产生一个0-1的随机数
        a = rand(1);
        R(i,j) = a;
        %大于0.03则保持原值
        if(a > 0.03)
           random(i,j) = origin(i,j);
        %否则结合随机数进行变换
        else
            random(i,j) = round(rand(1) * (high - low)) + low;
        end
    end
end
subplot(3,2,2);
imshow(random);
title('random');
mean_filter = random;
%---------Mean Filter----------
%边角仍等于原值
for i = 2 : (w - 1)
    for j = 2 : (h - 1)
        %mean求平均值
        mean_filter(i,j) = mean(mean(random(i - 1 : i + 1, j - 1 : j + 1)));
    end
end
subplot(3,2,3);
imshow(mean_filter)
title('answer 1');
%---------Transfinite neighborhood average----------
neighbor = random;
%边角仍等于原值
for i = 2 : (w - 1)
    for j = 2 : (h - 1)
        tmp_mean = mean(mean(random(i - 1 : i + 1, j - 1 : j + 1)));
        %大于则更新
        if(abs(random(i,j) - tmp_mean) > T)
            neighbor(i,j) = tmp_mean;
        end
    end
end
subplot(3,2,4);
imshow(neighbor)
title('answer 2');
%---------Mid Filter----------
mid_filter = random;
for i = 2 : (w - 1)
    for j = 2 : (h - 1)
        %将子矩阵转换为向量
        sub = random(i - 1 : i + 1, j - 1 : j + 1);
        sub = sub(:);
        %中位数
        mid_filter(i,j) = median(sub);
    end
end
subplot(3,2,5);
imshow(mid_filter)
title('answer 3');
%-----------------4--------------
for i = 2 : (w - 1)
    for j = 2 : (h - 1)
        sub = random(i - 1 : i + 1, j - 1 : j + 1);
        subb = sub(:);
        for m = 1 : 3
            for n = 1 : 3
                %大于则更新
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

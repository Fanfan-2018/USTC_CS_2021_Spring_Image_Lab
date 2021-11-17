%clear
clc, clear, close all
img1 = imread('G:/360MoveData/Users/Lenovo/Desktop/实验图像/flower1.jpg');
img2 = imread('G:/360MoveData/Users/Lenovo/Desktop/实验图像/lena.bmp');
img3 = imread('G:/360MoveData/Users/Lenovo/Desktop/实验图像/cameraman.bmp');
img4 = imread('G:/360MoveData/Users/Lenovo/Desktop/实验图像/flower2.jpg');
subplot(2,3,1);
imshow(img1);
title('flower原图')
%-------------------------step 1-------------------------
figure(1);
len=30;
theta=45;
[w,h] = size(img1);
img1 = im2double(img1);
%确定滤波算子
psf=fspecial('motion',len,theta);
%进行滤波，生成运动模糊图像
vague = imfilter(img1,psf,'circular','conv');
subplot(2,3,2);
imshow(vague);
title('运动模糊')
%生成高斯噪声
noisy_var = 0.0001;
noisy = imnoise(vague,'gauss',0, noisy_var);
subplot(2,3,3);
imshow(noisy);
title('高斯噪声')
%纯高斯噪声，不考虑原图像
pure_noisy = noisy - vague;
%进行傅里叶变换
Nf = fft2(pure_noisy);
If = fft2(noisy);
Pf = fft2(psf,w,h);
%不考虑噪声，直接点除进行傅里叶反变换
deal_without_noisy = ifft2(If./Pf);
subplot(2,3,4)
imshow(deal_without_noisy)
title('不处理噪声恢复')
%考虑噪声，减去纯高斯噪声后，再反变换
deal_with_noisy = ifft2(If./Pf - Nf./Pf);
subplot(2,3,5)
imshow(deal_with_noisy)
title('处理噪声恢复')
img4 = im2double(img4);
noisy = imnoise(img4, 'gauss', 0, noisy_var);
%求原方差
origin_var = var(img4(:));
%直接调用库函数
wnr = deconvwnr(noisy, psf, noisy_var / origin_var);
subplot(2,3,6)
imshow(wnr);
title('维纳滤波')

%-------------------------step 2-------------------------
figure(2);
subplot(1,3,1)
imshow(img2);
title('lena');
[w, h] = size(img2);
N = w * h;
L = 256;

%计算概率
for i = 1 : L
    Count(i) = length(find(img2 == (i - 1)));
    f(i) = Count(i) / (N);
end

%寻找下界像素
for i = 1 : L
    if Count(i) ~= 0
        st = i - 1;
        break;
    end
end

%寻找上界像素
for i = L: -1 : 1
    if Count(i) ~= 0
        nd = i - 1;
        break;
    end
end

p = st; q = nd - st + 1;
u = 0;

for i = 1 : q
    %u = Sigma(p * A)像素平均值
    u = u + f(p + i) * (p + i -1);
    ua(i) = u;%ua（i）是前i+p个像素的平均灰度值  
end

for i = 1 : q
    w(i) = sum(f(1 + p : i + p));%前i+p个像素的累积概率
end

w = w + eps;
%找最大类间方差
d = (w ./ (1-w)).*(ua./w-u).^2;
[y,tp] = max(d);
th = tp + p;

subplot(1,2,2);
result = im2bw(img2, th/255);
imshow(result); title('最大类间方差');

%-------------------------step 3-------------------------
figure(3)
subplot(1,2,1);
imshow(img3);
title('原图');
g=splitmerge(img3,2,@predicate);%2代表分割中允许最小的块，predicate函数返回1，说明需要再分裂，返回0说明不需要继续分裂
subplot(1,2,2);
imshow(g);
title('分割结果图像');

function g = splitmerge( img3,mindim,fun )
Q = 2^nextpow2(max(size(img3)));%最靠近的2幂次
[M,N] = size(img3);
img3 = padarray(img3,[Q-M,Q-N],'post');%填充到Q × Q
S = qtdecomp(img3,@split_test,mindim,fun);%四叉树分解 
Lmax = full(max(S(:)));%找最大，并且扩展为正常矩阵
g = zeros(size(img3));
MARKER = zeros(size(img3));%合并标记
for K = 1:Lmax
    [vals,r,c] = qtgetblk(img3,S,K);%该函数返回vals中的块值以及上半部分的行和列坐标 r和c中的块的左上角
    %vals是一个数组，包含f的四叉树分解中大小为k*k的块的值，是一个k*k*个数的矩阵，
     %个数是指S中有多少个这样大小的块，f是被四叉树分的原图像，r，c是左上角开始块的坐标
    if ~isempty(vals)
        for I = 1:length(r)
            %得到每个块的左上角坐标
            xlow = r(I);
            ylow = c(I);
            xhigh = xlow + K - 1;
            yhigh = ylow + K - 1;
            %转化为完整的块区域
            region = img3(xlow:xhigh,ylow:yhigh);
            %判断是否该进行合并且标记
            flag = feval(fun, region);
            if flag%需要则标记
                g(xlow:xhigh,ylow:yhigh) = 1;
                MARKER(xlow,ylow) = 1;
            end
        end
    end
end
%使用标记图像对图像进行合并
g = bwlabel(imreconstruct(MARKER,g));
g = g(1:M,1:N);
end

function v = split_test( B,mindim,fun )
k = size(B,3);
v(1:k) = false;
for I = 1:k
    quadregion = B(:, :, I);
    %判断规格是否允许继续分
    if size(quadregion,1) <= mindim
        v(I) = false;
        continue
    end
    flag = feval(fun,quadregion);
    if flag
        v(I) = true;
    end
end
end

function flag = predicate( region )%判断是否继续细分/是否可以合并
sd = std2(region);%标准差
m = mean2(region);%均值
flag = (sd > 10) & (m > 0) & (m < 255);
end


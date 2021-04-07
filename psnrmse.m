function [PSNR MSE] = psnrmse(Image1,Image2)
x = double(Image1);
y = double(Image2);
[r c p] = size(x);
z=imresize(y, [r c]);
MSE = (sum(sum((x - z) .^ 2)))/(r*c*p);
PSNR = 10*log10((255*255)/MSE);
if p==3
    PSNR = sum(PSNR)/3;
    MSE = sum(MSE)/3;
end
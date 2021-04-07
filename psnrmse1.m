function [PSNR MSE] = psnrmse1(Image1,Image2)
[m1,n1,dim1]=size(Image1);
[m2,n2,dim2]=size(Image2);
if dim1>2
    Image1=rgb2gray(Image1);
end
if dim2>2
    Image2=rgb2gray(Image2);
end
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
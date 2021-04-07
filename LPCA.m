function [Y lpc]= LPCA(M1, M2,SI)
%Y = fuse_pca(M1, M2) image fusion with PCA method
%    M1 - input image #1
%    M2 - input image #2
%    Y  - fused image   
%    (Oliver Rockinger 16.08.99)
% check inputs 
% clc;
% clear all;
% SI=2^N;
[m n]=size(M1);
% SI=input('no of subimages=');
% SI=4;
m1=m/SI;
n1=n/SI;
% for i=1:1:16;
%     si{1,i}=im2(
% im3=im2(1:m1,1:m1);
% im4=im2(1:m1,m1+1:2*m1);
M11=subim(M1,m1,n1);
M21=subim(M2,m1,n1);
[a b]=size(M11);
a=a-1;
b=b-1;
for i=1:1:a;
    for j=1:1:b;
        [y x]=fuse_pca(double(M11{i,j}),double(M21{i,j}));
        y1{i,j}=y;
        x1{i,j}=x;
    end
end
% % % Y=[y3 y4;y5 y6];
for i=1:1:a;
    for j=1:1:b;
       x2(i,j)=x1{i,j}(1,1);
       x3=sum(sum(x2))/(SI.^2);
       x4(i,j)=x1{i,j}(2,1);
       x5=sum(sum(x4))/(SI.^2);
    end
end
lpc=[x3;x5];
% x2=[(x1{1,1}(1,1)+x1{1,2}(1,1)+x1{1,3}(1,1)+x1{1,4}(1,1)+x1{2,1}(1,1)+x1{2,2}(1,1)+x1{2,3}(1,1)+x1{2,4}(1,1)+x1{3,1}(1,1)+x1{3,2}(1,1)+x1{3,3}(1,1)+x1{3,4}(1,1)+x1{4,1}(1,1)+x1{4,2}(1,1)+x1{4,3}(1,1)+x1{4,4}(1,1))/16;
% (x1{1,1}(2,1)+x1{1,2}(2,1)+x1{1,3}(2,1)+x1{1,4}(2,1)+x1{2,1}(2,1)+x1{2,2}(2,1)+x1{2,3}(2,1)+x1{2,4}(2,1)+x1{3,1}(2,1)+x1{3,2}(2,1)+x1{3,3}(2,1)+x1{3,4}(2,1)+x1{4,1}(2,1)+x1{4,2}(2,1)+x1{4,3}(2,1)+x1{4,4}(2,1))/16];
Y = x3*M1+x5*M2;

end

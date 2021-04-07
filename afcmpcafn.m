% clc; clear all;
% a=imread('F:\matlab codes\images\fusion\fuse1.jpg');
% b=imread('F:\matlab codes\images\fusion\fuse2.jpg');
% a = imread('F:\matlab codes\CODES\MEDIAN FILTER ALG\LPCAFCM\medical images\ct5\ct5.bmp');
% b = imread('F:\matlab codes\CODES\MEDIAN FILTER ALG\LPCAFCM\medical images\ct6\ct6.bmp');
% a = imread('F:\matlab codes\CODES\MEDIAN FILTER ALG\LPCAFCM\medical images\mr1\mr1.bmp');
% b = imread('F:\matlab codes\CODES\MEDIAN FILTER ALG\LPCAFCM\medical images\mr2\mr2.bmp');
% a = imread('F:\matlab codes\CODES\MEDIAN FILTER ALG\LPCAFCM\medical images\mr3\mr3.bmp');
% b = imread('F:\matlab codes\CODES\MEDIAN FILTER ALG\LPCAFCM\medical images\mr4\mr4.bmp');
% a = imread('F:\matlab codes\CODES\MEDIAN FILTER ALG\LPCAFCM\medical images\mr5\mr5.bmp');
% b = imread('F:\matlab codes\CODES\MEDIAN FILTER ALG\LPCAFCM\medical images\mr6\mr6.bmp');
% a = imread('F:\matlab codes\CODES\MEDIAN FILTER ALG\LPCAFCM\medical images\mr7\mr7.bmp');
% b = imread('F:\matlab codes\CODES\MEDIAN FILTER ALG\LPCAFCM\medical images\mr8\mr8.bmp');
function [afcmpcaf apc]=afcmpcafn(a,b,nc)
% a=double(a);
% b=double(b);
[x y]=size(a);
% nc=4;
[ac]=afcmclustering(a,nc);
[bc]=afcmclustering(b,nc);
acf=asortcluster(ac,nc);
bcf=asortcluster(bc,nc);
m1=0;m2=0;
fcmfusion=zeros([x y]);
for i=1:1:nc;
    % [acf1 acf2 acf3]=sortcluster(ac1,ac2,ac3);
% [bcf1 bcf2 bcf3]=sortcluster(bc1,bc2,bc3);
 [cf{i} ca{i}]=fuse_pca(acf{i},bcf{i});
 fcmfusion=fcmfusion+cf{i};
 m1=m1+ca{i}(1,1);
 m2=m2+ca{i}(2,1);
end
m1=m1/nc;
m2=m2/nc;
afcmpcaf=m1*a+m2*b;
apc=[m1;m2];
end 
% This is teh MATLAB implementation for the following papers
%%----------- 1. DWT-PCA Fusion
 % Vijayarajan R & Muttan S, “Discrete wavelet transform based principal component averaging fusion for medical images”, 
 % International Journal of Electronics and Communications - AEU, Vol. 69 (6), 2015, pp. 896-902 
 
%%-------LPCA - Iterative block level principal component averaging fusion



clc; clear all;close all;
a = imread('ct_g.jpg');
b = imread('mri_g.jpg');
%-----------CT-MRI FUSION INPUTS----------
% a=imread('F:\matlab codes\images\fusion\fuse1.jpg');
% b=imread('F:\matlab codes\images\fusion\fuse2.jpg');
% a = rgb2gray(imread('F:\matlab codes\CODES\MEDIAN FILTER ALG\LPCAFCM\medical images\mr11\MRCT10.bmp'));
% b = rgb2gray(imread('F:\matlab codes\CODES\MEDIAN FILTER ALG\LPCAFCM\medical images\mr11\MRT210.bmp'));
% a = rgb2gray(imread('F:\matlab codes\CODES\MEDIAN FILTER ALG\LPCAFCM\medical images\mr13\MRCT13.bmp'));
% b = rgb2gray(imread('F:\matlab codes\CODES\MEDIAN FILTER ALG\LPCAFCM\medical images\mr13\MRT113.bmp'));
% %-----------------------------------------
%-----------MRI PD-T2 FUSION INPUTS-------
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
% a = rgb2gray(imread('F:\matlab codes\CODES\MEDIAN FILTER ALG\LPCAFCM\medical images\mr9\mr9.bmp'));
% b = rgb2gray(imread('F:\matlab codes\CODES\MEDIAN FILTER ALG\LPCAFCM\medical images\mr10\mr10.bmp'));

a=double(a);
b=double(b);
sx=size(a);
%% DWT-PCA FUSION
[ca1,ch1,cv1,cd1] = dwt2(a,'db3');
[ca2,ch2,cv2,cd2] = dwt2(b,'db3');
[fca m1]=fuse_pca(ca1,ca2);
[fch m2]=fuse_pca(ch1,ch2);
[fcv m3]=fuse_pca(cv1,cv2);
[fcd m4]=fuse_pca(cd1,cd2);
pc1=(m1(1,1)+m2(1,1)+m3(1,1)+m4(1,1))/4;
pc2=(m1(2,1)+m2(2,1)+m3(2,1)+m4(2,1))/4;
dwtpcaav=pc1*a+pc2*b;
%% OTHER FUSION TECHNIQUES
swtf=SWTfuse(double(a),double(b));
dwtf=fuse_dwb(a,b,4,1,2);
dtcwtf=dtcwtfusion1(a,b);
nsctf=nsctfusionfn(a,b);
M1=a;M2=b;
pcaf=fuse_pca(M1,M2);
[lpcaf lpc]=LPCA(M1,M2,4); %BLOCK LEVEL FUSION
[afcmpcaf apc]=afcmpcafn(a,b,3); % FCM BASED FUSION
% [spfcmpcaf spc]=spfcmpcafn(a,b,3); % SFCM BASED FUSION

l{1}=swtf;l{2}=dwtf;l{3}=dtcwtf;l{4}=nsctf;l{5}=pcaf;
l{6}=lpcaf;l{7}=sfcmpcaf;l{8}=dwtpcaav;
 
for i=1:1:8;
      miab{i,1}=mi(a,l{i});
      miba{i,1}=mi(b,l{i});
      ami{i,1}=(miab{i,1}+miba{i,1})/2;
      K = [0.01 0.03];
      L = 255;
      block_size=8;
      win = fspecial('gaussian', 11, 1.5);
      qindexab{i,1}=uiqi(a,l{i},block_size);
      qindexba{i,1}=uiqi(b,l{i},block_size);
      aqi{i,1}=(qindexab{i,1}+qindexba{i,1})/2;
      mssimab{i,1}= mssim_index(a,l{i},K,L);
      mssimba{i,1}= mssim_index(b,l{i},K,L);
      amssim{i,1}=(mssimab{i,1}+mssimba{i,1})/2;
      [ent{i,1} qzy{i,1} qhnc{i,1} QWB{i,1}]=fusionmetrics(a,b,l{i});
      [PSNRa{i,1} MSEa{i,1}] = psnrmse(a,l{i});
      [PSNRb{i,1} MSEb{i,1}] = psnrmse(b,l{i});
      PSNRav{i,1}=(PSNRa{i,1}+PSNRb{i,1})/2;
      MSEav{i,1}=(MSEa{i,1}+MSEb{i,1})/2;
end
quindex=[qindexab qindexba aqi];
for i=1:1:8;
    amssim{i,1}=abs(amssim{i,1});
end
mssim=[mssimab mssimba amssim];
for i=1:1:8
    for j=1:1:3;
        qhnc1(i,j)=qhnc{i,1}{1,j};
    end
end

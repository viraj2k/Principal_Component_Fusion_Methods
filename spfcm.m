function [im1]=spfcm(img,nc)
% % fuzzy c-mean image segmentation with weighted 
% %   membership functions with spatial constraints;
% %      refer to KS Chuang et al. / Computerized Medical
% %                   Imaging and Graphics 30 (2006) 9–15
% 
% %   [MF,Cent,Obj]=SFCM2D(img,ncluster,max_iter,expo)
% %   inputs:
% %       img: grayscale image;
% %       ncluster: the number of desired cluster;
% %   outputs:
% %       MF: partition matrix;
% %       Cent: cluster centers;
% %       Obj: final objective function
% 
% % Bing Nan LI @ NUS, May 2008
% % $revised 1.1$ Feb 2009
% % $revised 1.2$ Jun 2009
% clc; clear all;
% % tic;
% % img=imread('F:\matlab codes\images\med7.jpg');
% % load('F:\matlab codes\images\U1.mat');
% % img=imread('F:\matlab codes\images\med7\med730.bmp');
% a = imread('F:\matlab codes\CODES\MEDIAN FILTER ALG\LPCAFCM\medical images\mr1\mr1.bmp');
% img=a;
IM1 = img;
img=im2double(IM1);
% imshow(img);
ncluster=nc;
expo =2 ;		% Exponent for U
max_iter = 100;	% Max. iteration
if ndims(img)>2
    error('SFCM2D is applicable to 2D images only!');
    return
end

if nargin<4
    expo=2;
    if nargin<3
        max_iter=100;
    end
end
% % imgw2=img;
imgw2=wiener2(img,5);
% imgw2=medfilt2(img,[3 3]);
[rn,cn]=size(imgw2);
imgsiz=rn*cn;
imgv=reshape(imgw2,imgsiz,1);
imgv=double(imgv);
MF=initfcm(ncluster,imgsiz);
% Main loop
for i = 1:max_iter,
    [MF, Cent,dist1, Obj(i)] = stepfcm2dmf(imgv,[rn,cn],MF,ncluster,expo,...
        1,1,3);
    
	% check termination condition
	if i > 1,
		if abs(Obj(i) - Obj(i-1)) < 1e-2, break; end,
    end
end
iter_n = i;	% Actual number of iterations 
% obj_fcn(iter_n+1:max_iter) = [];
maxMF = max(MF);
m5=MF';
% U2=member;
% maxU2 = max(U2);
% m5=U2';
data=reshape(IM1,[],1);
data_n = size(data, 1);
in_n = size(data, 2);
for i=1:1:nc;
    index{i}=find(MF(i,:) == maxMF);
    [u{i} v{i}]=size(index{i});
    im{i}(1:data_n)=0;
    for l1=1:1:v{i};
        im{i}(index{i}(l1))=data(index{i}(l1));
    end 
    index1{i}=index{i}';
    im1{i}=reshape(im{i},[rn cn]);
end 
% figure,imshow(img7);
% figure,imshow(img8);
% figure,imshow(img9);
% 


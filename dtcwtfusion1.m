function imf=dtcwtfusion1(nt,n7)
% Dual tree complex wavelet transform (DT-CWT) based image fusion demo
% By VPS Naidu, MSDF Lab, June 2011
% DT-CWT software used in this fusion algorithm is from 
% clear all; close all; home;
% User selection (1,2,3,...)
J = 3; % number of decomposition levels used in the fusion 
[Faf,Fsf] = FSfarras; % first stage filters
[af,sf] = dualfilt2;  % second stage filters
% a = double(imread('F:\matlab codes\images\med9\med9.bmp'));
% a=imresize(a,[256 256]);
% b=imread('F:\matlab codes\images\med9\med913.bmp');
% [x y]=size(b);
% nt=hmf(b,[5 5]);
% n7=adaweightmedian(b);
% images to be fused
im1 = double(nt);
im2 = double(n7);
% im1=imresize(im1,[512 512]);
% im2=imresize(im2,[512 512]);
% im1=imresize(im1,[480 640]);
% im2=imresize(im2,[480 640]);

% % im1 = double(imread('saras91.jpg'));
% % im2 = double(imread('saras92.jpg'));

% im1 = double(imread('fuse1.jpg'));
% im2 = double(imread('fuse2.jpg'));
% figure; subplot(121);imshow(im1,[]); subplot(122); imshow(im2,[]);
% image decomposition
w1 = cplxdual2D(im1,J,Faf,af);
w2 = cplxdual2D(im2,J,Faf,af);
% Image fusion process start here
for j=1:J % number of stages
    for p=1:2 %1:real part & 2: imaginary part
        for d1=1:2 % orientations
            for d2=1:3
                x = w1{j}{p}{d1}{d2};
                y = w2{j}{p}{d1}{d2};
                D  = (abs(x)-abs(y)) >= 0; 
                wf{j}{p}{d1}{d2} = D.*x + (~D).*y; % image fusion
            end
        end
    end
end
for m=1:2 % lowpass subbands
    for n=1:2
        wf{J+1}{m}{n} = 0.5*(w1{J+1}{m}{n}+w2{J+1}{m}{n}); % fusion of lopass subbands
    end
end

% fused image
imf = icplxdual2D(wf,J,Fsf,sf);
% impca=fuse_pca(im1,im2);
% [PSNR1 MSE1] = psnrmse(a,double(nt));
% [PSNR2 MSE2] = psnrmse(a,double(n7));
% [PSNR3 MSE3] = psnrmse(a,imf);
% [PSNR4 MSE4] = psnrmse(a,impca);
% % psnr =[PSNR1 MSE1;
% %     PSNR2 MSE2;
% %     PSNR3 MSE3];
% figure; imshow(imf,[]); 
% figure; subplot(221);imshow(im1,[]); subplot(222); imshow(im2,[]);subplot(223);imshow(imf,[]);subplot(224);imshow(impca,[]);
function[SWTout] = SWTfuse(im1,im2)
% Image fusion by (two levels) discrete stationary wavelet transform  - demo
% by VPS Naidu, MSDF Lab, NAL, Bangalore
% close all;
% clear all;
% home;

% insert images
% im1 = double(imread('saras51.jpg'));
% im2 = double(imread('saras52.jpg'));
% figure(1);
% subplot(121);imshow(im1,[]);
% subplot(122);imshow(im2,[]);

% image decomposition using discrete stationary wavelet transform
[A1L1,H1L1,V1L1,D1L1] = swt2(im1,1,'sym2');
[A2L1,H2L1,V2L1,D2L1] = swt2(im2,1,'sym2');
[A1L2,H1L2,V1L2,D1L2] = swt2(A1L1,1,'sym2');
[A2L2,H2L2,V2L2,D2L2] = swt2(A2L1,1,'sym2');

% fusion at level2
AfL2 = 0.5*(A1L2+A2L2);
D = (abs(H1L2)-abs(H2L2))>=0;
HfL2 = D.*H1L2 + (~D).*H2L2;
D = (abs(V1L2)-abs(V2L2))>=0;
VfL2 = D.*V1L2 + (~D).*V2L2;
D = (abs(D1L2)-abs(D2L2))>=0;
DfL2 = D.*D1L2 + (~D).*D2L2;

% fusion at level1
D = (abs(H1L1)-abs(H2L1))>=0;
HfL1 = D.*H1L1 + (~D).*H2L1;
D = (abs(V1L1)-abs(V2L1))>=0;
VfL1 = D.*V1L1 + (~D).*V2L1;
D = (abs(D1L1)-abs(D2L1))>=0;
DfL1 = D.*D1L1 + (~D).*D2L1;

% fused image
AfL1 = iswt2(AfL2,HfL2,VfL2,DfL2,'sym2');
SWTout = iswt2(AfL1,HfL1,VfL1,DfL1,'sym2');
% figure(2); imshow(SWTout,[]);
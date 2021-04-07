function [mssim] = mssim_index(img1, img2,K,L)
% Multi-scale SSIM
%  Input:
%   img1 - first image
%   img2 - second image
%  Output:   mssim - mssim value

nlevs = 5;

% Use Analysis Low Pass filter from Biorthogonal 9/7 Wavelet
lod = [0.037828455507260; -0.023849465019560;  -0.110624404418440; ...
    0.377402855612830; 0.852698679008890;   0.377402855612830;  ...
    -0.110624404418440; -0.023849465019560; 0.037828455507260];
lpf = lod*lod';
lpf = lpf/sum(lpf(:));

img1 = double(img1);img2 = double(img2);
window = fspecial('gaussian',11,1.5);
window = window/sum(sum(window));
ssim_v = zeros(nlevs,1);
ssim_r = zeros(nlevs,1);
% Scale 1 is the original image
comp_ssim = ssim_index_modified(img1,img2,K,L);
ssim_v(1) = comp_ssim(2);
ssim_r(1) = comp_ssim(3);

% Compute SSIM for scales 2 through 5
for s=1:nlevs-1    
    % Low Pass Filter
    img1 = imfilter(img1,lpf,'symmetric','same');
    img2 = imfilter(img2,lpf,'symmetric','same');    
    img1 = img1(1:2:end,1:2:end);
    img2 = img2(1:2:end,1:2:end);

    comp_ssim = ssim_index_modified(img1,img2,K,L);
    ssim_m = comp_ssim(1);         % Mean Component only needed for scale 5
    ssim_v(s+1) = comp_ssim(2);
    ssim_r(s+1) = comp_ssim(3);   
end
alpha = 0.1333;
beta = [0.0448 0.2856 0.3001 0.2363 0.1333]';
gamma = [0.0448 0.2856 0.3001 0.2363 0.1333]';

comp = [ssim_m^alpha prod(ssim_v.^beta) prod(ssim_r.^gamma)];
mssim = prod(comp);

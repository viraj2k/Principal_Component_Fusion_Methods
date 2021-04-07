function[composite_mean_vec] = ssim_index_modified(img1, img2, K,L)

[M N] = size(img1);
 window = fspecial('gaussian', 11, 1.5);	
 %%

C1 = (K(1)*L)^2;
C2 = (K(2)*L)^2;
window = window/sum(sum(window));
img1 = double(img1);
img2 = double(img2);

mu1   = filter2(window, img1, 'valid');
mu2   = filter2(window, img2, 'valid');
mu1_sq = mu1.*mu1;
mu2_sq = mu2.*mu2;
mu1_mu2 = mu1.*mu2;
sigma1_sq = filter2(window, img1.*img1, 'valid') - mu1_sq;
sigma2_sq = filter2(window, img2.*img2, 'valid') - mu2_sq;
sigma1 = real(sqrt(sigma1_sq));
sigma2 = real(sqrt(sigma2_sq));
sigma12 = filter2(window, img1.*img2, 'valid') - mu1_mu2;

if (C1 > 0 && C2 > 0)
   M = (2*mu1_mu2 + C1)./(mu1_sq + mu2_sq + C1);
   V = (2*sigma1.*sigma2 + C2)./(sigma1_sq + sigma2_sq + C2);
   R = (sigma12 + C2/2)./(sigma1.*sigma2+C2/2);   
else
   ssim_ln = 2*mu1_mu2;
   ssim_ld = mu1_sq + mu2_sq;
   M = ones(size(mu1));
   index_l = (ssim_ld>0);
   M(index_l) = ssim_ln(index_l)./ssim_ld(index_l);
   
   ssim_cn = 2*sigma1.*sigma2;
   ssim_cd = sigma1_sq + sigma2_sq;
   V = ones(size(mu1));
   index_c = (ssim_cd>0);
   V(index_c) = ssim_cn(index_c)./ssim_cd(index_c);
   
   ssim_sn = sigma12;
   ssim_sd = sigma1.*sigma2;
   R = ones(size(mu1));
   index1 = sigma1>0;
   index2 = sigma2>0;
   index_s = (index1.*index2>0);
   R(index_s) = ssim_sn(index_s)./ssim_sd(index_s);
   index_s = (index1.*not(index2)>0);
   R(index_s) = 0;
   index_s = (not(index1).*index2>0);
   R(index_s) = 0;
end
composite_mean_vec = [mean2(M) mean2(V) mean2(R)];

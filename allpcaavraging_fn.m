function [swtf,dwtf,dtcwtf,nsctf,pcaf,lpcaf,afcmpcaf,dwtpcaav]=allpcaavraging_fn(img1,img2)

a=double(img1);
b=double(img2);
sx=size(a);
%% DWT-PCA FUSION
[ca1,ch1,cv1,cd1] = dwt2(a,'db2');
[ca2,ch2,cv2,cd2] = dwt2(b,'db2');
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
%[spfcmpcaf spc]=spfcmpcafn(a,b,3); % SFCM BASED FUSION

% l{1}=swtf;l{2}=dwtf;l{3}=dtcwtf;l{4}=nsctf;l{5}=pcaf;
% l{6}=lpcaf;l{7}=afcmpcaf;l{8}=dwtpcaav;
 end
function Fused_img=nsctfusionfn(a,b)
% clc; clear all;close all;
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
% a = imread('F:\matlab codes\CODES\MEDIAN FILTER ALG\LPCAFCM\medical images\mr7\mr701.bmp');
% b = imread('F:\matlab codes\CODES\MEDIAN FILTER ALG\LPCAFCM\medical images\mr8\mr801.bmp');
% a=double(a);
% b=double(b);

%% Reading the CT Image file
% [FileName,PathName] = uigetfile('*.tif','Select the CT image file');
% file = fullfile(PathName,FileName);
% disp(['User selected : ', file]);

% img1 = imresize(imread(file),[200 200]); 
img1=a;
% figure;
% imshow(img1,[]);


%% Reading the MRI Image file
% [FileName,PathName] = uigetfile('*.tif','Select the MRI image file');
% file = fullfile(PathName,FileName);
% disp(['User selected : ', file]);
% img2 = imresize(imread(file),[200 200]);
img2=b;
% figure;
% imshow(img2,[]);


%% Parameters for NSCT
nlevels = 1;       % Decomposition level
% disp('NSCT decomposition for CT image ')
% msgbox(' NSCT decomposition for CT image ')
img1_NSCT=nsctdec(img1,nlevels);
img1_NSCT_Low = img1_NSCT{1};
for i = 1: length(img1_NSCT{1,2})
    
img1_NSCT_high{i}=((img1_NSCT{1,2}{1,i}));

end

% figure,imshow(uint8(img1_NSCT{1}),[])
% 
% for i = 1: length(img1_NSCT{1,2})
%     
% figure,imshow(uint8(img1_NSCT{1,2}{1,i}),[])
% 
% end

% disp('NSCT decomposition for MRI image ')
% msgbox(' NSCT decomposition for MRI image ')

img2_NSCT = nsctdec(img2, nlevels);

% 
% figure,imshow(uint8(img2_NSCT{1}),[])
% 
% for j = 1: length(img2_NSCT{1,2})
%     
% figure,imshow(uint8(img1_NSCT{1,2}{1,j}),[])
% 
% end

img2_NSCT_Low = img2_NSCT{1};

for i = 1: length(img2_NSCT{1,2})
    img2_NSCT_high{i}=((img2_NSCT{1,2}{1,i}));
end

%% Fusion of Low sub band
% phase Congruency

[phaseCongruency_img1,orientation_img1] = phasecong(img1_NSCT_Low);

% figure,imshow(phaseCongruency_img1)

[phaseCongruency_img2,orientation_img2] = phasecong(img2_NSCT_Low);

% figure,imshow(phaseCongruency_img2)
% img_NSCT_Low_fuse = zeros(size(img1_NSCT_Low));

img_NSCT_Low_fuse = [];

for i = 1:size(phaseCongruency_img1,1)
    for j = 1: size(phaseCongruency_img1,2)
        if(phaseCongruency_img1(i,j) > phaseCongruency_img2(i,j))
            img_NSCT_Low_fuse(i,j) = img1_NSCT_Low(i,j);
        else if(phaseCongruency_img1(i,j) < phaseCongruency_img2(i,j))
            img_NSCT_Low_fuse(i,j) = img2_NSCT_Low(i,j);
        else  
            img_NSCT_Low_fuse(i,j) =(img1_NSCT_Low(i,j)+img2_NSCT_Low(i,j)/2);
             end    
        end
    end
end

% figure,imshow(img_NSCT_Low_fuse,[])

%% Fusion of High Sub band

% h{1}=yA{2}; 

% clevels =length( nlevels ) ;
% nIndex = clevels + 1 ;
for i= 1 :length(img1_NSCT{1,2})
    smlA{i} = SML(img1_NSCT_high{i}); 
end    

for i= 1 : length(img2_NSCT{1,2})
    smlB{i} = SML(img2_NSCT_high{i}); 
end   


for i=1: length(img1_NSCT{1,2})
    if(img1_NSCT_high{1}~=0)
        DirA{i} = smlA{i}/img1_NSCT_high{1};
    else
        DirA{i} =smlA{i};
    end
end
for i=1: length(img2_NSCT{1,2})
    if(img2_NSCT_high{1}~=0)
        DirB{i} = smlB{i}/img2_NSCT_high{1};
    else
        DirB{i} =smlB{i};
    end
end
% 
%% Fuse the high-frequency sub-images
% img_NSCT_high_fuse = zeros(img1_NSCT_high{1},1);

for i = 1:size(img1_NSCT_high{1},1)
    for j = 1: size(img1_NSCT_high{1},2)
        for ii =1:length(img2_NSCT{1,2})
            if (DirA{ii}(i,j)>= DirB{ii}(i,j))
                img_NSCT_high_fuse{ii}(i,j) = img1_NSCT_high{ii}(i,j);
            else
                img_NSCT_high_fuse{ii}(i,j) = img2_NSCT_high{ii}(i,j);
            end    
        end 
        
    end
end

  
% figure,imshow(img_NSCT_High_fuse{1},[]);

img_NSCT_fuse{1} = img_NSCT_Low_fuse;
img_NSCT_fuse{2} = img_NSCT_high_fuse;

Fused_img=nsctrec(img_NSCT_fuse);
% figure,imshow(Fused_img,[]);



% figure
% subplot(1,3,1),imshow(img1,[]);
% subplot(1,3,2),imshow(img2,[]);
% subplot(1,3,3),imshow(Fused_img,[])
% 


%%

nRow = 200;
nColumn = 200;
Q = 255;
% MSE = sum(sum((img2-uint8(Fused_img)).^2))/nRow / nColumn;
MSE = sum(sum((double(img2)-Fused_img).^2))/nRow / nColumn;
RMSE = sqrt(MSE)/100
fprintf('The psnr performance w.r.t. MRI is %.2f dB\n', 10*log10(Q*Q/MSE));


% MSE = sum(sum((img1-uint8(Fused_img)).^2))/nRow / nColumn;
MSE = sum(sum((double(img1)-Fused_img).^2))/nRow / nColumn;
RMSE = sqrt(MSE)/100
fprintf('The psnr performance w.r.t. CT is %.2f dB\n', 10*log10(Q*Q/MSE));



% 
% 
% nRow = 200;
% nColumn = 200;
% Q = 255;
% MSE = sum(sum((GRAY1-X1).^2))/nRow / nColumn;
% 
% RMSE = sqrt(MSE)/100
% fprintf('The psnr performance is %.2f dB\n', 10*log10(Q*Q/MSE));
% end
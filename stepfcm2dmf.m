function [U_new, center, obj_fcn] = stepfcm2dmf(data, dims, U, cluster_n,...
    expo, mfw, spw, nwin)
%STEPFCM One step in fuzzy c-mean image segmentation with spatial constraints;

mf = U.^expo;   % MF matrix after exponential modification

center = mf*data./((ones(size(data, 2),1)*sum(mf'))'); % new center

dist = distfcm(center, data);       % fill the distance matrix

obj_fcn = sum(sum((dist.^2).*mf));  % objective function

tmp = dist.^(-2/(expo-1));      % calculate new U, suppose expo != 1

U_new = tmp./(ones(cluster_n, 1)*sum(tmp));

tempwin=ones(nwin);
mfwin=zeros(size(U_new));

for i=1:size(U_new,1)
    tempmf=reshape(U_new(i,:), dims);
    tempmf=imfilter(tempmf,tempwin,'conv');
    mfwin(i,:)=reshape(tempmf,1,size(U_new,2));
end

mfwin=mfwin.^spw;
U_new=U_new.^mfw;

tmp=mfwin.*U_new;
U_new=tmp./(ones(cluster_n, 1)*sum(tmp));
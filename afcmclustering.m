function [img1]=afcmclustering(IM1,nc)
[x y]=size(double(IM1));
data=reshape(IM1,[],1);
data_n = size(data, 1);
in_n = size(data, 2);
[center,member,obj_fcn]=fcm(data,nc);
U2=member;
maxU2 = max(U2);
m5=U2';
for i=1:1:nc;
    index{i}=find(U2(i,:) == maxU2);
    [u{i} v{i}]=size(index{i});
    img{i}(1:data_n)=0;
    for l1=1:1:v{i};
        img{i}(index{i}(l1))=data(index{i}(l1));
    end 
    index1{i}=index{i}';
    img1{i}=reshape(img{i},[x y]);
end 
             
end
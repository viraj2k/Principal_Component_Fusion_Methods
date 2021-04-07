function [acf]=asortcluster(ac,nc)
for i=1:1:nc;
    amax(i)=max(max(ac{i}));
    a4(1,i)=amax(i);
 end
asort=sort(a4);
for i=1:1:nc;
    for j=1:1:nc;
        if  asort(1,i)==amax(1,j);
            acf{1,i}=ac{1,j};
        end
    end 
end 

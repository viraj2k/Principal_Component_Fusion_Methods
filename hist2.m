function n=hist2(A,B,L)
%HIST2 Calculates the joint histogram of two images or signals
%
%   n=hist2(A,B,256) is the joint histogram of matrices A and B, using 256
%   bins for each matrix.
%
%   See also MI, HIST.

%   jfd, 15-11-2006, working
%        27-11-2006, memory usage reduced (sub2ind)
%        22-10-2008, added support for 1D matrices
%        01-09-2009, commented specific code for sensorimotor signals


ma=min(A(:));
MA=max(A(:));
mb=min(B(:));
MB=max(B(:));

% For sensorimotor variables, in [-pi,pi]
% ma=-pi;
% MA=pi;
% mb=-pi;
% MB=pi;

% Scale and round to fit in {0,...,L-1}
A=round((A-ma)*(L-1)/(MA-ma));
B=round((B-mb)*(L-1)/(MB-mb));

for i=0:L-1
    [x y]=find(A==i);
    siz=size(A);
    if(min(siz)>1)
        j=sub2ind(siz,x,y);
    else  % case in which A,B are vectors
        j=max(x,y);
    end
    
    n(i+1,:)=hist(B(j),0:L-1);
end

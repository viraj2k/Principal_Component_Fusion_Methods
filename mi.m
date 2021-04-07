function I=mi(A,B,varargin)
%MI Determines the mutual information of two images or signals
%
%   I=mi(A,B)
%
%   Assumption: 0*log(0)=0
%
%   See also WENTROPY.

%   jfd, 15-11-2006
%        01-09-2009, added case of non-double images

A=double(A); 
B=double(B); 
    
na = hist(A(:),256);
na = na/sum(na);

nb = hist(B(:),256);
nb = nb/sum(nb);

n2 = hist2(A,B,256);
n2 = n2/sum(n2(:));

I=minf(n2,na'*nb);
I=sum(I);

% -----------------------

function y=minf(pab,papb)

I=find(papb>1e-12); % function support

u=pab(I);
v=papb(I);
i=find(u<1e-12);

warning off
y=u.*log2(u./v);
warning on

% assumption: 0*log(0)=0
y(i)=0;


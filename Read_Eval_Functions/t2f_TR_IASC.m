function [yLeft,yRight,L,R]=t2f_TR_IASC(F,Y)
%T2F_TR_EKM
%
% SYNTAX:
%     t2f_TR_KM(...)
%
% INPUTS:
%
% OUTPUTS:
%
% EXAMPLE :
%
% See also

% Copyright (c) Istanbul Technical University Control Engineering 2014
% $Revision: 1.10 $, $Date: 2014/02/19 10:20:06VET $ by $Author: Ahmet Taskin $

% Calls:
%% IASC Algorithm for Computing Y Left

% Sort Y matrix
lowerY = Y(:,1);
[~, ind] = sort(lowerY);
lowerY = lowerY(ind,:);
sortedF = F(ind,:);
lowerF = sortedF(:,1);
upperF = sortedF(:,2);

% Step 1.
N=size(F,1);
a= sum(lowerY.*lowerF);
b= sum(lowerF);
yl=lowerY(N);
l=0;


while(1)
    % Step 2.
    l=l+1;
    a=a+lowerY(l)*(upperF(l)-lowerF(l));
    b=b+upperF(l)-lowerF(l);
    c=a/b;
    
    % Step 3.
    if c>=yl
       L=l-1;
       yLeft=yl;
    break
    else
        yl=c;
   end
    
end

%% IASC Algorithm for Computing Y right

% Sort Y matrix
upperY = Y(:,2);
[~, ind] = sort(upperY);
upperY = upperY(ind,:);
sortedF = F(ind,:);
lowerF = sortedF(:,1);
upperF = sortedF(:,2);

% Step 1.

a= sum(upperY.*upperF);
b= sum(upperF);
yr=upperY(1);
r=0;


while(1)
    % Step 2.
    r=r+1;
    a=a-upperY(r)*(upperF(r)-lowerF(r));
    b=b-upperF(r)+lowerF(r);
    c=a/b;
    
    % Step 3.
    if c<=yr
       R=r-1;
       yRight=yr;
    break
    else
        yr=c;
   end
    
end




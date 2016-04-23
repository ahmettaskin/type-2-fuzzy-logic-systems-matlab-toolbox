function [yLeft,yRight,L,R]=t2f_TR_EIASC(F,Y)
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
%% EIASC Algorithm for Computing Y Left

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
L=0;


while(1)
    % Step 2.
    L=L+1;
    a=a+lowerY(L)*(upperF(L)-lowerF(L));
    b=b+upperF(L)-lowerF(L);
    yl=a/b;
    
    % Step 3.
    if yl<=lowerY(L+1)
        L=L;
        yLeft=yl;
        break
        
    end
    
end

%% EIASC Algorithm for Computing Y right

% Sort Y matrix
upperY = Y(:,2);
[~, ind] = sort(upperY);
upperY = upperY(ind,:);
sortedF = F(ind,:);
lowerF = sortedF(:,1);
upperF = sortedF(:,2);

% Step 1.

a = sum(upperY.*lowerF);
b = sum(lowerF);
R = N;

while(1)
    % Step 2.
    a=a+upperY(R)*(upperF(R)-lowerF(R));
    b=b+upperF(R)-lowerF(R);
    yr=a/b;
    R=R-1;
    % Step 3.
    if yr>=upperY(R)
       R=R;
       yRight=yr;
    break
   end
    
end




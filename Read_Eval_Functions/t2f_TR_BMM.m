function [yLeft,yRight,L,R]=t2f_TR_BMM(F,Y,alfa,beta)
%T2F_TR_NT
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
if nargin==2
   alfa=0.5;
   beta=0.5;
end
% Sort Y matrix
lowerY = Y(:,1);
upperY = Y(:,2);
[~, ind] = sort(lowerY);
lowerY = lowerY(ind,:);
upperY = upperY(ind,:);
sortedF = F(ind,:);
lowerF = sortedF(:,1);
upperF = sortedF(:,2);

% Convert to crisp Y matrix

if isequal(lowerY,upperY)
    y=lowerY;
else
    y=(lowerY+upperY)/2;
end

yLeft=alfa*(sum(y.*(lowerF)))/sum(lowerF)+beta*(sum(y.*(upperF)))/sum(upperF);
yRight=yLeft;
L='no';
R='no';




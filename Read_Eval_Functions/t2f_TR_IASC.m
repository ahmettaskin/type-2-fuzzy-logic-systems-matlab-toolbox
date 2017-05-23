%  IT2-FLS Toolbox is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
% 
%     IT2-FLS Toolbox is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
% 
%     You should have received a copy of the GNU General Public License
%     along with IT2-FLS Toolbox.  If not, see <http://www.gnu.org/licenses/>.
function [yLeft,yRight,L,R]=t2f_TR_IASC(F,Y)
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
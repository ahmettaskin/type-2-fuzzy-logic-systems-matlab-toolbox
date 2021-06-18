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
function [yLeft,yRight,L,R]=t2f_TR_EKM(F,Y)
%% EKM Algorithm for Computing Y Left

% a) Sort Y matrix
lowerY = Y(:,1);
[~, ind] = sort(lowerY);
lowerY = lowerY(ind,:);
sortedF = F(ind,:);
lowerF = sortedF(:,1);
upperF = sortedF(:,2);

% Step 1.
N=size(F,1);
l=round(N/2.4);
a= sum(lowerY(1:l).*upperF(1:l)) + sum(lowerY(l+1:end).*lowerF(l+1:end));
b= sum(upperF(1:l)) + sum(lowerF(l+1:end));
y=a/b;

while(1)
    
    % Step 2.
    lussu = 0;
    for i=1:N-1;
        if y>=lowerY(i) && y<=lowerY(i+1)
            lussu = i;
            break
        end
    end
    
    % Step 3.
    if lussu==l
        yLeft = y;
        L = l;
        break
    else
        
        % Step 4.
        s=sign(lussu-l);
        aussu=a+s*(sum(lowerY(min(l,lussu)+1:max(l,lussu)).*(upperF(min(l,lussu)+1:max(l,lussu))-lowerF(min(l,lussu)+1:max(l,lussu)))));
        bussu=b+s*(sum(upperF(min(l,lussu)+1:max(l,lussu))-lowerF(min(l,lussu)+1:max(l,lussu))));
        yussu=aussu/bussu;
        % Step 5.
        y=yussu;
        a=aussu;
        b=bussu;
        l=lussu;
    end
end

%% EKM Algorithm for Computing Y right

% Sort Y matrix
upperY = Y(:,2);
[~, ind] = sort(upperY);
upperY = upperY(ind,:);
sortedF = F(ind,:);
lowerF = sortedF(:,1);
upperF = sortedF(:,2);

% Step 1.
r=round(N/1.7);
a= sum(upperY(1:r).*lowerF(1:r)) + sum(upperY(r+1:end).*upperF(r+1:end));
b= sum(lowerF(1:r)) + sum(upperF(r+1:end));
y=a/b;

while(1)
    
    % Step 2.
    russu = 0;
    for i=1:N-1;
        if y>=upperY(i) && y<=upperY(i+1)
            russu = i;
            break
        end
    end
    
    % Step 3.
    if russu==r
        yRight = y;
        R = r;
        break
    else
        
        % Step 4.
        s=sign(russu-r);
        aussu=a-s*(sum(upperY(min(r,russu)+1:max(r,russu)).*(upperF(min(r,russu)+1:max(r,russu))-lowerF(min(r,russu)+1:max(r,russu)))));
        bussu=b-s*(sum(upperF(min(r,russu)+1:max(r,russu))-lowerF(min(r,russu)+1:max(r,russu))));
        yussu=aussu/bussu;
        % Step 5.
        y=yussu;
        a=aussu;
        b=bussu;
        r=russu;
    end
end
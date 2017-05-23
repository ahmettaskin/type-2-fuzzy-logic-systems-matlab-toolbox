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
function [yLeft,yRight,L,R]=t2f_TR_EODS(F,Y):
%% EODS Algorithm for Computing Y Left

% Sort Y matrix
lowerY = Y(:,1);
[~, ind] = sort(lowerY);
lowerY = lowerY(ind,:);
sortedF = F(ind,:);
lowerF = sortedF(:,1);
upperF = sortedF(:,2);

% Step 1.
N=size(F,1);
m=2;
n=N-1;
Sl=(lowerY(m)-lowerY(1))*upperF(1);
Sr=(lowerY(N)-lowerY(n))*lowerF(N);
Fl=lowerF(N);
Fr=upperF(1);


while(1)
    % Step 2.
    if m==n
        %Step 4.
        if Sl<=Sr
            L=m;
            Fr=Fr+upperF(m);
        else
            L=m-1;
            Fl=Fl+lowerF(m);
        end
        % Step 5.
        yl=lowerY(m)+((Sr-Sl)/(Fr+Fl));
        yLeft=yl;
        break
    else
        % Step 3.
        if Sl>Sr
            Fl=Fl+lowerF(n);
            n=n-1;
            Sr=Sr+Fl*(lowerY(n+1)-lowerY(n));
        else
            Fr=Fr+upperF(m);
            m=m+1;
            Sl=Sl+Fr*(lowerY(m)-lowerY(m-1));
        end
    end
end

%% EODS Algorithm for Computing Y right

% Sort Y matrix
upperY = Y(:,2);
[~, ind] = sort(lowerY);
upperY = upperY(ind,:);
sortedF = F(ind,:);
lowerF = sortedF(:,1);
upperF = sortedF(:,2);

% Step 1.
N=size(F,1);
m=2;
n=N-1;
Sl=(upperY(m)-upperY(1))*lowerF(1);
Sr=(upperY(N)-upperY(n))*upperF(N);
Fl=lowerF(1);
Fr=upperF(N);


while(1)
    % Step 2.
    if m==n
        %Step 4.
        if Sl<=Sr
            R=m;
            Fl=Fl+lowerF(m);
        else
            R=m-1;
            Fr=Fr+upperF(m);
        end
        % Step 5.
        yr=upperY(m)+((Sr-Sl)/(Fr+Fl));
        yRight=yr;
        break
    else
        % Step 3.
        if Sl>Sr
            Fr=Fr+upperF(n);
            n=n-1;
            Sr=Sr+Fr*(upperY(n+1)-upperY(n));
        else
            Fl=Fl+lowerF(m);
            m=m+1;
            Sl=Sl+Fl*(upperY(m)-upperY(m-1));
        end
    end
end
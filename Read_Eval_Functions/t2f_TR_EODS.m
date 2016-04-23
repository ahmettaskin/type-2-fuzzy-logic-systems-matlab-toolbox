function [yLeft,yRight,L,R]=t2f_TR_EODS(F,Y)
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




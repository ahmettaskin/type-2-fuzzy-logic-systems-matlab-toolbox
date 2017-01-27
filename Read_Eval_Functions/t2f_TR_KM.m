function [yLeft,yRight,L,R]=t2f_TR_KM(F,Y)
%% KM Algorithm for Computing Y Left

% a) Sort Y matrix
lowerY = Y(:,1);
[~, ind] = sort(lowerY);
lowerY = lowerY(ind,:);
sortedF = F(ind,:);
% b) Initialize fn by setting and computing
FOrt =  sum(F')'/2;
isZero=(sum(FOrt)==0);
nRules=size(F,1);
if isZero
    yn=0;
else
    yn = sum(lowerY.*FOrt)/sum(FOrt);
end
while(1)
    % c) Find switch point k (1 <= k <= N ? 1) such that yk <= y <= yk+1
    sPointLeft = 0;
    for i=1:nRules-1;
        if yn>=lowerY(i) && yn<=lowerY(i+1)
            sPointLeft = i;
            break
        end
    end
    % d) Compute
    for i=1:nRules
        if i<=sPointLeft
            fn(i,1) = sortedF(i,2);
        elseif i>sPointLeft
            fn(i,1) = sortedF(i,1);
        end
        
    end
    if(sum(fn)==0)
        ynPrime=0;
    else
        ynPrime = sum(lowerY.*fn)/sum(fn);
    end
    % e) if yn==ynPrime stop else go to c)
    if(abs(yn-ynPrime)<10^-3)
        yLeft = yn;
        L = sPointLeft;
        break;
    else
        yn=ynPrime;
    end
end

%% KM Algorithm for Computing Y Right
% a) Sort Y matrix
UpperY = Y(:,2);
[~, ind ] = sort(UpperY);
UpperY=UpperY(ind,:);
sortedF = F(ind,:);

% b) Initialize fn by setting and computing
FOrt =  sum(F')'/2;
isZero=(sum(FOrt)==0);
nRules=size(F,1);
if isZero
    yn=0;
else
    yn = sum(UpperY.*FOrt)/sum(FOrt);
end
% c) Find switch point k (1 <= k <= N ? 1) such that yk <= y <= yk+1
while(1)
    sPointRight = 0;
    for i=1:nRules-1;
        if yn>=UpperY(i) && yn<=UpperY(i+1)
            sPointRight = i;
            break
        end
    end
    for i=1:nRules
        if i<=sPointRight
            fn(i,1) = sortedF(i,1);
        elseif i>sPointRight
            fn(i,1) = sortedF(i,2);
        end
    end
    if(sum(fn)==0)
        ynPrime=0;
    else
        ynPrime = sum(UpperY.*fn)/sum(fn);
    end
    % e) if yn==ynPrime stop else go to c)
    if(abs(yn-ynPrime)<10^-3)
        yRight = yn;
        R = sPointRight;
        break;
    else
        yn=ynPrime;
    end
end
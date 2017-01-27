function [yLeft,yRight,L,R]=t2f_TR_NT(F,Y)
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


% y=()/();

yLeft=(sum(y.*(upperF+lowerF)))/sum(upperF+lowerF);
yRight=yLeft;
L='no';
R='no';
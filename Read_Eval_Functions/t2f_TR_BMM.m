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
function [yLeft,yRight,L,R]=t2f_TR_BMM(F,Y,alfa,beta)
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
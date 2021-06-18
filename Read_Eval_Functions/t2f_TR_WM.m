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
function [yLeft,yRight,L,R]=t2f_TR_WM(F,Y)
% Sort Y matrix
lowerY = Y(:,1);
upperY = Y(:,2);
[~, ind] = sort(lowerY);
lowerY = lowerY(ind,:);
upperY = upperY(ind,:);
sortedF = F(ind,:);
lowerF = sortedF(:,1);
upperF = sortedF(:,2);

upperyl=min(sum(lowerY.*(lowerF))/sum(lowerF),sum(lowerY.*(upperF))/sum(upperF));

loweryr=min(sum(upperY.*(lowerF))/sum(lowerF),sum(upperY.*(upperF))/sum(upperF));

loweryl=upperyl-(sum(upperF-lowerF)/(sum(upperF)*sum(lowerF)) * sum(lowerF.*(lowerY-lowerY(1))) * sum(upperF.*(lowerY(end)-lowerY)) / (sum(lowerF.*(lowerY-lowerY(1)))+sum(upperF.*(lowerY(end)-lowerY))));

upperyr=loweryr+(sum(upperF-lowerF)/(sum(upperF)*sum(lowerF))*sum(upperF.*(upperY-upperY(1)))*sum(lowerF.*(upperY(end)-upperY))/(sum(upperF.*(upperY-upperY(1)))+sum(lowerF.*(upperY(end)-upperY))));
if isnan(loweryl)
    loweryl=upperyl;    
end
if isnan(upperyr)
    upperyr=loweryr;    
end


yLeft=(loweryl+upperyl)/2;
yRight=(loweryr+upperyr)/2;
L=0;
R=0;
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
function [xOut,yOut,x2Out,y2Out]=plotMfs(fis,varType,varIndex,numPts)
if nargin<4, numPts=181; end

fisType=fis.type;

if ~strcmp(varType,'input') & (~strcmp(varType,'output') | strcmp(fisType,'sugeno'))
    error('No plots for Sugeno Output MFs')
end

if strcmp(varType, 'input')
    if isfield(fis.input(varIndex), 'mf')
        numMFs=size(fis.input(varIndex).mf, 2);
    else
        numMFs = 0;
    end
    var=fis.input(varIndex);
else
    if isfield(fis.output(varIndex), 'mf')
        numMFs=size(fis.output(varIndex).mf, 2);
    else
        numMFs=0;
    end
    var=fis.output(varIndex);
end

y=zeros(numPts,numMFs);
y2=zeros(numPts,numMFs);
xPts=linspace(var.range(1),var.range(2),numPts)';
%%tip1
x=xPts(:,ones(numMFs,1));
for mfIndex=1:numMFs,
    mfType=var.mf(1,mfIndex).type;
    mfParams=var.mf(1,mfIndex).params;
    y(:,mfIndex)=mfParams(end)*helper.evalmf2(xPts,mfParams(1:end-1),mfType);
end
%%tip2
for mfIndex=1:numMFs,
    mfType=var.mf(2,mfIndex).type;
    mfParams=var.mf(2,mfIndex).params;
    y2(:,mfIndex)=mfParams(end)*helper.evalmf2(xPts,mfParams(1:end-1),mfType);
end
if nargout<1,
    plot(x,y)
    
    xlabel(var.name,'FontSize',10);
    ylabel('Degree of membership','FontSize',10)
    axis([var.range(1) var.range(2) -0.1 1.1])
    for mfIndex=1:numMFs,
        centerIndex=find(y(:,mfIndex)==max(y(:,mfIndex)));
        centerIndex=floor(mean(centerIndex));
        text(x(centerIndex,mfIndex),1.05,var.mf(mfIndex).name, ...
            'HorizontalAlignment','center', ...
            'VerticalAlignment','middle', ...
            'FontSize',10)
    end
else
    xOut=x;
    yOut=y;
    y2Out=y2;
    x2Out=x;
end

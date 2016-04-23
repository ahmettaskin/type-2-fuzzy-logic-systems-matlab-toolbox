function copyAxes()
%T2F_COPYAXES Summary of this function goes here
%   Detailed explanation goes here
% SYNTAX: 
%   t2f_copyaxes(...) 
%
% INPUTS: 
%   
% OUTPUTS:
%   
% EXAMPLE :
%   
% See also 

% Copyright (c) AVL PTE Controls 2015 
% $Revision: 1.11 $, $Date: 2015/01/13 08:48:54GMT $ by $Author: Dalon Thierry RGB (DALONT) $ 

% Calls: 

% Find Figure 
figNumber=gcf;
% Fin Axes 
mainAxes=findobj(figNumber,'Type','axes','Tag','mainaxes');
% Create new figure
f1=figure;
% Copy axes from Toolbox
s1=copyobj(mainAxes,f1);
axes(s1);
hold on;

set(s1,'YColor','black');
set(s1,'XColor','black');
%Delete title
title('');
% Find and delete old colors
OldColors=findobj(s1,'FaceColor',[0.5 0.5 0.5]);
% delete(OldColors);

% Find and delete Labels in the axes
OldLabels=findobj(s1,'Type','text');
delete(OldLabels);

% Make all lines black
lineHndl=findobj(s1,'Tag','mfline');
set(lineHndl,'Color','black');

% Make background color white
set(s1,'Color','white');
axis([-1,1,0,1])

% Delete xlabel name
xlabel('');

% Grid off
grid off

% Position of the figure
set(s1,'Position',[0.3 0.08 0.65 0.86])



hold off;
function obj=grid(~,~,obj,cmd)
%GRID
%
% SYNTAX:
%     grid(...)
%
% INPUTS:
%
% OUTPUTS:
%
% EXAMPLE :
%
% See also

% Copyright (c) AVL Software and Functions GmbH 2014
% $Revision: 1.10 $, $Date: 2014/02/19 10:20:06VET $ by $Author: Dalon Thierry RGB (DALONT) $

% Calls:
figNumber=gcf;



HandlGridOn = findobj('Tag', 'gridon');
HandlGridOff = findobj('Tag', 'gridoff');
fis=helper.getAppdata;
% inputColor=[1 1 0.8];
mainAxes=findobj('tag','mainaxes');
axes(mainAxes(1))
% hold on;

% hold off;
switch cmd
    case 'on'
        set(HandlGridOff,'value',0)
        set(HandlGridOn,'value',1)
        grid on;
    case 'off'
        set(HandlGridOn,'value',0)
        set(HandlGridOff,'value',1)
        grid off;
end
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
function obj=grid(~,~,obj,cmd)
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
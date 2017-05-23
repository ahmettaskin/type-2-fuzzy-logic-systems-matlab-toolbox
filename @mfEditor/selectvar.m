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
function [ obj ] = selectvar( ~,~,obj )
selectColor=[1 0 0];
figNumber=gcf;
fis=helper.getAppdata;
fisType=fis.type;
newCurrVarPatch=get(figNumber,'CurrentObject');
%   sss=get(newCurrVarPatch)
%   newCurrVarPatch = gcbo;
%   if isempty(newCurrVarPatch)| ~strcmp(get(newCurrVarPatch, 'Type'), 'patch')
%     newCurrVarPatch=findobj(figNumber, 'Tag', 'input1');
%   end
newCurrVar=get(newCurrVarPatch,'Parent');
if isempty(newCurrVar)
    newCurrVar=findobj('tag','input');
    newCurrVar=newCurrVar(1);
    if isempty(newCurrVar)
        newCurrVar=findobj('tag','input1');
        newCurrVar=newCurrVar(1);
    end
end
varIndex=get(newCurrVar,'UserData');

varType=get(newCurrVar,'Tag');
if isequal(varType,'input')
    varType='input';
else
    varType='output';
end
% Deselect all others if necessary
oldCurrVar=findobj(figNumber,'Type','axes','XColor',selectColor);
if newCurrVar~=oldCurrVar,
    set(oldCurrVar,'XColor','k','YColor','k');
    set(oldCurrVar,'LineWidth',1);
end

% Now hilight the new selection
set(newCurrVar,'XColor',selectColor,'YColor',selectColor);
set(newCurrVar,'LineWidth',3);

% Set all current variable display registers ...
dispRangeHndl=findobj(figNumber,'Type','uicontrol','Tag','disprange');
customHndl=findobj(figNumber,'Type','uimenu','Tag','addcustommf');

if strcmp(fisType,'sugeno') & strcmp(varType,'output'),
    % Handle sugeno case
    dispRangeStr=' ';
    set(dispRangeHndl,'String',dispRangeStr,'UserData',dispRangeStr, ...
        'Enable','off');
    set(customHndl,'Enable','off');
else
    dispRangeStr=[' ' mat2str(eval(['fis.' varType '(' num2str(varIndex) ').range']), 4)];
    set(dispRangeHndl,'String',dispRangeStr,'UserData',dispRangeStr, ...
        'Enable','on');
    set(customHndl,'Enable','on');
end

%         if strcmp(get(figNumber,'SelectionType'),'open'),
% %             error('dikkat et!')
%             fisgui #findgui
%         end

% The VARIABLE NAME text field
name='varname';
hndl=findobj(figNumber,'Type','uicontrol','Tag',name);

varName=eval(['fis.' varType '(' num2str(varIndex),').name']);
set(hndl,'String',varName);

% The VARIABLE TYPE text field
name='vartype';
hndl=findobj(figNumber,'Type','uicontrol','Tag',name);
set(hndl,'String',varType);

% The VARIABLE RANGE text field
name='varrange';
hndl=findobj(figNumber,'Type','uicontrol','Tag',name);
rangeStr=mat2str(eval(['fis.' varType '(' num2str(varIndex),').range']),4);
labelStr=[' ' rangeStr];
set(hndl,'String',labelStr);

helper.statmsg(figNumber,['Selected variable "' varName '"']);

helper.setCrispInterval(varType);


obj=plotmfs(obj);
% Call localSelectmf to select first mf and populate mf text boxes
try
    localSelectmf([], [], selectColor);
end
%         paint_intervals

end


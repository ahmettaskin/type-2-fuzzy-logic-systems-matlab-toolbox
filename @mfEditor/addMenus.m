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
function obj = addMenus(~,~, obj )
%% get figure handle
hFuzzy=findall(0,'tag','mfEditor');

%% Edit
h1 = uimenu(hFuzzy, ...
    'Label','Edit');
uimenu(h1, ...
    'Callback',{@addmfs obj}, ...
    'Label','Add MFs...');

uimenu(h1, ...
    'Callback',{@removeallmfs obj}, ...
    'Label','Remove All MFs');
end

function [ obj ] = addmfs( ~,~,obj )
selectColor=[1 0 0];
%% Remove all Membership functions before adding
answer=questdlg({'Current Membership Functions will be deleted.',...
    ' ',...
    'Do you want to continue ?'},...
    'Adding Membership Functions','Yes','No','Yes');
if isequal(answer,'No')
    disp('Adding MFs cancelled by user.')
    return
end

obj=removeallmfs('','',obj);

%====================================
figNumber=gcf;
fis=helper.getAppdata;
% Find the selected variable and MF
currVarAxes=findobj(figNumber,'Type','axes','XColor',selectColor);
varIndex=get(currVarAxes,'UserData');
varType=get(currVarAxes,'Tag');

helper.mfAddDlg(fis,varType,varIndex,figNumber);
mfdlgfig=findobj(0, 'Tag', 'mfAddDlg');
waitfor(mfdlgfig);
fis=helper.getAppdata;
helper.setAppdata(fis);
% There is now atleast one mf therefore check the remove all mf menu item
hndl=findobj(figNumber,'Type','uimenu','Tag','removeallmf');
set(hndl,'Enable','on');
obj=plotmfs(obj);
end

function [ obj ] = removeallmfs( ~,~,obj )
selectColor=[1 0 0];
figNumber=gcf;
fis=helper.getAppdata;
% Find the selected variable
currVarAxes=findobj(figNumber,'Type','axes','XColor',selectColor);
varIndex=get(currVarAxes,'UserData');
varType=get(currVarAxes,'Tag');
mainAxes=findobj(figNumber,'Type','axes','Tag','mainaxes');

lineHndlList=findobj(mainAxes,'Tag','mfline');
txtHndlList=findobj(mainAxes,'Type','text');

deleteFlag=1;
count=eval(['length(fis.' varType '(' num2str(varIndex) ').mf)']);
%     while count>=1,
fis=helper.removeMfs(fis,varType,varIndex);
%         count=count-1;
if isempty(fis),
    % if any of these MFs are used in the rule base, we can't delete
    deleteFlag=0;
    statmsg(figNumber,errorStr);
    count=0;
end
%     end
if deleteFlag
    delete(lineHndlList);
    delete(txtHndlList);
    helper.setAppdata(fis);
    obj=plotmfs(obj);
    % Deselect the remove mf menu items
    hndl=findobj(figNumber,'Type','uimenu','Tag','removeallmf');
    set(hndl,'Enable','off');
    hndl=findobj(figNumber,'Type','uimenu','Tag','removemf');
    set(hndl,'Enable','off');
end
end
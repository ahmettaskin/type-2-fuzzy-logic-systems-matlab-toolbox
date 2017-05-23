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
function obj = update(obj)
figNumber=gcf;

fis=helper.getAppdata;
numRules=length(fis.rule);
fisName=fis.name;
% The RULES edit window
name='rulewindow';
hndl=findobj(figNumber,'Type','uicontrol','Tag',name);
if numRules>0,
    langHndl=findobj(figNumber,'Type','uimenu', 'Tag', 'lang', 'Checked','on');
    lang=lower(get(langHndl,'Label'));
    labelStr=showRule(obj,fis,1:numRules);
else
    labelStr=' ';
    msgStr=['No rules for system "' fisName '"'];
    helper.statmsg(figNumber,msgStr);
end
set(hndl, 'Value', 1, 'String',labelStr);

i=1;
j=1;
nameinHndl=[];
nameoutHndl=[];
tempinHndl=findobj(figNumber, 'Tag', ['ruleinmake' num2str(i)]);
tempoutHndl=findobj(figNumber, 'Tag', ['ruleoutmake' num2str(i)]);
if ~isempty(tempinHndl)
    nameinHndl(i)=tempinHndl;
end
if ~isempty(tempoutHndl)
    nameoutHndl(j)=tempoutHndl;
end
while ~isempty(tempinHndl)
    i=i+1;
    tempinHndl=findobj(figNumber, 'Tag', ['ruleinmake' num2str(i)]);
    if ~isempty(tempinHndl)
        nameinHndl(i)=tempinHndl;
    end
end
while ~isempty(tempoutHndl)
    j=j+1;
    tempoutHndl=findobj(figNumber, 'Tag', ['ruleoutmake' num2str(j)]);
    if ~isempty(tempoutHndl)
        nameoutHndl(j)=tempoutHndl;
    end
end
if (~isempty(nameinHndl))|(~isempty(nameoutHndl) )
    for k=1:length(nameinHndl)
        tempradioHndl=findobj(figNumber, 'Tag', ['ruleinradio' num2str(k)]);
        templabelHndl=findobj(figNumber, 'Tag', ['ruleinlabel' num2str(k)]);
        tempkeywHndl=findobj(figNumber, 'Tag', ['ruleinkeyw' num2str(k)]);
        delete(tempradioHndl);
        delete(templabelHndl);
        delete(tempkeywHndl);
    end
    for k=1:length(nameoutHndl)
        tempradioHndl=findobj(figNumber, 'Tag', ['ruleoutradio' num2str(k)]);
        templabelHndl=findobj(figNumber, 'Tag', ['ruleoutlabel' num2str(k)]);
        tempkeywHndl=findobj(figNumber, 'Tag', ['ruleoutkeyw' num2str(k)]);
        delete(tempradioHndl);
        delete(templabelHndl);
        delete(tempkeywHndl);
    end
    delete(nameoutHndl);
    delete(nameinHndl)
end
localAddRuleMake(obj,fis);
shiftlHndl=findobj(figNumber, 'Tag', 'shiftleft');
shiftrHndl=findobj(figNumber, 'Tag', 'shiftright');
if isprop(fis, 'input') & isprop(fis, 'output')
    if length(fis.input)+length(fis.output)<6
        set(shiftlHndl, 'Enable', 'off');
        set(shiftrHndl, 'Enable', 'off');
    else
        set(shiftlHndl, 'Enable', 'on');
        set(shiftrHndl, 'Enable', 'on');
    end
end
end
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
function obj = dispRules(~,~,obj)
figNumber=gcf;
menuHndl=findobj(figNumber,'Type','uimenu','Tag','rulefrmt', 'Checked','on');
dispStyle=lower(get(menuHndl,'Label'));
dispStyle=deblank(dispStyle);
dispStyle=fliplr(deblank(fliplr(dispStyle)));
fis=helper.getAppdata;
numRules=length(fis.rule);
if numRules==0,
    msgStr=['There are no rules for this system.'];
    helper.statmsg(figNumber,msgStr);
else
    msgStr=['Translating to ' dispStyle ' format'];
    helper.statmsg(figNumber,msgStr);
    editHndl=findobj(figNumber,'Tag', 'rulewindow');
    langHndl=findobj(figNumber,'Type','uimenu','Tag', 'lang', 'Checked','on');
    lang=lower(get(langHndl,'Label'));
    editStr=showRule(obj,fis,1:numRules,dispStyle,lang);
    % editStr=char([32*ones(size(editStr,1),1) editStr]);
    set(editHndl,'String',editStr);
end

end
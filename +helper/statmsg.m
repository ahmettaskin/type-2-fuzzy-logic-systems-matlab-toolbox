function statmsg(figNumber,msgStr)
set(findobj(figNumber,'Type','uicontrol','Tag','status'),'String',msgStr);
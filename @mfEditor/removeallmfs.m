function [ obj ] = removeallmfs( ~,~,obj )
%REMOVEALLMFS Summary of this function goes here
%   Detailed explanation goes here
%====================================
%% colors
figColor=[0.9 0.9 0.9];
frmColor=192/255*[1 1 1];
editColor=255/255*[1 1 1];
selectColor=[1 0 0];
unselectColor=[0 0 0];
inputColor=[1 1 0.93];
outputColor=[0.8 1 1];
tickColor=[0.5 0.5 0.5];
popupColor=192/255*[1 1 1];

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


function [ obj ] = addmfs( ~,~,obj )

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


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
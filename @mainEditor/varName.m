function obj = varName( ~,~,obj )
figNumber=gcf;
fis=helper.getAppdata;
currVarAxes=findobj(figNumber,'Type','axes','XColor',selectColor);
varIndex=get(currVarAxes,'UserData');
tag=get(currVarAxes,'Tag');
if strcmp(tag(1:5),'input'),
    varType='input';
else
    varType='output';
end

varNameHndl=findobj(figNumber,'Type','uicontrol','Tag','currvarname');
newName=deblank(get(varNameHndl,'String'));
% Strip off the leading space
newName=fliplr(deblank(fliplr(newName)));
% Replace any remaining blanks with underscores
newName(find(newName==32))=setstr(95*ones(size(find(newName==32))));
set(varNameHndl,'String',[' ' newName]);
msgStr=['Renaming ' varType ' variable ' num2str(varIndex) ' to "' newName '"'];
statmsg(figNumber,msgStr);

% Change the name of the label in the input-output diagram
txtHndl=get(currVarAxes,'XLabel');
set(txtHndl,'String',newName);

eval(['fis.' varType '(' num2str(varIndex) ').name=''' newName ''';']);             %%strcmp does not work for structures
helper.setAppdata(fis);
end


function [ obj ] = addVar( obj, varargin )
figNumber=gcf;
selectColor = [1 0.3 0.3];
%     currMenu=gcbo;
%currMenu = eventSrc;
%     varType=get(currMenu,'Tag');
varType=varargin{1,1};

fis=helper.getAppdata;
% "Add" has been selected, so add a variable
fis=helper.addVar_t2(fis,varType,'',[-1 1],'init');
if strcmp(varType,'input')
    numVars=length(fis.input);
else
    numVars=length(fis.output);
end
newVarName=[varType num2str(numVars)];
eval(['fis.' varType '(numVars).name = newVarName; '])
msgStr=['Adding the ' varType ' variable "' newVarName '"'];
statmsg(figNumber,msgStr);
%    set(figNumber,'UserData',fis);

% Now replot the FIS diagram
% First delete all axes except for the main one
axHndlList=findobj(figNumber,'Type','axes');
mainAxHndl=findobj(figNumber,'Type','axes','Tag','mainaxesmain');
axHndlList(find(axHndlList==mainAxHndl))=[];
delete(axHndlList);
lineHndlList=findobj(figNumber,'Type','line');
delete(lineHndlList);
%         obj=plotFis(obj);

% Clear the VARIABLE NAME, TYPE, and RANGE fields
hndl=findobj(figNumber,'Type','uicontrol','Tag','currvarname');
set(hndl,'String',' ');
hndl=findobj(figNumber,'Type','uicontrol','Tag','currvartype');
set(hndl,'String',' ');
hndl=findobj(figNumber,'Type','uicontrol','Tag','currvarrange');
set(hndl,'String',' ');

statmsg(figNumber,'Ready');
helper.setAppdata(fis);
% Call localSelectVar to select variable and populate text boxes
localSelectVar2( lower(varType), num2str(numVars), figNumber, selectColor);
% Update all the other editors
helper.setAppdata(fis);
mfEditorHnd=findall(0,'type','figure','Tag','mfEditor');
if ~isempty(mfEditorHnd)
    close(mfEditorHnd)
    mfEditor('initialize',fis);
end
hfuzzyt2 = findall(0,'type','figure','Tag','fuzzyt2');
figure(hfuzzyt2);

end
%%%%%%%%%%%%%%%%%%%%
%  localSelectVar  %
%%%%%%%%%%%%%%%%%%%%
function localSelectVar2(eventSrc, eventData, figNumber, selectColor)
% This used to be called using elseif strcmp(action,'#selectvar')
% Function is called on initialization of the fuzzy editor and
% when user btn's down on, or deletes an input or output variable.
figX=gcf;
fis=helper.getAppdata;

if ishghandle(eventSrc)
    % Function was called via callback from btn down on a variables patch
    info = get(eventSrc, 'UserData');
    newCurrVar = info.Handle;           % axes where patch is drawn
    varIndex   = info.Index;
    varType    = info.Type;
    % Reset any selected items
    kids = findobj(figNumber,'Type','Axes','XColor',selectColor);
    set(kids,'LineWidth',1,'XColor','k','YColor','k');
else
    % Function was called at initialization of a new GUI or variable, therefore
    varType  = eventSrc;   % A string of the variable type to select
    numVars  = eventData;  % A string of the variable index number to select
    kids = get(figNumber,'children');
    newCurrVar = findobj(kids,'tag', [varType numVars]);
    varIndex = str2num(numVars);
    % Plot will have already been redrawn therefore no need to reset
end

% Ensure plot has been redrawn correctly
refresh(figNumber);

% If there are no variables left to plot dont try to plot them
if varIndex ~= 0
    % Now highlight the new selection
    set(newCurrVar,'XColor',selectColor,'YColor',selectColor,'LineWidth',3);
    
    % Set all current variable display registers ...
    varNameHndl=findobj(figNumber,'Type','uicontrol','Tag','currvarname');
    varRangeHndl=findobj(figNumber,'Type','uicontrol','Tag','currvarrange');
    if strcmp(varType, 'input'),
        set(varNameHndl,'String',[' ' fis.input(varIndex).name],'Enable','on');
        set(varRangeHndl,'String',mat2str(fis.input(varIndex).range));
    else
        set(varNameHndl,'String',[' ' fis.output(varIndex).name],'Enable','on');
        set(varRangeHndl,'String',mat2str(fis.output(varIndex).range));
    end
    varTypeHndl=findobj(figNumber,'Type','uicontrol','Tag','currvartype');
    set(varTypeHndl,'String',varType);
    
    rmvarMenuHndl=findobj(figNumber,'Type','uimenu','Tag','removevar');
    set(rmvarMenuHndl,'Enable','on')
    
    if strcmp(get(figNumber,'SelectionType'),'open'),
        % Open the MF Editor with the right variable in view,
        % when user double clicks on variable.
        fisName=fis.name;
        guiName='Membership Function Editor';
        newFigNumber=findobj(0,'Name',[guiName ': ' fisName]);
        if ~isempty(newFigNumber),
            statmsg(figNumber,['Updating ' guiName]);
            figure(newFigNumber);
            % mfedit('#update',varType,varIndex);
            mfEditor('initialize',fis);
        else
            statmsg(figNumber,['Opening ' guiName]);
            % mfedit(fis,varType,varIndex);
            mfEditor('initialize',fis);
        end
        
    end
end
end

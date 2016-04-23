function obj = localSelectVar(  eventSrc, eventData, obj, figNumber, selectColor)
%LOCALSELECTVAR Summary of this function goes here
%   Detailed explanation goes here
% This used to be called using elseif strcmp(action,'#selectvar')
% Function is called on initialization of the fuzzy editor and
% when user btn's down on, or deletes an input or output variable.
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
        inputNames=get_inputNames(fis);
        inputRanges = get_inputRanges(fis);
        set(varNameHndl,'String',[' ' inputNames(varIndex)],'Enable','on');
        set(varRangeHndl,'String',mat2str(inputRanges{varIndex}));
    else
        outputNames=get_outputNames(fis);
        outputRanges = get_outputRanges(fis);
        
        set(varNameHndl,'String',[' ' outputNames(varIndex)],'Enable','on');
        set(varRangeHndl,'String',mat2str(outputRanges{varIndex}));
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
            mfEditor('initialize',fis)
        else
            statmsg(figNumber,['Opening ' guiName]);
            % mfedit(fis,varType,varIndex);
            mfEditor('initialize',fis);
        end
        
    end
end

end


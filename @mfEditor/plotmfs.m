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
function [ obj ] = plotmfs( obj )
%% colors
selectColor=[1 0 0];
unselectColor=[0 0 0];
inputColor=[1 1 0.93];
outputColor=[0.8 1 1];
figNumber=gcf;
fis=helper.getAppdata;
% Find the selected variable
currVarAxes=findobj(figNumber,'Type','axes','XColor',selectColor);
varIndex=get(currVarAxes,'UserData');
varType=get(currVarAxes,'Tag');
if isempty(varType)
    varType='input';
end
if isempty(varIndex);
    varIndex=1;
end
if strcmp(varType,'input'),
    varType='input';
    backgroundColor=inputColor;
else
    backgroundColor=outputColor;
    varType='output';
end

fisType=fis.type;
mainAxes=findobj(figNumber,'Tag','mainaxes');
try
    axes(mainAxes);
end
varName=eval(['fis.' varType '(' num2str(varIndex) ').name']);
try
    numMFs=eval(['length(fis.' varType '(' num2str(varIndex) ').mf(:))']);
    numMFs=numMFs/2;
catch ME
    numMFs=0;
end
if strcmp(fisType,'sugeno') & strcmp(varType,'output'),
    % Handle sugeno case
    cla
    if isprop(fis, 'input')
        numInputs=length(fis.input);
    else
        numInputs=0;
    end
    
    inLabels=[];
    for i=1:numInputs
        inLabels=strvcat(inLabels, fis.input(i).name);
    end
    
    varRange=[-1 1];
    numMFs=2*numMFs;
    for count=1:numMFs,
        mfName=eval(['fis.' varType '(' num2str(varIndex) ').mf(' num2str(count) ').name']);
        txtStr=deblank(mfName);
        if numMFs>6,
            % Use two columns
            if (count-1)<(numMFs/2),
                % This is column one
                xPos=0.25*diff(varRange)+varRange(1);
                yPos=(count-1)/(numMFs/2-1);
            else
                % This is column two
                xPos=0.75*diff(varRange)+varRange(1);
                yPos=(count-round(numMFs/2)-1)/(round(numMFs/2)-1);
            end
        else
            % Only one column is necessary
            xPos=0;
            yPos=(count)/(numMFs);
        end
        
        text(xPos,yPos,txtStr, ...
            'Color',unselectColor, ...
            'UserData',count, ...
            'HorizontalAlignment','center', ...
            'FontSize',8, ...
            'ButtonDownFcn',{@localSelectmf selectColor});
    end
    set(gca,'XTick',[],'YTick',[], ...
        'XLim',[-1 1],'YLim',[-0.2 1.2], ...
        'Color',backgroundColor);
else
    % This is either an input variable or a mamdani output
    dispRangeHndl=findobj(figNumber,'Tag','disprange');
    varRange=eval(get(dispRangeHndl,'String'));
    ptsHndl = findobj(figNumber, 'Tag', 'numpoints');
    numPts=get(ptsHndl, 'String');
    numPts='181';
    numPts=str2double(numPts);
    cla
    % Draw all the lines
    set(gca, ...
        'YTick',[0 0.5 1],'XTickMode','auto', ...
        'YLim',[-0.05 1.2], ...
        'Color',backgroundColor);
    
    %             try
    [xAllMFs,yAllMFs,xAll2MFs,yAll2MFs]=helper.plotMfs(fis,varType,varIndex,numPts);
    %             catch ME
    %                 xAllMFs = repmat(linspace(0,1,numPts),numMFs,1);
    %                 yAllMFs = NaN(numMFs,numPts);
    %             end
    
    for mfIndex=1:2*numMFs,
        if helper.isInt(mfIndex/2)
            x=xAll2MFs(:,(mfIndex/2));
            y=yAll2MFs(:,(mfIndex/2));
        else
            x=xAllMFs(:,(mfIndex/2+0.5));
            y=yAllMFs(:,(mfIndex/2+0.5));
        end
        
        mfName=eval(['fis.' varType '(' num2str(varIndex) ').mf(' num2str(mfIndex) ').name']);
        if helper.isNewGraphics
            line(x,y, ...
                'Color',unselectColor, ...
                'LineWidth',2, ...
                'UserData',mfIndex, ...
                'Tag', 'mfline',...
                'PickableParts','visible',...
                'HitTest', 'on',...
                'ButtonDownFcn',{@localSelectmf selectColor})
        else
            line(x,y, ...
                'Color',unselectColor, ...
                'LineWidth',2, ...
                'UserData',mfIndex, ...
                'Tag', 'mfline',...
                'ButtonDownFcn',{@localSelectmf selectColor})
        end
        centerIndex=find(y==max(y));
        centerIndex=round(mean(centerIndex));
        if ~isnan(centerIndex)
            text(x(centerIndex), 1.1*max(y) ,mfName, ...
                'HorizontalAlignment','center', ...
                'Color',unselectColor, ...
                'FontSize',8, ...
                'UserData',mfIndex, ...
                'Tag', 'mftext',...
                'ButtonDownFcn',{@localSelectmf selectColor});
        end
        param=get(gca, 'Userdata');
        param.CurrMF=-1;
        if varRange(2)==varRange(1)
            varRange = varRange(1) + (1+abs(varRange(1))) * [-.1,.1];
        end
        set(gca,'UserData',param,'XLim',varRange);
    end
end

xlabel([varType ' variable "' varName '"'],'Color','black','FontSize',8);

% Clean up the MF fields
% Name Upper Edit
hndl=findobj(figNumber,'Type','uicontrol','Tag','mfname');
set(hndl,'String',' ','Enable','off');
% Name Lower Edit
hndl=findobj(figNumber,'Type','uicontrol','Tag','mfname Lower');
set(hndl,'String',' ','Enable','off');
% Type Upper
hndl=findobj(figNumber,'Type','uicontrol','Tag','mftype');
set(hndl,'Value',1,'Enable','off');
% Type Lower
hndl=findobj(figNumber,'Type','uicontrol','Tag','mftypelower');
set(hndl,'Value',1,'Enable','off');
% Params Upper
hndl=findobj(figNumber,'Type','uicontrol','Tag','mfparams');
set(hndl,'String',' ','Enable','off');
% Params Lower
hndl=findobj(figNumber,'Type','uicontrol','Tag','mfparams2');
set(hndl,'String',' ','Enable','off');


% Ensure plot is redrawn correctly
refresh(figNumber);
% Fill intervals;
obj=fill('','',obj);

end

function obj = localSelectmf(eventSrc,~,obj)
% Called when a user btn downs on an mf and selects the first mf
% to be selected when a new input or output is plotted.
%% colors

obj = mfEditor('initialize');

selectColor=[1 0 0];
figNumber=gcf;
fis=helper.getAppdata;
fisType=fis.type;

% Is the current variable input or output?
currVarAxes=findobj(figNumber,'Type','axes','XColor',selectColor);
varIndex=get(currVarAxes,'UserData');
% varIndex=1;
varType=get(currVarAxes,'Tag');
% varType='input';

if ~isempty(eventSrc)
    % The function was called from a btn down action on an object
    mainAxes=get(eventSrc,'Parent');
    % Find the new current MF
    param=get(mainAxes,'UserData');
    oldCurrMF=param.CurrMF;
    newCurrMF=get(eventSrc,'UserData');
    param.CurrMF=newCurrMF;
    plot_mfs = 1;
else
    % The function was called directly and should initialize the first mf
    oldCurrMF = -1;
    % Check there is an mf to plot
    if ~isempty(currVarAxes)
        % Check there is an mf to plot
        if length(eval(['fis.' varType '(' num2str(varIndex) ').mf'])) >= 1
            plot_mfs = 1;
            % Set the first mf to be selected
            newCurrMF = 1;
            kids = get(figNumber,'Children');
            mainAxes = kids(find(strcmp(get(kids,'tag'),'mainaxes')));
            param.CurrMF=1;
        else
            % There are no mfs therefore dont plot anything
            plot_mfs = 0;
            % Set the remove mf menuitems
            h1 = findobj(figNumber,'Type','uimenu','Tag','removemf');
            h2 = findobj(figNumber,'Type','uimenu','Tag','removeallmf');
            set([h1, h2],'Enable','off');
        end
    else
        % There is no selected input or output therefore dont plot anything
        plot_mfs = 0;
    end
end

% Plot an mf
if plot_mfs == 1
    % Deselect other currently selected MF curves
    if oldCurrMF~=newCurrMF,
        if oldCurrMF~=-1
            deselectmf(obj,selectColor);
            
        end
        set(mainAxes,'UserData',param);
        
        % Find the info for the new MF
        mfParams=localgetmfparam(fis, varType, varIndex, newCurrMF, 'params');
        if  isequal(varType,'output')
            mfTypeUpper=localgetmfparam(fis, varType, varIndex, newCurrMF, 'type');
            if strcmpi(mfTypeUpper,'constant')
                for k=1:numel(mfParams)
                     mfParamsUpper(1,k)= mfParams(k);
                end                                
            else
                pos=1;
                for kkk=1:2
                    for k=1:numel(mfParams)/2
                        mfParamsUpper(1,pos)= mfParams(pos);
                        pos=pos+1;
                    end
                end
            end            
        elseif ~helper.isInt(newCurrMF/2) % selected is upper
            mfTypeUpper=localgetmfparam(fis, varType, varIndex, newCurrMF, 'type');
            mfTypeLower=localgetmfparam(fis, varType, varIndex, newCurrMF+1, 'type');
            %for k=1:numel(mfParams)
            mfParamsUpper= mfParams;
            mfParamsLower=localgetmfparam(fis, varType, varIndex, newCurrMF+1, 'params');
            %end
        elseif helper.isInt(newCurrMF/2) % selected is lower
            mfTypeUpper=localgetmfparam(fis, varType, varIndex, newCurrMF-1, 'type');
            mfTypeLower=localgetmfparam(fis, varType, varIndex, newCurrMF, 'type');
            mfParamsUpper= localgetmfparam(fis, varType, varIndex, newCurrMF-1, 'params');
            mfParamsLower=mfParams;
        end
        
        mfTypeHndl=findobj(figNumber,'Type','uicontrol','Tag','mftype');
        
        mfTypeList=get(mfTypeHndl,'String');
        if strcmp(fisType,'sugeno') & strcmp(varType,'output'),
            % Prepare sugeno mf type popup menu
            if size(mfTypeList,1)>2,
                set(mfTypeHndl,'String',get(mfTypeHndl,'UserData'));
                set(mfTypeHndl,'UserData',mfTypeList);
            end
            mfNameHndl=findobj(figNumber,'Type','uicontrol','Tag','mfname');
            mfName=localgetmfparam(fis, varType, varIndex, newCurrMF, 'name');
            
            set(mfNameHndl,'String',[' ' mfName],'Enable','on');
            
        else
            % Prepare mamdani mf type popup menu
            if size(mfTypeList,1)==2,
                set(mfTypeHndl,'String',get(mfTypeHndl,'UserData'));
                set(mfTypeHndl,'UserData',mfTypeList);
            end
            % Make the selected line bold
            currLineHndl=findobj(mainAxes,'Tag','mfline','UserData',newCurrMF);
            
            set(currLineHndl,'Color',selectColor);
            set(currLineHndl,'LineWidth',3);
            if helper.isInt(newCurrMF/2) % selected is Lower
                currLineHndlUpper=findobj(mainAxes,'Tag','mfline','UserData',newCurrMF-1);
                set(currLineHndlUpper,'LineWidth',3);
                set(currLineHndlUpper,'Color','r');
                currTxtHndlUpper=findobj(mainAxes,'Type','text','UserData',newCurrMF-1);
                set(currTxtHndlUpper,'Color','r','FontWeight','bold');
                mfName=localgetmfparam(fis, varType, varIndex, newCurrMF-1, 'name');
                % Set the MF name, type and params to the right value
                mfNameHndl=findobj(figNumber,'Type','uicontrol','Tag','mfname');
                set(mfNameHndl,'String',[' ' mfName],'Enable','on');
                % Set the MF name Lower
                mfName=localgetmfparam(fis, varType, varIndex, newCurrMF, 'name');
                mfNameHndl=findobj(figNumber,'Type','uicontrol','Tag','mfname Lower');
                set(mfNameHndl,'String',[' ' mfName],'Enable','off');
                
            else % selected is Upper
                currLineHndlLower=findobj(mainAxes,'Tag','mfline','UserData',newCurrMF+1);
                set(currLineHndlLower,'LineWidth',3);
                set(currLineHndlLower,'Color','r');
                currTxtHndlLower=findobj(mainAxes,'Type','text','UserData',newCurrMF+1);
                set(currTxtHndlLower,'Color','r','FontWeight','bold');
                mfName=localgetmfparam(fis, varType, varIndex, newCurrMF, 'name');
                % Set the MF name, type and params to the right value
                mfNameHndl=findobj(figNumber,'Type','uicontrol','Tag','mfname');
                set(mfNameHndl,'String',[' ' mfName],'Enable','on');
                % Set the MF name Lower
                mfName=localgetmfparam(fis, varType, varIndex, newCurrMF+1, 'name');
                mfNameHndl=findobj(figNumber,'Type','uicontrol','Tag','mfname Lower');
                set(mfNameHndl,'String',[' ' mfName],'Enable','off');
            end
        end
        
        % Make the selected text bold
        currTxtHndl=findobj(mainAxes,'Type','text','UserData',newCurrMF);
        set(currTxtHndl,'Color',selectColor,'FontWeight','bold');
        
        mfTypeList=get(mfTypeHndl,'String');
        mfTypeValue=helper.findrow(mfTypeUpper,mfTypeList);
        if isempty(mfTypeValue),
            mfTypeList=str2mat(mfTypeList, [' ' mfTypeUpper]);
            mfTypeValue=helper.findrow(mfTypeUpper,mfTypeList);
            set(mfTypeHndl,'String',mfTypeList,'Value',mfTypeValue);
            msgStr=['Installing custom membership function "' mfTypeUpper '"'];
            helper.statmsg(figNumber,msgStr);
        end
        set(mfTypeHndl,'Value',mfTypeValue,'Enable','on');
        
        % For Lower Membership Function
        if ~isequal(varType,'output')
            mfTypeHndlLower=findobj(figNumber,'Type','uicontrol','Tag','mftypelower');
            mfTypeList=get(mfTypeHndlLower,'String');
            mfTypeValue=helper.findrow(mfTypeLower,mfTypeList);
            if isempty(mfTypeValue),
                mfTypeList=str2mat(mfTypeList, [' ' mfTypeLower]);
                mfTypeValue=helper.findrow(mfTypeLower,mfTypeList);
                set(mfTypeHndlLower,'String',mfTypeList,'Value',mfTypeValue);
                msgStr=['Installing custom membership function "' mfTypeLower '"'];
                helper.statmsg(figNumber,msgStr);
            end
            set(mfTypeHndlLower,'Value',mfTypeValue,'Enable','on');
        end
        
        
        curr_info = get(gca, 'CurrentPoint');
        % Input
        if ~isequal(varType,'output')
            hndl=findobj(figNumber, 'Tag','mfparams');
            set(hndl,'String',[' ' mat2str(mfParamsUpper,4)],'Enable','on', ...
                'Userdata', [curr_info(1,1) mfParamsUpper]);
            
            hndl=findobj(figNumber, 'Tag','mfparams2');
            set(hndl,'String',[' ' mat2str(mfParamsLower,4)],'Enable','on', ...
                'Userdata', [curr_info(1,1) mfParamsLower]);
            
            hndl=findobj(figNumber,'Type','uimenu','Tag','removemf');
            set(hndl,'Enable','on');
        else % Output
            if strcmpi(mfTypeUpper, 'linear')
                hndl=findobj(figNumber, 'Tag','mfparams');
                set(hndl,'String',[' ' mat2str(mfParamsUpper(1:end/2),4)],'Enable','on', ...
                    'Userdata', [curr_info(1,1) mfParamsUpper(1:end/2)]);
                
                hndl=findobj(figNumber, 'Tag','mfparams2');
                set(hndl,'String',[' ' mat2str(mfParamsUpper(end/2+1:end),4)],'Enable','on', ...
                    'Userdata', [curr_info(1,1) mfParamsUpper(end/2+1:end)]);
                
                hndl=findobj(figNumber,'Type','uimenu','Tag','removemf');
                set(hndl,'Enable','on');
            else
                hndl=findobj(figNumber, 'Tag','mfparams');
                set(hndl,'String',[' ' mat2str(mfParamsUpper(1),4)],'Enable','on', ...
                    'Userdata', [curr_info(1,1) mfParamsUpper(1)]);
                
                hndl=findobj(figNumber, 'Tag','mfparams2');
                set(hndl,'String',[' ' mat2str(mfParamsUpper(2),4)],'Enable','on', ...
                    'Userdata', [curr_info(1,1) mfParamsUpper(2)]);
                
                hndl=findobj(figNumber,'Type','uimenu','Tag','removemf');
                set(hndl,'Enable','on');
            end
        end
    end
    % Reset the remove all mfs menuitem
    hndl=findobj(figNumber,'Type','uimenu','Tag','removeallmf');
    set(hndl,'Enable','on');
    if strcmp(varType,'output')
        try
            helper.setCrispInterval(fis.output(1).crisp);
        catch
            helper.setCrispInterval('crisp');   %% Edit1
        end
        end
    
end
end
%%% localgetmfparam %%%
function out = localgetmfparam(fis, varType, varNum, mfNum, param)
switch varType
    case 'input'
        switch param
            case 'name'
                out=fis.input(varNum).mf(mfNum).name;
            case 'type'
                out=fis.input(varNum).mf(mfNum).type;
            case 'params'
                out=fis.input(varNum).mf(mfNum).params;
        end
    case 'output'
        switch param
            case 'name'
                out=fis.output(varNum).mf(mfNum).name;
            case 'type'
                out=fis.output(varNum).mf(mfNum).type;
            case 'params'
                out=fis.output(varNum).mf(mfNum).params;
        end
        
end
end
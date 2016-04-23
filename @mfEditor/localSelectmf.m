function obj = localSelectmf(eventSrc,~,obj, selectColor)
% Called when a user btn downs on an mf and selects the first mf
% to be selected when a new input or output is plotted.
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
            for k=1:numel(mfParams)
                mfParamsUpper(1,k)= mfParams(k);
                % mfParamsLower=mfParamsUpper;
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
                set(mfNameHndl,'String',[' ' mfName],'Enable','on');
                
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
                set(mfNameHndl,'String',[' ' mfName],'Enable','on');
            end
        end
        
        % Make the selected text bold
        currTxtHndl=findobj(mainAxes,'Type','text','UserData',newCurrMF);
        set(currTxtHndl,'Color',selectColor,'FontWeight','bold');
        
        mfTypeList=get(mfTypeHndl,'String');
        mfTypeValue=findrow(mfTypeUpper,mfTypeList);
        if isempty(mfTypeValue),
            mfTypeList=str2mat(mfTypeList, [' ' mfTypeUpper]);
            mfTypeValue=findrow(mfTypeUpper,mfTypeList);
            set(mfTypeHndl,'String',mfTypeList,'Value',mfTypeValue);
            msgStr=['Installing custom membership function "' mfTypeUpper '"'];
            statmsg(figNumber,msgStr);
        end
        set(mfTypeHndl,'Value',mfTypeValue,'Enable','on');
        
        % For Lower Membership Function
        if ~isequal(varType,'output')
            mfTypeHndlLower=findobj(figNumber,'Type','uicontrol','Tag','mftypelower');
            mfTypeList=get(mfTypeHndlLower,'String');
            mfTypeValue=findrow(mfTypeLower,mfTypeList);
            if isempty(mfTypeValue),
                mfTypeList=str2mat(mfTypeList, [' ' mfTypeLower]);
                mfTypeValue=findrow(mfTypeLower,mfTypeList);
                set(mfTypeHndlLower,'String',mfTypeList,'Value',mfTypeValue);
                msgStr=['Installing custom membership function "' mfTypeLower '"'];
                statmsg(figNumber,msgStr);
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
    % Reset the remove all mfs menuitem
    hndl=findobj(figNumber,'Type','uimenu','Tag','removeallmf');
    set(hndl,'Enable','on');


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




function [ obj ] = mftype( ~,~,obj )
%MFTYPE Summary of this function goes here
%   Detailed explanation goes here
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
% Determine Upper or Lower Type selection
if isequal(get(gcbo,'tag'),'mftype')
    isUpper=1;
elseif isequal(get(gcbo,'tag'),'mftypelower')
    isUpper=0;
end

%====================================
figNumber=gcf;
HandlInterval = findobj('Tag', 'CheckboxInterval');
helper.isInterval=get(HandlInterval,'value');
%   mfTypeHndl=get(figNumber,'CurrentObject');
mfTypeHndl=gcbo;
fis=helper.getAppdata;
fisType=fis.type;
numInputs=length(fis.input);

% Is the current variable input or output?
currVarAxes=findobj(figNumber,'Type','axes','XColor',selectColor);
varIndex=get(currVarAxes,'UserData');
varType=get(currVarAxes,'Tag');
mainAxes=findobj(figNumber,'Type','axes','Tag','mainaxes');
%  currMF=get(mainAxes,'UserData');
param=get(mainAxes,'UserData');
if isequal(varType,'output')
    currMF=param.CurrMF;
else
    if isUpper % Type is upper
        if ~helper.isInt(param.CurrMF/2)
            currMF=param.CurrMF;
        elseif helper.isInt(param.CurrMF/2)
            currMF=param.CurrMF-1;
        end
        paramHndl=findobj(figNumber,'Tag','mfparams');
    else % Type is lower
        if ~helper.isInt(param.CurrMF/2)
            currMF=param.CurrMF+1;
        elseif helper.isInt(param.CurrMF/2)
            currMF=param.CurrMF;
        end
        paramHndl=findobj(figNumber,'Tag','mfparams2');
    end
end
if strcmp(varType,'input'),
    backgroundColor=inputColor;
else
    backgroundColor=outputColor;
end

typeList=get(mfTypeHndl,'String');
typeValue=get(mfTypeHndl,'Value');
newType=deblank(typeList(typeValue,:));
% Strip off the leading space
newType=fliplr(deblank(fliplr(newType)));
msgStr=['Changing type of "' fis.(varType)(varIndex).mf(currMF).name  '" to "' newType '"'];
statmsg(figNumber,msgStr);

% Now translate and insert the translated parameters
if strcmp(fisType,'sugeno') & strcmp(varType,'output'),
    % Handle the sugeno case
    oldParams=fis.(varType)(varIndex).mf(currMF).params;
    if strcmp(newType,'constant'),
        % Pick off only the constant term
        if  helper.isInterval
            newParamsUpper=oldParams(length(oldParams));
            fis.(varType)(varIndex).mf(currMF).type=newType;
            fis.(varType)(varIndex).mf(currMF).params=newParamsUpper;
            fis.(varType)(varIndex).mf(currMF).params(2,1)=newParamsUpper;
        else
            newParamsUpper=oldParams(length(oldParams));
            fis.(varType)(varIndex).mf(currMF).type=newType;
            fis.(varType)(varIndex).mf(currMF).params=newParamsUpper;
        end
    else % linear to be improved
        fis.(varType)(varIndex).mf(currMF).type=newType;
        %if length(oldParams)==2
        %if helper.isInterval
        fis.(varType)(varIndex).mf(currMF).params=[zeros(1,numInputs) oldParams(1)];
        for k=1:numInputs
            fis.(varType)(varIndex).mf(currMF).params(2,k)=0;
        end
        fis.(varType)(varIndex).mf(currMF).params(2,k+1)=1;
        %else
        %fis.(varType)(varIndex).mf(currMF).params=[zeros(1,numInputs) oldParams];
        %end
        %end
    end
    newParams=fis.(varType)(varIndex).mf(currMF).params;
    if helper.isInt(numel(newParams)/2)
        for k=1:numel(newParams)/2
            newParamsUpper(1,k)=newParams(1,k);
            newParamsLower=newParamsUpper;
        end
    else
        for k=1:numel(newParams)
            newParamsUpper(1,k)=newParams(1,k);
            newParamsLower=newParamsUpper;
        end
    end
    mfParamHndl=findobj(figNumber,'Type','uicontrol','Tag','mfparams');
    set(mfParamHndl,'String',[' ' mat2str(newParamsUpper,4)]);
    mfParamHndl2=findobj(figNumber,'Type','uicontrol','Tag','mfparams2');
    set(mfParamHndl2,'String',[' ' mat2str(newParamsLower,4)]);
    
    helper.setAppdata(fis);
else
    oldParams=fis.(varType)(varIndex).mf(currMF).params;
    oldType=fis.(varType)(varIndex).mf(currMF).type;
    oldType=deblank(oldType);
    newType=deblank(newType);
    varRange=fis.(varType)(varIndex).range;
    tol=1e-3*(varRange(2)-varRange(1));
    [newParamsUpper,errorStr]=mf2mf(oldParams,oldType,newType,tol);
    if helper.isInt(currMF/2)
        % newParamsUpper = helper.lowerMf(newParamsUpper,newType,varRange);
        newParamsUpper(end+1)=0.5;
    else
        newParamsUpper(end+1)=1;
    end
    if isempty(newParamsUpper),
        statmsg(figNumber,errorStr);
        set(paramHndl,'String',[' ' mat2str(oldParams,4)]);
        val=findrow(oldType,typeList);
        set(mfTypeHndl,'Value',val);
    else
        % Set the MF params to the right value
        set(paramHndl,'String',[' ' mat2str(newParamsUpper,4)]);
        
        % Replot the new curve
        lineHndl=findobj(mainAxes,'Tag','mfline','UserData',currMF);
        %       lineHndlList=findobj(mainAxes,'Type','mfline');
        %       for i=1:length(lineHndlList)
        %         thisparam=get(lineHndlList(i), 'UserData');
        %         if ~isempty(thisparam) & thisparam.CurrMF == currMF,
        %           lineHndl=lineHndlList(i);
        %          break;
        %         end
        %       end
        
        txtHndl=findobj(mainAxes,'Type','text','UserData',currMF);
        % First delete the old curve
        set(lineHndl,'Color',backgroundColor);
        set(txtHndl,'Color',backgroundColor);
        x=get(lineHndl,'XData');
        mfType=eval(['fis.' varType '(' num2str(varIndex) ').mf(' num2str(currMF) ').type']);
        
        try
            y=newParamsUpper(end)*evalmf(x,newParamsUpper(1:end-1),newType);
        catch ME
            y=nan(size(x));
        end
        
        set(lineHndl,'YData',y,'Color',selectColor);
        centerIndex=find(y==max(y));
        centerIndex=round(mean(centerIndex));
        txtPos=get(txtHndl,'Position');
        if ~isnan(centerIndex)
            txtPos(1)=x(centerIndex);
        end
        set(txtHndl,'Position',txtPos,'Color',selectColor);
        eval(['fis.' varType '(' num2str(varIndex) ').mf(' num2str(currMF) ').type=''' newType ''';']);
        eval(['fis.' varType '(' num2str(varIndex) ').mf(' num2str(currMF) ').params=' mat2str(newParamsUpper) ';']);
        helper.setAppdata(fis);
    end
    
end
obj=fill('','',obj);

end


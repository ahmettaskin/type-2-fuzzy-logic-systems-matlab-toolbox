function obj = mfparams( ~,~,obj )
%MFPARAMS Summary of this function goes here
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
        
        
        mfParamHndl = gcbo;
        figNumber=gcf;
        fis=helper.getAppdata;
        fisType=fis.type;
        
        % Is the current variable input or output?
        currVarAxes=findobj(figNumber,'Type','axes','XColor',selectColor);
        varIndex=get(currVarAxes,'UserData');
        varType=get(currVarAxes,'Tag');
        if strcmp(varType,'input'),
            backgroundColor=inputColor;
        else
            backgroundColor=outputColor;
        end
        mainAxes=findobj(figNumber,'Type','axes','Tag','mainaxes');
        param=get(mainAxes,'UserData');
        currMF=param.CurrMF;
        
        HandlParamsUpper = findobj('Tag', 'mfparams');
        % Read user input
        newParamStr=get(HandlParamsUpper,'String');
        % Params Edit Lower
        HandlParamsLower = findobj('Tag', 'mfparams2');
        newParamStrLower=get(HandlParamsLower,'String');
        if isempty(newParamStr)
            newParamsUpper = [];
            newParamsLower = [];
        else
            newParamsUpper = evalin('base',newParamStr,'[]');
            newParamsLower = evalin('base',newParamStrLower,'[]');
            if ~isreal(newParamsUpper)
                newParamsUpper = [];
                newParamsLower = [];
            else
                iscrisp=helper.setCrispInterval('iscrisp');
                newParamsUpper = reshape(newParamsUpper,[1 prod(size(newParamsUpper))]);
                if iscrisp
                    newParamsLower=newParamsUpper;
                else
                    newParamsLower = reshape(newParamsLower,[1 prod(size(newParamsLower))]);
                end
            end
        end
        
        isWarning = helper.compareMFs(fis,newParamsLower,newParamsUpper,currMF,varType,varIndex);
        if isWarning
            warndlg({'The upper MF grade values must always be bigger then the lower MF ones for any crisp input.';...
                ' ';...
                'Please check Params Upper and Params Lower!!'},'!! Warning!!');
            drawnow
            return
        end
        
        
        
        
        % ii = 1 for first membership function and ii = 2 for second msfnc
        for ii=1:2
            if ii==1
                if isequal(varType,'output')
                    newParamsUse=newParamsUpper;
                elseif ~helper.isInt(currMF/2) % Upper Membership Function
                    newParamsUse=newParamsUpper;
                elseif helper.isInt(currMF/2) % Lower Membership Function
                    newParamsUse=newParamsLower;
                end
            elseif ii==2                
                if isequal(varType,'output')
                    newParamsUse(1,2)=newParamsLower;
                elseif ~helper.isInt(currMF/2) % Upper Membership Function
                    newParamsUse=newParamsLower;
                    currMF=currMF+1;
                elseif helper.isInt(currMF/2) % Lower Membership Function
                    newParamsUse=newParamsUpper;
                    currMF=currMF-1;
                end
            end
            % Use the old parameters for error-checking
            RefStruct = substruct('.',varType,'()',{varIndex},'.','mf','()',{currMF});
            EditedMF = subsref(fis,RefStruct);
            oldParams = EditedMF.params;
            
            % Resolve length discrepancies for Sugeno outputs
            if length(newParamsUse)==1 & strcmpi(fisType,'sugeno') & strcmpi(varType,'output')
                newParamsUse = [zeros(1,length(fis.input)*strcmp(EditedMF.type,'linear')),newParamsUse];
            end
            
            % Update FIS data
            if 0%length(newParams)~=length(oldParams),
                % Back out change
                newParams = oldParams;
                msgStr = sprintf('Invalid parameter vector. No change made to MF %d',currMF);
            else
                % Send status message to the user
                msgStr=sprintf('Changing parameter for MF %d to %s',currMF,newParamStr);
                
                if strcmp(fisType,'sugeno') & strcmp(varType,'output'),
                    % Nothing to do for sugeno output case...
                    EditedMF.params = newParamsUse;
                    fis = subsasgn(fis,RefStruct,EditedMF);
                    helper.setAppdata(fis);
                else
                    lineHndl=findobj(mainAxes,'Type','line','UserData',currMF);
                    x=get(lineHndl,'XData');
                    try
                        y = newParamsUse(end)*evalmf(x,newParamsUse(1:end-1),EditedMF.type);
                        % New data OK. Update FIS
                        EditedMF.params = newParamsUse;
                        fis = subsasgn(fis,RefStruct,EditedMF);
                        % Replot the curve
                        txtHndl=findobj(mainAxes,'Type','text','UserData',currMF);
                        centerIndex=find(y==max(y));
                        centerIndex=round(mean(centerIndex));
                        txtPos=get(txtHndl,'Position');
                        if ~isnan(centerIndex)
                            txtPos(1) = x(centerIndex);
                            txtPos(2) = y(centerIndex) + 0.1;
                        end
                        set(txtHndl,'Position',txtPos,'Color',selectColor);
                        set(lineHndl,'YData',y,'Color',selectColor);
                        helper.setAppdata(fis);

                    catch ME
                        % There's been an error in the MF code, so don't change anything
                        uiwait(errordlg(sprintf('Invalid parameter vector. No change made to MF %s',EditedMF.type),'Membership Function Error', 'modal'))
                        newParamsUse=oldParams;
                    end
                end
            end
        end
        set(HandlParamsUpper,'String',[' ' mat2str(newParamsUpper,4)]);
        set(HandlParamsLower,'String',[' ' mat2str(newParamsLower,4)]);
        statmsg(figNumber,msgStr);
        obj=fill('','',obj);

end


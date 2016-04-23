function [ obj ] = deselectmf( obj , selectColor )
%DESELECTMF Summary of this function goes here
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
        
        
        figNumber=get(0,'CurrentFigure');
        
        currVarAxes=findobj(figNumber,'Type','axes','XColor',selectColor);
        varType=get(currVarAxes,'Tag');
        
        mainAxes=findobj(figNumber,'Type','axes','Tag','mainaxes');
        param=get(mainAxes,'UserData');
        currMF=param.CurrMF;
        for ii=1:2
            if ii==2 && helper.isInt(currMF/2)
                currMF = currMF-1;
            elseif ii==2
                currMF = currMF+1;
            end
            
            
            lineHndl=findobj(mainAxes,'Tag','mfline', 'UserData', currMF);
            %  for i=1:length(lineHndlList)
            %    thisparam=get(lineHndlList(i), 'UserData');
            %    if thisparam.CurrMF == currMF,
            %      lineHndl=lineHndlList(i);
            %      break;
            %    end
            %  end
            txtHndl=findobj(mainAxes,'Type','text','UserData',currMF);
            % Clear the current MF register
            param.CurrMF=-1;
            set(mainAxes,'UserData',param);
            
            if strcmp(varType,'input'),
                backgroundColor=inputColor;
            else
                backgroundColor=outputColor;
            end
            set(lineHndl,'Color',backgroundColor);
            set(lineHndl,'LineWidth',2);
            set(lineHndl,'Color',unselectColor);
            %    set(lineHndl, 'Tag', 'line');
            set(txtHndl,'Color',unselectColor,'FontWeight','normal');
            
            % Clean up the MF fields
            hndl=findobj(figNumber,'Type','uicontrol','Tag','mfname');
            if strcmp(get(hndl,'Enable'),'on'),
                set(hndl,'String',' ','Enable','off');
                hndl=findobj(figNumber,'Tag','mftype');
                set(hndl,'Value',1,'Enable','off');
                hndl=findobj(figNumber,'Type','uicontrol','Tag','mfparams');
                set(hndl,'String',' ','Enable','off');
                hndl=findobj(figNumber,'Type','uimenu','Tag','removemf');
                set(hndl,'Enable','off');
            end
        end

end


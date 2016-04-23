function [ obj ] = plotmfs( obj )
%PLOTMFS Summary of this function goes here
%   Detailed explanation goes here
%         figNumber=gcf;
%         mainAxes=findobj(figNumber,'Tag','mainaxes');
%         axes(mainAxes);
%         [x,y]=plotmships;
%
%
%         line(x,y, ...
%             'Color',[0 0 0], ...
%             'LineWidth',1, ...
%             'UserData',1, ...
%             'Tag', 'mfline',...
%             'ButtonDownFcn',{@localSelectmf [1 0 0]})

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
axes(mainAxes);
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
            'ButtonDownFcn',{@localSelectmf obj selectColor});
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
        line(x,y, ...
            'Color',unselectColor, ...
            'LineWidth',2, ...
            'UserData',mfIndex, ...
            'Tag', 'mfline',...
            'ButtonDownFcn',{@localSelectmf obj selectColor})
        centerIndex=find(y==max(y));
        centerIndex=round(mean(centerIndex));
        if ~isnan(centerIndex)
            text(x(centerIndex), 1.1*max(y) ,mfName, ...
                'HorizontalAlignment','center', ...
                'Color',unselectColor, ...
                'FontSize',8, ...
                'UserData',mfIndex, ...
                'Tag', 'mftext',...
                'ButtonDownFcn',{@localSelectmf obj selectColor});
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

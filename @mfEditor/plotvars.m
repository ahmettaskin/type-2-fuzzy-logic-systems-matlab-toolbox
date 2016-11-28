function [ obj ] = plotvars( obj )
%PLOTVARS Summary of this function goes here
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
figNumber=gcf;
fis=helper.getAppdata;

if isprop(fis, 'input')
    numInputs=length(fis.input);
else
    numInputs=0;
end
if isprop(fis, 'output')
    numOutputs=length(fis.output);
else
    numOutputs=0;
end

for i=1:numInputs
    if isfield(fis.input(i), 'mf')
        numInputMFs(i)=length(fis.input(i).mf);
    else
        numInputMFs(i)=0;
    end
end

for i=1:numOutputs
    if isfield(fis.output(i), 'mf')
        numOutputMFs(i)=length(fis.output(i).mf);
    else
        numOutputMFs(i)=0;
    end
end
if isprop(fis, 'rule')
    numRules=length(fis.rule);
else
    numRules=0;
end
fisName=fis.name;
fisType=fis.type;

mainAxHndl=gca;
mainAxHndl=findobj('tag','variables');
set(mainAxHndl,'Units','pixel','XTick',[],'YTick',[])
mainAxPos=get(mainAxHndl,'Position');
axis([mainAxPos(1) mainAxPos(1)+mainAxPos(3) ...
    mainAxPos(2) mainAxPos(2)+mainAxPos(4)]);
xCenter=mainAxPos(1)+mainAxPos(3)/2;
yCenter=mainAxPos(2)+mainAxPos(4)/2;
title('FIS Variables')
set(get(mainAxHndl,'Title'),'Visible','on','FontSize',8,'Color','black')

% Inputs first

if get(0,'ScreenDepth')>2,
    inputColor=[1 1 0.5];
    outputColor=[0.5 1 1];
else
    inputColor=[1 1 1];
    outputColor=[1 1 1];
end

tickColor=[0.5 0.5 0.5];

boxWid=(1/2)*mainAxPos(3);
boxHt=(1/(max(4,numInputs)))*mainAxPos(4);
xInset=boxWid/10;
yInset=boxHt/max([5,numInputs,numOutputs]);

xMin=-1; xMax=1;

for varIndex=1:numInputs,
    boxLft=mainAxPos(1);
    boxBtm=mainAxPos(2)+mainAxPos(4)-boxHt*varIndex;
    axPos=[boxLft+xInset boxBtm+yInset boxWid-2*xInset boxHt-2*yInset];
    
    varName=eval(['fis.input(' num2str(varIndex) ').name']);
    axName='input';
    if helper.isNewGraphics
        axHndl=axes( ...
            'Units','pixel', ...
            'Box','on', ...
            'XTick',[],'YTick',[], ...
            'XColor',tickColor,'YColor',tickColor, ...
            'YLim',[-0.1 1.1], ...
            'Color',inputColor, ...
            'Tag',axName, ...
            'UserData',varIndex, ...
            'Position',axPos,...
            'HitTest', 'off',...
            'PickableParts','visible');
    else
        axHndl=axes( ...
            'Units','pixel', ...
            'Box','on', ...
            'XTick',[],'YTick',[], ...
            'XColor',tickColor,'YColor',tickColor, ...
            'YLim',[-0.1 1.1], ...
            'Color',inputColor, ...
            'Tag',axName, ...
            'UserData',varIndex, ...
            'Position',axPos);
    end
    mfIndex=(1:numInputMFs(varIndex))+sum(numInputMFs(1:(varIndex-1)));
    colorOrder=get(gca,'ColorOrder');
    
    % Plot three cartoon membership functions in the box
    x=(-1:0.1:1)';
    y1=trimf(x,[-2 -1 0]); y2=trimf(x,[-1 0 1]); y3=trimf(x,[0 1 2]);
    xlineMatrix=[x x x x x x];
    ylineMatrix=[y1 y1*0.7 y2 y2*0.7 y3 y3*0.7];
    if helper.isNewGraphics
        line(xlineMatrix,ylineMatrix,'Color','black',...
            'PickableParts','visible',...
            'HitTest', 'on');
    else
        line(xlineMatrix,ylineMatrix,'Color','black');
    end
    hold on
    for k=1:2:5
        TestX=[xlineMatrix(:,k),flipud(xlineMatrix(:,k+1))];
        TestY=[ylineMatrix(:,k),flipud(ylineMatrix(:,k+1))];
        fill(TestX(1:end),TestY(1:end), [0.5 0.5 0.5],'facealpha',.5)
    end
    hold off
    
    xiInset=(xMax-xMin)/10;
    axis([xMin-xiInset xMax+xiInset -0.1 1.1])
    
    % Lay down a patch that simplifies clicking on the region
    patchHndl=patch([xMin xMax xMax xMin],[0 0 1 1],'black');
    if helper.isNewGraphics
        set(patchHndl, ...
            'EdgeColor','none', ...
            'FaceColor','none', ...
            'ButtonDownFcn',{@selectvar obj},...
            'PickableParts','all',...
            'HitTest','on');
    else
        set(patchHndl, ...
            'EdgeColor','none', ...
            'FaceColor','none', ...
            'ButtonDownFcn',{@selectvar obj});
    end
    
    % Now put on the variable name as a label
    xlabel(varName);
    labelName=[axName 'label'];
    set(get(axHndl,'XLabel'), ...
        'FontSize',8, ...
        'Color','black', ...
        'Tag',labelName);
end

% Now for the outputs
boxHt=(1/(max(4,numOutputs)))*mainAxPos(4);

for varIndex=1:numOutputs,
    boxLft=mainAxPos(1)+boxWid;
    boxBtm=mainAxPos(2)+mainAxPos(4)-boxHt*varIndex;
    axPos=[boxLft+xInset boxBtm+yInset boxWid-2*xInset boxHt-2*yInset];
    
    varName=eval(['fis.output(' num2str(varIndex) ').name']);
    axName='output';
    if helper.isNewGraphics
        axHndl=axes( ...
            'Units','pixel', ...
            'Box','on', ...
            'Color',outputColor, ...
            'XTick',[],'YTick',[], ...
            'XLim',[xMin xMax],'YLim',[-0.1 1.1], ...
            'XColor',tickColor,'YColor',tickColor, ...
            'Tag',axName, ...
            'UserData',varIndex, ...
            'Position',axPos,...
            'PickableParts','visible',...
            'HitTest','off');
    else
        axHndl=axes( ...
            'Units','pixel', ...
            'Box','on', ...
            'Color',outputColor, ...
            'XTick',[],'YTick',[], ...
            'XLim',[xMin xMax],'YLim',[-0.1 1.1], ...
            'XColor',tickColor,'YColor',tickColor, ...
            'Tag',axName, ...
            'UserData',varIndex, ...
            'Position',axPos);
    end
    mfIndex=(1:numOutputMFs(varIndex))+sum(numOutputMFs(1:(varIndex-1)));
    if ~strcmp(fisType,'sugeno'),
        % Only try to plot outputs it if it's not a Sugeno-style system
        x=[-1 -0.5 0 0.5 1]';
        xlineMatrix=[x x x];
        ylineMatrix=[0 1 0 0 0;0 0 1 0 0; 0 0 0 1 0]';
        if helper.isNewGraphics
            line(xlineMatrix,ylineMatrix,'Color','black',...
                'PickableParts','visible',...
                'HitTest', 'on');
        else
            line(xlineMatrix,ylineMatrix,'Color','black');
        end
        xoInset=(xMax-xMin)/10;
    else
        text(0,0.5,'f(u)', ...
            'FontSize',8, ...
            'Color','black', ...
            'HorizontalAlignment','center');
    end
    
    % Lay down a patch that simplifies clicking on the region
    patchHndl=patch([xMin xMax xMax xMin],[0 0 1 1],'black');
    if helper.isNewGraphics
        set(patchHndl, ...
            'EdgeColor','none', ...
            'FaceColor','none', ...
            'ButtonDownFcn',{@selectvar obj},...
            'PickableParts','all',...
            'HitTest','on');
    else
        set(patchHndl, ...
            'EdgeColor','none', ...
            'FaceColor','none', ...
            'ButtonDownFcn',{@selectvar obj});
    end
    
    xlabel(varName);
    labelName=[axName 'label'];
    set(get(axHndl,'XLabel'), ...
        'FontSize',8, ...
        'Color','black', ...
        'Tag',labelName);
end

hndlList=findobj(figNumber,'Units','pixels');
set(hndlList,'Units','normalized')
%mfedit2 selectvar

end

function [ obj ] = selectvar( ~,~,obj )

% colors
selectColor=[1 0 0];
figNumber=gcf;
fis=helper.getAppdata;
fisType=fis.type;
newCurrVarPatch=get(figNumber,'CurrentObject');
%   sss=get(newCurrVarPatch)
%   newCurrVarPatch = gcbo;
%   if isempty(newCurrVarPatch)| ~strcmp(get(newCurrVarPatch, 'Type'), 'patch')
%     newCurrVarPatch=findobj(figNumber, 'Tag', 'input1');
%   end
newCurrVar=get(newCurrVarPatch,'Parent');
if isempty(newCurrVar)
    newCurrVar=findobj('tag','input');
    newCurrVar=newCurrVar(1);
    if isempty(newCurrVar)
        newCurrVar=findobj('tag','input1');
        newCurrVar=newCurrVar(1);
    end
end
varIndex=get(newCurrVar,'UserData');

varType=get(newCurrVar,'Tag');
if isequal(varType,'input')
    varType='input';
else
    varType='output';
end
% Deselect all others if necessary
oldCurrVar=findobj(figNumber,'Type','axes','XColor',selectColor);
if newCurrVar~=oldCurrVar,
    set(oldCurrVar,'XColor','k','YColor','k');
    set(oldCurrVar,'LineWidth',1);
end

% Now hilight the new selection
set(newCurrVar,'XColor',selectColor,'YColor',selectColor);
set(newCurrVar,'LineWidth',3);

% Set all current variable display registers ...
dispRangeHndl=findobj(figNumber,'Type','uicontrol','Tag','disprange');
customHndl=findobj(figNumber,'Type','uimenu','Tag','addcustommf');

if strcmp(fisType,'sugeno') & strcmp(varType,'output'),
    % Handle sugeno case
    dispRangeStr=' ';
    set(dispRangeHndl,'String',dispRangeStr,'UserData',dispRangeStr, ...
        'Enable','off');
    set(customHndl,'Enable','off');
else
    dispRangeStr=[' ' mat2str(eval(['fis.' varType '(' num2str(varIndex) ').range']), 4)];
    set(dispRangeHndl,'String',dispRangeStr,'UserData',dispRangeStr, ...
        'Enable','on');
    set(customHndl,'Enable','on');
end

%         if strcmp(get(figNumber,'SelectionType'),'open'),
% %             error('dikkat et!')
%             fisgui #findgui
%         end

% The VARIABLE NAME text field
name='varname';
hndl=findobj(figNumber,'Type','uicontrol','Tag',name);

varName=eval(['fis.' varType '(' num2str(varIndex),').name']);
set(hndl,'String',varName);

% The VARIABLE TYPE text field
name='vartype';
hndl=findobj(figNumber,'Type','uicontrol','Tag',name);
set(hndl,'String',varType);

% The VARIABLE RANGE text field
name='varrange';
hndl=findobj(figNumber,'Type','uicontrol','Tag',name);
rangeStr=mat2str(eval(['fis.' varType '(' num2str(varIndex),').range']),4);
labelStr=[' ' rangeStr];
set(hndl,'String',labelStr);

statmsg(figNumber,['Selected variable "' varName '"']);

helper.setCrispInterval(varType);


obj=plotmfs(obj);
% Call localSelectmf to select first mf and populate mf text boxes
try
    localSelectmf([], [], selectColor);
end
%         paint_intervals

end


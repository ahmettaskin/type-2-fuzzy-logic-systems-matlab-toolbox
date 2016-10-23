function obj = plotFis( obj )
%PLOTFÝS Summary of this function goes here
%   Detailed explanation goes here
%=============================
selectColor = [1 0.3 0.3];
figNumber=gcf;
fis=helper.getAppdata;
set(figNumber,'Nextplot','replace')

numInputs=length(get_inputNames(fis));

numOutputs=length(get_outputNames(fis));

% numInputMFs=0;
% for k=1:numInputs,
%     numInputMFs=numInputMFs+length(fis.input(k));
% end;
% numOutputMFs=0;
% for k=1:numOutputs,
%     numOutputMFs=numOutputMFs+length(fis.output(k));
% end;

numRules=length(fis.rule);
ruleList=helper.getFis(fis, 'ruleList');
% ruleList=[];
fisName=fis.name;
fisType=fis.type;

mainAxHndl=findobj(figNumber,'tag','mainaxes');
set(mainAxHndl,'Units','pixel','Visible','off')
mainAxPos=get(mainAxHndl,'Position');
axis([mainAxPos(1) mainAxPos(1)+mainAxPos(3) ...
    mainAxPos(2) mainAxPos(2)+mainAxPos(4)]);
xCenter=mainAxPos(1)+mainAxPos(3)/2;
yCenter=mainAxPos(2)+mainAxPos(4)/2;
axList=[];

if get(0,'ScreenDepth')>2,
    inputColor=[1 1 0.5];
    outputColor=[0.5 1 1];
else
    inputColor=[1 1 1];
    outputColor=[1 1 1];
    set(gcf,'Color',[1 1 1])
end

% For plotting three cartoon membership functions in the box
xMin=-1; xMax=1;
x=(-1:0.1:1)';
y1=trimf(x,[-2 -1 0]); y2=trimf(x,[-1 0 1]); y3=trimf(x,[0 1 2]);
xlineMatrix=[x x x x x x];
ylineMatrix=[y1 y1*0.7 y2 y2*0.7 y3 y3*0.7];

% Inputs first
fontSize=8;
boxWid=(1/3)*mainAxPos(3);
xInset=boxWid/5;
if numInputs>0,
    boxHt=(1/(numInputs))*mainAxPos(4);
    yInset=boxHt/5;
end

for varIndex=1:numInputs,
    boxLft=mainAxPos(1);
    boxBtm=mainAxPos(2)+mainAxPos(4)-boxHt*varIndex;
    
    axPos=[boxLft+xInset boxBtm+yInset boxWid-2*xInset boxHt-2*yInset];
    
    % Draw the line that connects the input to the main block
    axes(mainAxHndl);
    % Make it a dotted line if the variable is not used in the rule base
    if numRules==0,
        lineStyle='--';
    elseif ~any((ruleList(:,varIndex))),
        lineStyle='--';
    else
        lineStyle='-';
    end
    xInputCenter=axPos(1)+axPos(3);
    yInputCenter=axPos(2)+axPos(4)/2;
    line([xInputCenter xCenter],[yInputCenter yCenter], ...
        'LineStyle',lineStyle, ...
        'LineWidth',2, ...
        'Color','black');
    % Now draw the little arrowhead on the line
    %    perpSlope=(xInputCenter-xCenter)/(yCenter-yInputCenter);
    %    arrowPt=[(xCenter+xInputCenter)/2 (yCenter+yInputCenter)/2];
    %    delta=(xCenter-xInputCenter)/10;
    %    line([xArrowPt xArrowPt
    inputNames=get_inputNames(fis);
    varName=inputNames(varIndex);
    axName=['input' num2str(varIndex)];
    axHndl=axes( ...
        'Units','pixel', ...
        'Box','on', ...
        'XTick',[],'YTick',[], ...
        'XLim',[xMin xMax],'YLim',[-0.1 1.1], ...
        'Color',inputColor, ...
        'Tag',axName, ...
        'UserData',varIndex, ...
        'Position',axPos);
    
    axList=[axList axHndl];
    
    line(xlineMatrix,ylineMatrix,'Color','black');
    hold on
    for k=1:2:5
        TestX=[xlineMatrix(:,k),flipud(xlineMatrix(:,k+1))];
        TestY=[ylineMatrix(:,k),flipud(ylineMatrix(:,k+1))];
        fill(TestX(1:end),TestY(1:end), [0.5 0.5 0.5],'facealpha',.5)
    end
    hold off
    %image(imread('MemberShipMask.jpg'))
    xiInset=(xMax-xMin)/10;
    axis([xMin-xiInset xMax+xiInset -0.1 1.1])
    %fill(x,y1, [0.5 0.5 0.5],'facealpha',.5)
    A = imread(which('InputMF.jpg'));
    %             % %              axes(axHndl);
    %                        imshow(A,[0 100],...
    %                              'Parent',axHndl);
    load spine
    %             figure
    %              image(X,...
    %              'Parent', axHndl,...
    %               'AlphaData',0.1)
    %             colormap(map)
    %             colormap(axHndl,map)
    %             set(figNumber, 'Colormap', A);
    
    % Lay down a patch that simplifies clicking on the region
    patchHndl=patch([xMin xMax xMax xMin],[0 0 1 1],'black');
    %             h = patchHndl;
    %             c = h.CData;
    %             h.CData = 'r';
    %image(imread('MemberShipMask.jpg'))
    set(patchHndl, ...
        'EdgeColor','none', ...
        'FaceColor','none', ...
        'UserData',struct('Index',varIndex,'Type','input','Handle',axHndl), ...
        'ButtonDownFcn', {@localSelectVar obj figNumber selectColor});
    %image(imread('MemberShipMask.jpg'))
    
    % Now put on the variable name as a label
    %        xlabel([varName ' (' num2str(numInputMFs(varIndex)) ')']);
    xlabel(varName,'FontSize',fontSize);
    labelName=[axName 'label'];
    set(get(axHndl,'XLabel'), ...
        'FontSize',fontSize, ...
        'Color','black', ...
        'Tag',labelName);
end

% Now for the outputs
if numOutputs>0,
    boxHt=(1/(numOutputs))*mainAxPos(4);
    yInset=boxHt/5;
end

for varIndex=1:numOutputs,
    boxLft=mainAxPos(1)+2*boxWid;
    boxBtm=mainAxPos(2)+mainAxPos(4)-boxHt*varIndex;
    axPos=[boxLft+xInset boxBtm+yInset boxWid-2*xInset boxHt-2*yInset];
    
    % Draw the line connect the center block to the output
    axes(mainAxHndl);
    % Make it a dotted line if the variable is not used in the rule base
    if numRules==0,
        lineStyle='--';
    elseif ~any(ruleList(:,varIndex+numInputs)),
        lineStyle='--';
    else
        lineStyle='-';
    end
    line([axPos(1) xCenter],[axPos(2)+axPos(4)/2 yCenter], ...
        'LineWidth',2, ...
        'LineStyle',lineStyle, ...
        'Color','black');
    outputNames=get_outputNames(fis);
    varName=outputNames(varIndex);
    
    axName=['output' num2str(varIndex)];
    axHndl=axes( ...
        'Units','pixel', ...
        'Box','on', ...
        'Color',outputColor, ...
        'XTick',[],'YTick',[], ...
        'Tag',axName, ...
        'UserData',varIndex, ...
        'Position',axPos);
    
    %set(axHndl,'UserData',struct('Index',varIndex,'Handle',axHndl);
    axList=[axList axHndl];
    if ~strcmp(fisType,'sugeno'),
        % Don't try to plot outputs it if it's a Sugeno-style system
        x=[-1 -0.5 0 0.5 1]';
        xlineMatrix=[x x x];
        ylineMatrix=[0 1 0 0 0;0 0 1 0 0; 0 0 0 1 0]';
        line(xlineMatrix,ylineMatrix,'Color','black');
        xoInset=(xMax-xMin)/10;
        axis([xMin-xoInset xMax+xoInset -0.1 1.1])
    else
        set(axHndl,'XLim',[xMin xMax],'YLim',[-0.1 1.1])
        text(0,0.5,'f(u)', ...
            'FontSize',fontSize, ...
            'Color','black', ...
            'HorizontalAlignment','center');
    end
    
    % Lay down a patch that simplifies clicking on the region
    patchHndl=patch([xMin xMax xMax xMin],[0 0 1 1],'black');
    set(patchHndl, ...
        'EdgeColor','none', ...
        'FaceColor','none', ...
        'UserData',struct('Index',varIndex,'Type','output','Handle',axHndl), ...
        'ButtonDownFcn', {@localSelectVar obj figNumber selectColor});
    
    %        xlabel([varName ' (' num2str(numOutputMFs(varIndex)) ')']);
    xlabel(varName,'FontSize',fontSize);
    labelName=[axName 'label'];
    set(get(axHndl,'XLabel'), ...
        'FontSize',fontSize, ...
        'Color','black', ...
        'Tag',labelName);
end

% Now draw the box in the middle
boxLft=mainAxPos(1)+boxWid;
boxBtm=mainAxPos(2);
boxHt=mainAxPos(4);
yInset=boxHt/4;
axPos=[boxLft+xInset boxBtm+yInset boxWid-2*xInset boxHt-2*yInset];
axHndl=axes( ...
    'Units','pixel', ...
    'Box','on', ...
    'XTick',[],'YTick',[], ...
    'YLim',[-1 1],'XLim',[-1 1], ...
    'XColor','black','YColor','black', ...
    'LineWidth',2, ...
    'ButtonDownFcn','ruleEditor;', ...
    'Color','white', ...
    'Position',axPos);
axList=[axList axHndl];
text(0,1/3,'Rule Editor', ...
    'Tag','fisname', ...
    'FontSize',fontSize, ...
    'Interpreter','none', ...
    'ButtonDownFcn','ruleEditor;', ...
    'Color','black', ...
    'HorizontalAlignment','center');
text(0,-1/3,['(' fisType ')'], ...
    'FontSize',fontSize, ...
    'ButtonDownFcn','ruleEditor;', ...
    'Color','black', ...
    'HorizontalAlignment','center');
%    text(0,-1/2,[num2str(numRules) ' rules'], ...
%        'ButtonDownFcn','fuzzy #openruleedit', ...
%               'FontSize',fontSize, ...
%               'Color','black', ...
%               'HorizontalAlignment','center');
set(get(axHndl,'Title'),'FontSize',fontSize,'Color','black');

for count=1:length(axList),
    axes(axList(count));
end
set(figNumber,'HandleVisibility','callback')

hndlList=findobj(figNumber,'Units','pixels');
set(hndlList,'Units','normalized')

% Ensure plot has been redrawn correctly
refresh(figNumber);

end


classdef ruleEditor
    properties
    end
    
    methods
        function obj = ruleEditor(action)
            %             if nargin<1,
            %                 newFis=newfis('Untitled');
            %                 newFis=addvar(newFis,'input','input1',[0 1],'init');
            %                 newFis=addvar(newFis,'output','output1',[0 1],'init');
            %                 action=newFis;
            %             end 
            ruleeditor = findall(0,'type','figure','Tag','ruleedit');
            if ~isempty(ruleeditor) && isequal(action,'initilaize')
                figure(ruleeditor);
                return
            end
            
            % Information for all objects
            frmColor=192/255*[1 1 1];
            btnColor=192/255*[1 1 1];
            popupColor=192/255*[1 1 1];
            editColor=255/255*[1 1 1];
            axColor=128/255*[1 1 1];
            border=.01;
            spacing=.01;
            figPos=get(0,'DefaultFigurePosition');
            maxRight=1;
            maxTop=1;
            btnWid=.14;
            btnHt=0.05;
            
            %====================================
            % The FIGURE
            thisfis{1}=helper.getAppdata;
            figNumber=figure( ...
                'Name',['Rule Editor'], ...
                'NumberTitle','off', ...
                'IntegerHandle','off',...
                'Color',frmColor, ...
                'MenuBar','none', ...
                'Visible','on', ...
                'UserData',thisfis, ...
                'Position',figPos, ...
                'Tag','ruleedit');
            figPos=get(figNumber,'position');
            
            %========================================================
            % The MAIN frame
            bottom=border;
            top=maxTop-border;
            right=maxRight-border;
            left=border;
            frmBorder=spacing;
            frmPos=[left-frmBorder bottom-frmBorder ...
                right-left+frmBorder*2 top-bottom+frmBorder*2];
            mainFrmHndl=uicontrol( ...
                'Units','normal', ...
                'Style','frame', ...
                'Position',frmPos, ...
                'BackgroundColor',frmColor);
            %====================================
            
            bottom=border+4*spacing+btnHt;
            % The RULES frame
            top=maxTop-border-spacing;
            right=maxRight-border-spacing;
            left=border+spacing;
            frmBorder=spacing;
            frmPos=[left-frmBorder bottom-frmBorder ...
                right-left+frmBorder*2 top-bottom+frmBorder*2];
            ruleFrmHndl=uicontrol( ...
                'Style','frame', ...
                'Units','normal', ...
                'Position',frmPos, ...
                'BackgroundColor',frmColor);
            %------------------------------------
            % The RULES edit window
            rulePos=[left top-(top-bottom)*2/5-border (right-left) (top-bottom)*2/5];
            %             if numRules>0,
            %                 labelStr=' ';
            %             else
            %                 labelStr=' ';
            %                 msgStr=['No rules for system "' fisName '"'];
            %                 helper.statmsg(figNumber,msgStr);
            %             end
            name='rulewindow';
            pos=[left bottom btnWid*2 btnHt];
            ruleHndl=uicontrol( ...
                'Style','listbox', ...
                'Units','normal', ...
                'Position',rulePos, ...
                'BackgroundColor',editColor, ...
                'HorizontalAlignment','left', ...
                'Max',1, ...
                'Tag',name);
            %========radio button for and, or=========
            frmPos=[left bottom ...
                btnWid+spacing btnHt*2.6];
            clsFrmHndl=uicontrol( ...
                'Style','frame', ...
                'Units','normal', ...
                'Position',frmPos, ...
                'BackgroundColor',frmColor);
            labelPos=[left+1*spacing bottom+btnHt*2 ...
                btnWid*.9 btnHt];
            clsFrmHndl=uicontrol( ...
                'Style','text', ...
                'Units','normal', ...
                'Position',labelPos, ...
                'String', 'Connection',...
                'BackgroundColor',frmColor);
            pos=[left+2*spacing bottom+1*spacing btnWid*.6 btnHt];
            helpHndl=uicontrol( ...
                'Style','radio', ...
                'Units','normal', ...
                'Position',pos, ...
                'BackgroundColor',btnColor, ...
                'String','and', ...
                'Tag', 'radio',...
                'Max', 1,...
                'Value', 1,...
                'Callback',{@radio obj});
            pos=[left+2*spacing bottom+btnHt+1*spacing btnWid*.6 btnHt];
            helpHndl=uicontrol( ...
                'Style','radio', ...
                'Units','normal', ...
                'Position',pos, ...
                'BackgroundColor',btnColor, ...
                'String','or', ...
                'Tag', 'radio',...
                'Max', 1,...
                'Callback',{@radio obj});
            %=====weight text=================
            frmPos=[left*9 bottom ...
                (btnWid+spacing)*0.8 btnHt*2.6];
            clsFrmHndl=uicontrol( ...
                'Style','frame', ...
                'Units','normal', ...
                'Position',frmPos, ...
                'BackgroundColor',frmColor);
            pos=[left+(btnWid)+btnHt/2+spacing bottom+btnHt*2 btnWid*.7 btnHt];
            helpHndl=uicontrol( ...
                'Style','text', ...
                'Units','normal', ...
                'Position',pos, ...
                'BackgroundColor',frmColor, ...
                'String','Weight');
            pos=[left+btnWid+btnHt bottom*1.4 btnWid/2 btnHt];
            helpHndl=uicontrol( ...
                'Style','edit', ...
                'Units','normal', ...
                'Position',pos, ...
                'BackgroundColor','white', ...
                'String',num2str(1),...
                'Callback', 'wStr=max(min(1, str2double(get(gcbo, ''String''))), 0); set(gcbo, ''string'', num2str(wStr))', ...
                'Tag', 'weight');
            %=========delete======================
            boxDstn=btnWid+spacing;
            boxWidth=(right-left)/6;
            pos=[left+boxDstn*2 bottom btnWid btnHt];
            helpHndl=uicontrol( ...
                'Style','pushbutton', ...
                'Units','normal', ...
                'Position',pos, ...
                'BackgroundColor',btnColor, ...
                'String','Clear all rules',...
                'Callback', {@clear obj},...
                'Tag', 'delete');
            %========button for add=========
            pos=[left+boxDstn*3 bottom btnWid btnHt];
            helpHndl=uicontrol( ...
                'Style','push', ...
                'Units','normal', ...
                'Position',pos, ...
                'BackgroundColor',btnColor, ...
                'String','Add rule', ...
                'Callback', {@add obj});
            %====================================
            % The CLOSE frame
            bottom=border+4*spacing+btnHt;
            top=bottom+btnHt;
            right=maxRight-border-spacing;
            % Left should be snug up against Rule Format frame
            left=border+spacing;
            
            frmBorder=spacing;
            
            %The CLOSE button
            closeHndl=uicontrol( ...
                'Style','push', ...
                'Units','normal', ...
                'Position',[right-btnWid bottom btnWid btnHt], ...
                'BackgroundColor',btnColor, ...
                'String','Close', ...
                'Callback',{@closeFig obj});
            update(obj);
            % Normalize all coordinates
            hndlList=findobj(figNumber,'Units','pixels');
            set(hndlList,'Units','normalized');
            
            % Uncover the figure
            %             thisfis{1}=helper.getAppdata;
            %             set(figNumber, ...
            %                 'Visible','on', ...
            %                 'UserData',thisfis, ...
            %                 'HandleVisibility','callback');
            %%init
            %             index=1;
            %             localGetRule(obj, figNumber, index, helper.getAppdata);
        end
    end
end
function obj = add(~,~,obj)
thisact=get(gcbo, 'String');
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

errflag=1;                  %assume errflag=true
sentence='if ';
radioHndl=findobj(gcbf, 'Tag', 'radio');
conn=2;
for i=1:length(radioHndl)
    if get(radioHndl(i),'Value')~=0
        connStr=get(radioHndl(i),'String');
        if strcmp(connStr, 'and')
            conn=1;
        end
        break;
    end
end
for i=1:numInputs
    nameHndl=findobj(gcbf, 'Tag', ['ruleinmake' num2str(i)]);
    notHndl=findobj(gcbf, 'Tag', ['ruleinradio' num2str(i)]);
    if get(notHndl, 'Value')==0
        notvalue=1;
    else
        notvalue=-1;
    end
    value=get(nameHndl, 'Value');
    if value>length(fis.input(i).mf) %| ~isempty(fis.input(i).mf)
        str(i)=0;
    else
        str(i)=value*notvalue;
        errflag=0;
    end
end
if errflag==0,
    errflag=1;
    for i=1:numOutputs
        nameHndl=findobj(gcbf, 'Tag', ['ruleoutmake' num2str(i)]);
        notHndl=findobj(gcbf, 'Tag', ['ruleoutradio' num2str(i)]);
        if get(notHndl, 'Value')==0
            notvalue= 1;
        else
            notvalue=-1;
        end
        value=get(nameHndl, 'Value');
        if value>length(fis.output(i).mf) %| ~isempty(fis.output(i).mf)
            str(numInputs+i) = 0;
        else
            str(numInputs+i)=value*notvalue;
            errflag=0;
        end
        
    end
end
if errflag==0;
    weightHndl=findobj(gcbf, 'tag', 'weight');
    weight=get(weightHndl, 'String');
    
    ruleHndl=findobj(gcbf, 'tag', 'rulewindow');
    if isempty(str2double(weight))
        wght=1;
    else
        wght=max(min(str2double(weight), 1), 0);
    end
    if strcmp(thisact, 'Add rule')
        index=length(fis.rule)+1;
        statusStr='added';
    else
        index=get(ruleHndl, 'Value');
        statusStr='changed';
    end
    fis.rule(index).antecedent=str(1:numInputs);
    fis.rule(index).consequent=str(numInputs+1:end);
    fis.rule(index).weight=wght;
    fis.rule(index).connection=conn;
    if length(fis.rule)~=0
        delHndl=findobj(gcbf, 'Tag', 'delete');
        set(delHndl, 'Enable', 'on');
    end
    helper.setAppdata(fis)
    %formatHndl=findobj(gcbf,'Type','uimenu','Tag','rulefrmt', 'Checked','on');
    %langHndl=findobj(gcbf,'Type','uimenu', 'Tag', 'lang', 'Checked','on');
    thisrule=showRule(obj,fis,1:length(fis.rule));
    set(ruleHndl,'String', thisrule, 'value', index);
    statusHndl=findobj(gcbf, 'Tag', 'status');
    set(statusHndl, 'String', ['The rule is ' statusStr]);
else
    statusHndl=findobj(gcbf, 'Tag', 'status');
    set(statusHndl, 'String', 'The rule is incomplete');
end
end

function obj = clear(~,~,obj)
fis=helper.getAppdata;
fis.clearAllRules;
update(obj);
end

function obj = closeFig(~,~,obj)
fig=findall(0,'type','figure','Tag','ruleedit');
close(fig);
figure(findall(0,'type','figure','Tag','fuzzyt2'));
end
function tf=setCrispInterval(cmd)
figNumber=gcf;
%% Upper Membership Function Handles
% Name String Upper
HandlNameUpperstr=findobj('String','Name ');
if isempty(HandlNameUpperstr)
    HandlNameUpperstr=findobj('String','Name Upper');
end
% Name Edit Upper
HandlNameUpperEdit=findobj('tag','mfname');
% Params String Upper
HandlParams1str=findobj('String','Params');
if isempty(HandlParams1str)
    HandlParams1str=findobj('String','Params Upper');
end
% Params Edit Upper
HandlParamsUpper = findobj('Tag', 'mfparams');
% Type String Upper
HandlTypeUpperstr=findobj('String','Type ');
if isempty(HandlTypeUpperstr)
    HandlTypeUpperstr=findobj('String','Type Upper');
end
% Type Edit Upper
HandlTypeUpperEdit=findobj('tag','mftype');
% Frame Upper
HandlTypeUpperFrame=findobj('tag','UpperFrame');



%% Lower Membership Function Handles
% Name String Lower
HandlNameLowerstr=findobj('String','Name Lower');
% Name Edit  Lower
HandlParamsLowerEdit = findobj('Tag', 'mfname Lower');
% Params String Lower
HandlParams2str=findobj('String','Params Lower');
% Params Edit Lower
HandlParamsLower = findobj('Tag', 'mfparams2');
% Type String Lower
HandlTypeLowerstr=findobj('String','Type Lower');
% Type Edit Lower
HandlTypeLowerEdit=findobj('tag','mftypelower');
% Frame Lower
HandlTypeLowerFrame=findobj('tag','LowerFrame');

%% Output Page Selections
HandlCrisp = findobj('Tag', 'CheckboxCrips');
HandlInterval = findobj('Tag', 'CheckboxInterval');
HandlCrispText = findobj('String', 'Choose Output Type');
crispval=get(HandlCrisp,'value');
intval=get(HandlInterval,'value');

%% Grid Selection
HandlGridOn = findobj('Tag', 'gridon');
HandlGridOff = findobj('Tag', 'gridoff');
HandlGridFrame = findobj('Tag', 'GridFrame');
HandlGridText = findobj('String', 'Grid');
fis=helper.getAppdata;

switch cmd
    case 'crisp'
        set(HandlInterval,'value',0);
        set(HandlCrisp,'value',1);
        intval=get(HandlInterval,'value');
        fis.output.crisp='crisp';
        helper.setAppdata(fis);
    case 'interval'
        set(HandlInterval,'value',1);
        set(HandlCrisp,'value',0);
        crispval=get(HandlCrisp,'value');
        fis.output.crisp='interval';
        helper.setAppdata(fis);
    case 'input'
        %% Upper Membership Function Handles
        % Name String Upper
        set(HandlNameUpperstr,'position',[0.45 0.3 0.2 0.03],...
            'string','Name Upper',...
            'visible','on')
        % Name Edit Upper
        set(HandlNameUpperEdit,'position',[0.75 0.3 0.1 0.03],...
            'visible','on')
        % Params String Upper
        set(HandlParams1str,'String','Params Upper',...
            'position',[0.45 0.26 0.2 0.03],...
            'visible','on')
        % Params Edit Upper
        set(HandlParamsUpper,'position',[0.6 0.26 0.25 0.03],...
            'visible','on')
        % Type String Upper
        set(HandlTypeUpperstr,'position',[0.45 0.22 0.15 0.03],...
            'string','Type Upper',...
            'visible','on')
        % Type Edit Upper
        set(HandlTypeUpperEdit,'position',[0.75 0.22 0.1 0.03],...
            'visible','on')
        % Frame Upper
        set(HandlTypeUpperFrame,'position',[0.43 0.2 0.44 0.15],...
            'visible','on')
        
        
        %% Lower Membership Function Handles
        % Name String Lower
        set(HandlNameLowerstr,'position',[0.45 0.14 0.15 0.03],...
            'visible','on')
        % Name Edit  Lower
        set(HandlParamsLowerEdit,'position',[0.75 0.14 0.1 0.03],...
            'visible','on')
        % Params String Lower
        set(HandlParams2str,'position',[0.45 0.1 0.15 0.03],...
            'visible','on')
        % Params Edit Lower
        set(HandlParamsLower,'position',[0.6 0.1 0.25 0.03],...
            'visible','on')
        % Type String Lower
        set(HandlTypeLowerstr,'position',[0.45 0.06 0.15 0.03],...
            'visible','on')
        % Type Edit Lower
        set(HandlTypeLowerEdit,'position',[0.75 0.06 0.1 0.03],...
            'visible','on')
        % Frame Lower
        set(HandlTypeLowerFrame,'position',[0.43 0.04 0.44 0.15],...
            'visible','on')
        
        
        %% Grid visible
        set(HandlGridOn,'visible','on')
        set(HandlGridOff,'visible','on')
        set(HandlGridFrame,'visible','on')
        set(HandlGridText,'visible','on')
        
        %% Crisp Interval
        set(HandlCrisp,'visible','off')
        set(HandlInterval,'visible','off')
        set(HandlCrispText,'visible','off')
        
        return
    case 'output'
        %% Upper Membership Function Handles
        % Name String Upper
        set(HandlNameUpperstr,'position',[0.45 0.2 0.2 0.03],...
            'string','Name ',...
            'visible','on')
        % Name Edit Upper
        set(HandlNameUpperEdit,'position',[0.75 0.2 0.1 0.03],...
            'visible','on')
        % Params String Upper
        set(HandlParams1str,'position',[0.45 0.11 0.2 0.03],...
            'visible','on')
        % Params Edit Upper
        set(HandlParamsUpper,'position',[0.6 0.11 0.25 0.03],...
            'visible','on')
        % Type String Upper
        set(HandlTypeUpperstr,'position',[0.45 0.16 0.15 0.03],...
            'string','Type ',...
            'visible','on')
        % Type Edit Upper
        set(HandlTypeUpperEdit,'position',[0.75 0.16 0.1 0.03],...
            'visible','on')
        % Frame Upper
        set(HandlTypeUpperFrame,'position',[0.56 0.25 0.24 0.09],...
            'visible','on')
        
        %% Lower Membership Function Handles
        % Name String Lower
        set(HandlNameLowerstr,'position',[0.45 0.14 0.15 0.03],...
            'visible','off')
        % Name Edit  Lower
        set(HandlParamsLowerEdit,'position',[0.75 0.14 0.1 0.03],...
            'visible','off')
        % Params String Lower
        set(HandlParams2str,'position',[0.45 0.07 0.15 0.03],...
            'visible','off')
        % Params Edit Lower
        set(HandlParamsLower,'position',[0.6 0.07 0.25 0.03],...
            'visible','off')
        % Type String Lower
        set(HandlTypeLowerstr,'position',[0.45 0.06 0.15 0.03],...
            'visible','off')
        % Type Edit Lower
        set(HandlTypeLowerEdit,'position',[0.75 0.06 0.1 0.03],...
            'visible','off')
        % Frame Lower
        set(HandlTypeLowerFrame,'position',[0.43 0.06 0.45 0.18],...
            'visible','on')
        
        %% Grid visible
        set(HandlGridOn,'visible','off')
        set(HandlGridOff,'visible','off')
        set(HandlGridFrame,'visible','off')
        set(HandlGridText,'visible','off')
        
        %% Crisp Interval
        set(HandlCrisp,'visible','on',...
            'position',[0.58,0.26,0.09,0.04])
        set(HandlInterval,'visible','on',...
            'position',[0.7,0.26,0.09,0.04])
        set(HandlCrispText,'visible','on')
        return
    case 'iscrisp'
        crispval=get(HandlCrisp,'value');
        if crispval
            tf=true;
        else
            tf=false;
        end
        return
end

if intval
    set(HandlParamsLower,'visible','on')
    set(HandlParams2str,'visible','on')
    set(HandlParams1str,'String','Params Upper')
elseif crispval
    set(HandlParamsLower,'visible','off')
    set(HandlParams2str,'visible','off')
    set(HandlParams1str,'String','Params')
    %mfedit2('mfparams');
elseif ~intval && ~crispval
    set(HandlCrisp,'value',1)
    set(HandlParamsLower,'visible','off')
    set(HandlParams2str,'visible','off')
end
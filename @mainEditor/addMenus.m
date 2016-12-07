function  obj=addMenus(obj)
%ADDMENUS Summary of this function goes here
%   Detailed explanation goes here
       %% get figure handle
        hFuzzy=findall(0,'tag','fuzzyt2');
        %% File
        fileHndl=uimenu(hFuzzy,...
            'Label','File');
        h = uimenu('Parent',fileHndl, ...
            'Label', 'New FIS...');
        %         uimenu('Parent',h, ...
        %             'Label', 'Mamdani', ...
        %             'Tag', 'newmamdani',...
        %             'Callback','');
        uimenu('Parent', h, ...
            'Label', 'Sugeno', ...
            'Callback','');
        % File submenu item Import
        h = uimenu('Parent', fileHndl,'Label', 'Load', ...
            'Separator','on');
        uimenu('Parent',h,'Label', 'From File...', ...
            'Tag', 'openfis',...            
            'Accelerator', 'O', ...
            'Callback',{@loadFromFile obj});
        uimenu('Parent',h,'Label', 'From Workspace...', ...
            'Tag', 'openfis',...
            'Callback',{@loadFromWs obj});
        % File submenu item Export
        h = uimenu('Parent', fileHndl,'Label', 'Save');
        uimenu('Parent',h,'Label', 'To Workspace...', ...
            'Accelerator', 'T', ...
            'Callback', {@saveWs obj});
        uimenu('Parent',h,'Label', 'To File...', ...
            'Tag', 'save',...            
            'Accelerator', 'S', ...
            'Callback',{@saveFile obj});
        % File submenu item Print
        %         uimenu(fileHndl,'Label', 'Print', ...
        %             'Separator','on', ...
        %             'Callback','');
        %         % File submenu item Close
        %         uimenu(fileHndl,'Label', 'Close', ...
        %             'Separator','on', ...
        %             'Callback','');
        
        %% Edit
        h1 = uimenu(hFuzzy, ...
            'Label','Edit');
        %         uimenu(h1, ...
        %             'Callback','', ...
        %             'Label','Open MUT');
        h2 = uimenu('Parent', h1,'Label', 'Add Variable...');
        uimenu(h2, ...
            'Tag','menu_input',...
            'Callback',{@add_input obj},...
            'Label','Input');
        uimenu(h2, ...
            'Tag','menu_output',...
            'Callback',{@add_output obj},...
            'Label','Output');
        %         uimenu(h1, ...
        %             'Callback','', ...
        %             'Label','Remove Selected Variable');
        %         uimenu(h1, ...
        %             'Callback','', ...
        %             'Label','Membership Functions...');
        uimenu(h1, ...
            'Callback','ruleEditor;', ...
            'Label','Rules...');
        
        
        %% View
        h1 = uimenu(hFuzzy, ...
            'Label','View');
        uimenu(h1, ...
            'Callback','', ...
            'Label','Rules');
        uimenu(h1, ...
            'Callback','helper.viewSurface', ...
            'Label','Surface');

end

function obj = add_input(~, ~, obj)
%ADD_ÝNPUT Summary of this function goes here
%   Detailed explanation goes here

fis=helper.getAppdata;
% add_input(fis);

addVar(obj,'input');
plotFis(obj);
end

function obj = add_output(~, ~, obj)
%ADD_ÝNPUT Summary of this function goes here
%   Detailed explanation goes here

fis=helper.getAppdata;
% add_input(fis);

addVar(obj,'output');
plotFis(obj);
end

function obj = saveWs(~, ~, obj)
%SAVEWS Summary of this function goes here
%   Detailed explanation goes here

%% Load t2fis
hFig = findall(0,'tag','fuzzyt2');
t2fis=get(hFig,'userdata');
t2fis=t2fis{1};
answer=inputdlg({'name of t2fis'},'name',1,{'t2fis'});
drawnow;
if isempty(answer)
    disp('user cancelled')
    return
end



assignin('base', answer{1}, t2fis)

end

function obj = loadFromFile(~, ~, obj)
%LOADFROMFÝLE Summary of this function goes here
%   Detailed explanation goes here
    [loadfis,path]=uigetfile('*.t2fis','Select your t2fis file');
    if isequal(loadfis,0)
        return
    end
    newfis=readt2fis(loadfis,path);
    hFuzzy=findall(0,'Tag','fuzzyt2');
    close(hFuzzy)
    mainEditor(newfis);

end

function obj = loadFromWs(~, ~, obj)
%LOADFROMWS Summary of this function goes here
%   Detailed explanation goes here

prompt={'Workspace file:'};
    name='T2FIS';
    numlines=1;
    defaultanswer={''};
    answer=inputdlg(prompt,name,numlines,defaultanswer);
    drawnow;
    if isempty(answer)
        return
    end
    newIt2fls=evalin('base',answer{1,1});
    hFuzzy=findall(0,'Tag','fuzzyt2');
    close(hFuzzy)
    command='new';
end

function obj = saveFile(~, ~, obj)

helper.saveFile(obj,'save','');

end


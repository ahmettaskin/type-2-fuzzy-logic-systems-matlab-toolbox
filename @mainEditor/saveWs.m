function obj = saveWs(~,~,obj)
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

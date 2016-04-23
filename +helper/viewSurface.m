function viewSurface

%% If opened close and reopen again to refresh
hSurface=findobj(0,'tag','surface');
if ~isempty(hSurface)
    close(hSurface)
end

% Find opened figure to load user data
hMainFig = findall(0,'tag','fuzzyt2');
if isempty(hMainFig)
    hMainFig=findall(0,'tag','mfEditor');
    if isempty(hMainFig)
        hMainFig=findall(0,'tag','ruleedit');
        if isempty(hMainFig)
            % If any figure did not opened, return
            disp('Please open toolbox first.')
            return
        end
    end
end
% Load user data to view surface
t2fis=helper.getAppdata;

prompt={'Input 1 Range','Input 2 Range','Plot Points'};
name='Input for license parameters';
numlines=1;
defaultanswer={'[-1 1]','[-1 1]','49'};
% answer=inputdlg(prompt,name,numlines,defaultanswer);
% drawnow;
answer=defaultanswer';

RangeInp1=evalin('base',answer{1},'[]');
diffRange1=RangeInp1(2)-RangeInp1(1);
RangeInp2=evalin('base',answer{2},'[]');
diffRange2=RangeInp2(2)-RangeInp2(1);
plotpoints=evalin('base',answer{3},'[]');

if diffRange1<=0 || diffRange2<=0
    warndlg('Please check your range for inputs','Wrong Range Input')
    return
end



Input1=RangeInp1(1):(diffRange1/plotpoints):RangeInp1(2);
Input2=RangeInp2(1):(diffRange2/plotpoints):RangeInp2(2);

[Input1M,Input2M]=meshgrid(Input1,Input2);

% zz=cell(numel(y),numel(x));
try
    for i=1:numel(Input2)
        for j=1:numel(Input1)
            Output(i,j)= evalt2(t2fis,[Input1M(i,j) Input2M(i,j)]);
        end
    end
catch exc
    disp(exc.message)
    warndlg('Please check your design and Rule  Editor.')
    return
end

hSurface = figure('Color',[0.8 0.8 0.8],...
    'Tag','surface', ...
    'NumberTitle','off', ...
    'Visible','on',...
    'Name','Surface Viewer');
rotate3d on
% set(hSurface, 'WindowStyle', 'docked')
% setFigDockGroup(hSurface, 'Interval Type-2 Fuzzy Logic Systems Toolbox');

% figure('Title','surface');
surf(Input1M,Input2M,Output);
title('Surface of Interval Type2 Fuzzy Logic Design')
xlabel('Input 1')
ylabel('Input 2')
zlabel('Output')
axis tight
shading interp
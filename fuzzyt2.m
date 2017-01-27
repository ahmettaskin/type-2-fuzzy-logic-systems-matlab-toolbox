function fuzzyt2()
%% add path
hpath=fileparts(mfilename('fullpath'));
addpath(hpath)
%addpath([hpath,'\Type2_Functions'])
addpath([hpath,'\Read_Eval_Functions'])
addpath([hpath,'\Simulink_Lib'])
addpath([hpath,'\Images'])

%% add shortcuts
helper.addShortcuts;

%% Open Type2 Fuzzy Toolbox
mainEditor;
% mEditor = addMenus(mEditor);
% mEditor = plotFis(mEditor);
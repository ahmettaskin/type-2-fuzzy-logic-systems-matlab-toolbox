function fuzzyt2()
%FUZZYT2 
%
% SYNTAX: 
%     fuzzyt2(...) 
%
% INPUTS: 
%    
% OUTPUTS:
%    
% EXAMPLE :
%    
% See also 

% Copyright (c) AVL Software and Functions GmbH 2014 
% $Revision: 1.10 $, $Date: 2014/02/19 10:20:06VET $ by $Author: Dalon Thierry RGB (DALONT) $ 

% Calls: 

%% add path 
hpath=fileparts(mfilename('fullpath'));
addpath(hpath)
addpath([hpath,'\Type2_Functions'])
addpath([hpath,'\Read_Eval_Functions'])
addpath([hpath,'\Simulink_Lib'])
addpath([hpath,'\Images'])

%% add shortcuts
helper.addShortcuts;

%% Open Type2 Fuzzy Toolbox
mEditor = mainEditor;
% mEditor = addMenus(mEditor);
% mEditor = plotFis(mEditor);



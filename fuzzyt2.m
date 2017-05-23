%  IT2-FLS Toolbox is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
% 
%     IT2-FLS Toolbox is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
% 
%     You should have received a copy of the GNU General Public License
%     along with IT2-FLS Toolbox.  If not, see <http://www.gnu.org/licenses/>.
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
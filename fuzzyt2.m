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
addpath([hpath,'\Read_Eval_Functions'])
addpath([hpath,'\Simulink_Lib'])
addpath([hpath,'\Images'])

%% add shortcuts
helper.addShortcuts;

%% Simple example IT2-FLS Toolbox
% load t2fis file, check the Examples\ExampleFiles folder for examples
t2fis=readt2fis('test.t2fis') % creates a Structure array 
x=[0.1,0.5]; %input vector
y=evalt2(x,t2fis) % output of IT2-FLS
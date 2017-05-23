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
function obj = add_output( obj, name, range, nOfMfs , type)
if nargin<5
    type = 'sugeno';
end

if ~isprop(obj.output,name)
    obj.output.(name) = struct('name',[],...
            'range',[],...
            'mfs',[]);
end
obj.output.(name).name = name;
obj.output.(name).range = range;
length=range(2) - range(1);
step=length/nOfMfs-1;

for i=1:nOfMfs
    obj.output.(name).mfs.(['mf' num2str(i)]).range=range;
    obj.output.(name).mfs.(['mf' num2str(i)]).upper.type='constant';
    obj.output.(name).mfs.(['mf' num2str(i)]).upper.values=-1+(i-1)*step;
    
    obj.output.(name).mfs.(['mf' num2str(i)]).lower.type='constant';    
    obj.output.(name).mfs.(['mf' num2str(i)]).lower.values=-1+(i-1)*step;
    
    
end


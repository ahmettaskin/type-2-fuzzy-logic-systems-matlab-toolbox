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
function blkStruct = slblocks  
Browser(1).Library = 'Fuzzy_Type2_Lib';
Browser(1).Name    = 'Interval Type-2 Fuzzy Logic Systems Toolbox';
Browser(1).IsFlat  = 0;% Is this library "flat" (i.e. no subsystems)?
blkStruct.Browser = Browser;
clear Browser;
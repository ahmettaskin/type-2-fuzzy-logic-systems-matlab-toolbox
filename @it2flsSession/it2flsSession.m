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
classdef it2flsSession  
    properties (Access = public)
        name;
        type;
        andMethod;
        orMethod;
        defuzzMethod;
        impMethod;
        aggMethod;
        typeRedMethod;
        input
        output
        rule
    end
    methods
        function obj=it2flsSession(fis)
            if nargin==0
                obj.name = 'default';
                obj.type = 'sugeno';
                obj.andMethod = 'prod';
                obj.orMethod = 'probor';
                obj.defuzzMethod = 'wtaver';
                obj.impMethod = 'prod';
                obj.aggMethod = 'sum';
                obj.typeRedMethod = 'Karnik-Mendel';
                obj.input = [];
                obj.output = [];
                obj.rule = [];
            else
                obj.name = fis.name;
                obj.type = fis.type;
                obj.andMethod = fis.andMethod;
                obj.orMethod = fis.orMethod;
                obj.defuzzMethod = fis.defuzzMethod;
                obj.impMethod = fis.impMethod;
                obj.aggMethod = fis.aggMethod;
                obj.typeRedMethod = fis.typeRedMethod;
                obj.input = fis.input;
                obj.output = fis.output;
                obj.rule = fis.rule;
            end
        end
    end
end


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


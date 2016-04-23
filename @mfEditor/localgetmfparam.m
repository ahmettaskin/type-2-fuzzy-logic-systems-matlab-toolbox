function out = localgetmfparam(fis, varType, varNum, mfNum, param)
switch varType
    case 'input'
        switch param
            case 'name'
                out=fis.input(varNum).mf(mfNum).name;
            case 'type'
                out=fis.input(varNum).mf(mfNum).type;
            case 'params'
                out=fis.input(varNum).mf(mfNum).params;
        end
    case 'output'
        switch param
            case 'name'
                out=fis.output(varNum).mf(mfNum).name;
            case 'type'
                out=fis.output(varNum).mf(mfNum).type;
            case 'params'
                out=fis.output(varNum).mf(mfNum).params;
        end
end

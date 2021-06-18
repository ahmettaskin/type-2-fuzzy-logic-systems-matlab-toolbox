function member = evalMfTypeHelper( type,input,mfParams )
switch type
    case 'gaussmf'
         member =gaussmf(input, mfParams);
    case 'zmf'
         member =zmf(input, mfParams);
    case 'trapmf'
         member =trapmf(input, mfParams);
     case 'trimf'
        member =trimf(input, mfParams);
     case 'sigmf'
        member =sigmf(input, mfParams);
     case 'smf'
        member =smf(input, mfParams);
     case 'psigmf'
        member =psigmf(input, mfParams);
     case 'pimf'
        member =pimf(input, mfParams);
     case 'gbellmf'
        member =gbellmf(input, mfParams);
     case 'gauss2mf'
        member =gauss2mf(input, mfParams);
     case 'dsigmf'
        member =dsigmf(input, mfParams);              
end
end


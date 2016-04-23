function newparams = lowerMf(params,type,varRange)

diff = 0.5*(abs(varRange(1)-varRange(2)));
newparams=params;
switch type
    case 'trimf'
        newparams(1)=newparams(1)+(diff/4);
        newparams(3)=newparams(3)-(diff/4);
    case 'trapmf'
        newparams=params;
        newparams(1)=newparams(1)+(diff/4);
        newparams(4)=newparams(4)-(diff/4);
    case 'gbellmf'
        newparams=params;
        newparams(1)=newparams(1)/2;
    case 'gaussmf'
        newparams=params;
        newparams(1)=newparams(1)/2;
    case 'gauss2mf'
        newparams=params;
        newparams(1)=newparams(1)/2;
        newparams(3)=newparams(3)/2;
    case 'sigmf'
        newparams=params;
        newparams(1)=newparams(1)*2;
    case 'dsigmf'
        newparams=params;
    case 'psigmf'
        newparams=params;
    case 'pimf'
        newparams=params;
    case 'smf'
        newparams=params;
    case  'zmf'
        newparams=params;
end
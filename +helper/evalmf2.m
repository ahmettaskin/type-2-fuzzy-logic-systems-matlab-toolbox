function y=evalmf2(x,params,type)
if (type == 1) | (strcmp(type,'trimf')),
    y = trimf(x, params);
    %     try
    %     y = y*params(4);
    %     catch
    %     end
    return;
elseif (type == 2) | (strcmp(type,'trapmf')),
    y = trapmf(x, params);
    return;
elseif (type == 3) | (strcmp(type,'gaussmf')),
    y = gaussmf(x, params);
    return;
elseif (type == 4) | (strcmp(type,'gauss2mf')),
    y = gauss2mf(x, params);
    return;
elseif (type == 5) | (strcmp(type,'sigmf')),
    y = sigmf(x, params);
    return;
elseif (type == 6) | (strcmp(type,'dsigmf')),
    y = dsigmf(x, params);
    return;
elseif (type == 7) | (strcmp(type,'psigmf')),
    y = psigmf(x, params);
    return;
elseif (type == 8) | (strcmp(type,'gbellmf')),
    y = gbellmf(x, params);
    return;
elseif (type == 9) | (strcmp(type,'smf')),
    y = smf(x, params);
    return;
elseif (type == 10) | (strcmp(type,'zmf')),
    y = zmf(x, params);
    return;
elseif (type == 11) | (strcmp(type,'pimf')),
    y = pimf(x, params);
    return;
else
    % Membership function is unknown
    % We assume it is user-defined and evaluate it here
    evalStr=[type '(x, params)'];
    y = eval(evalStr);
    
    return;
end
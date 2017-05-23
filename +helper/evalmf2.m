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
function y=evalmf2(x,params,type)
if (type == 1) | (strcmp(type,'trimf')),
    y = helper.trimf(x, params);
    %     try
    %     y = y*params(4);
    %     catch
    %     end
    return;
elseif (type == 2) | (strcmp(type,'trapmf')),
    y = helper.trapmf(x, params);
    return;
elseif (type == 3) | (strcmp(type,'gaussmf')),
    y = helper.gaussmf(x, params);
    return;
elseif (type == 4) | (strcmp(type,'gauss2mf')),
    y = helper.gauss2mf(x, params);
    return;
elseif (type == 5) | (strcmp(type,'sigmf')),
    y = helper.sigmf(x, params);
    return;
elseif (type == 6) | (strcmp(type,'dsigmf')),
    y = helper.dsigmf(x, params);
    return;
elseif (type == 7) | (strcmp(type,'psigmf')),
    y = helper.psigmf(x, params);
    return;
elseif (type == 8) | (strcmp(type,'gbellmf')),
    y = helper.gbellmf(x, params);
    return;
elseif (type == 9) | (strcmp(type,'smf')),
    y = helper.smf(x, params);
    return;
elseif (type == 10) | (strcmp(type,'zmf')),
    y = helper.zmf(x, params);
    return;
elseif (type == 11) | (strcmp(type,'pimf')),
    y = helper.pimf(x, params);
    return;
else
    % Membership function is unknown
    % We assume it is user-defined and evaluate it here
    evalStr=[type '(x, params)'];
    y = eval(evalStr);
    
    return;
end
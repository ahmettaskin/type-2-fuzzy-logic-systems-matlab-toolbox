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
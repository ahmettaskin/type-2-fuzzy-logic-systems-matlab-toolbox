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
function [outParams,errorStr]=mf2mf(inParams,inType,outType,tol)
yWaist=0.5;
yShoulder=0.90;
outParams=[];
errorStr=[];
if strcmp(inType,'trimf'),
    lftWaist=yWaist*(inParams(2)-inParams(1))+inParams(1);
    lftShoulder=yShoulder*(inParams(2)-inParams(1))+inParams(1);
    rtShoulder=(1-yShoulder)*(inParams(3)-inParams(2))+inParams(2);
    rtWaist=(1-yWaist)*(inParams(3)-inParams(2))+inParams(2);

elseif strcmp(inType,'trapmf') | strcmp(inType,'pimf'),
    lftWaist=yWaist*(inParams(2)-inParams(1))+inParams(1);
    lftShoulder=yShoulder*(inParams(2)-inParams(1))+inParams(1);
    rtShoulder=(1-yShoulder)*(inParams(4)-inParams(3))+inParams(3);
    rtWaist=(1-yWaist)*(inParams(4)-inParams(3))+inParams(3);

elseif strcmp(inType,'gaussmf'),
    lftWaist=-abs(inParams(1))*sqrt(-2*log(yWaist))+inParams(2);
    lftShoulder=-abs(inParams(1))*sqrt(-2*log(yShoulder))+inParams(2);
    rtShoulder=2*inParams(2)-lftShoulder;
    rtWaist=2*inParams(2)-lftWaist;

elseif strcmp(inType,'gauss2mf'),
    lftWaist=-abs(inParams(1))*sqrt(-2*log(yWaist))+inParams(2);
    lftShoulder=inParams(2);
    rtShoulder=inParams(4);
    rtWaist=abs(inParams(3))*sqrt(-2*log(yWaist))+inParams(4);

elseif strcmp(inType,'gbellmf'),
    lftWaist=-inParams(1)*((1/yWaist-1)^(1/(2*inParams(2))))+inParams(3);
    lftShoulder=-inParams(1)*((1/yShoulder-1)^(1/(2*inParams(2))))+inParams(3);
    rtShoulder=2*inParams(3)-lftShoulder;
    rtWaist=2*inParams(3)-lftWaist;

elseif strcmp(inType,'sigmf'),
    if inParams(1)>0,
        lftWaist=inParams(2);
        lftShoulder=-1/inParams(1)*log(1/yShoulder-1)+inParams(2);
        rtShoulder=2*lftShoulder-lftWaist;
        rtWaist=2*rtShoulder-lftWaist;
    else
        rtWaist=inParams(2);
        rtShoulder=-1/inParams(1)*log(1/yShoulder-1)+inParams(2);
        lftShoulder=rtShoulder;
        lftWaist=2*lftShoulder-rtWaist;
    end

elseif strcmp(inType,'dsigmf'),
    lftWaist=inParams(2);
    lftShoulder=-1/inParams(1)*log(1/yShoulder-1)+inParams(2);
    rtWaist=inParams(4);
    rtShoulder=1/inParams(3)*log(1/yShoulder-1)+inParams(4);

elseif strcmp(inType,'psigmf'),
    lftWaist=inParams(2);
    lftShoulder=-1/inParams(1)*log(1/yShoulder-1)+inParams(2);
    rtWaist=inParams(4);
    rtShoulder=-1/inParams(3)*log(1/yShoulder-1)+inParams(4);

elseif strcmp(inType,'smf'),
    lftWaist=yWaist*(inParams(2)-inParams(1))+inParams(1);
    lftShoulder=yShoulder*(inParams(2)-inParams(1))+inParams(1);
    rtShoulder=inParams(2);
    if inParams(1)<inParams(2),
        lftWaist=inParams(1);
        rtWaist=2*inParams(2)-inParams(1);
    else
        lftWaist=2*inParams(2)-inParams(1);
        rtWaist=inParams(1);
    end

elseif strcmp(inType,'zmf'),
    lftShoulder=inParams(2);
    rtShoulder=inParams(2);
    if inParams(1)<inParams(2),
        lftWaist=inParams(1);
        rtWaist=2*inParams(2)-inParams(1);
    else
        lftWaist=2*inParams(2)-inParams(1);
        rtWaist=inParams(1);
    end
else
    % Input MF type is unknown
    outParams=[];
    errorStr=['Cannot translate from input MF type ' inType];
    if nargout<2, error(errorStr); end
    return
end

% We've translated into generalized coordinates, now translate back into
% MF specific parameters...

if nargin<4,
    tol=max(eps, 1e-3*(rtShoulder-lftShoulder));
end


if strcmp(outType,'trimf'),
    center=(rtShoulder+lftShoulder)/2;
    % Assumes yWaist=0.5
    outParams=sort([2*lftWaist-center center 2*rtWaist-center]);

elseif strcmp(outType,'trapmf'),
    % Assumes yWaist=0.5
    outParams=[2*lftWaist-lftShoulder lftShoulder rtShoulder 2*rtWaist-rtShoulder];
    
elseif strcmp(outType,'pimf'),
    % Assumes yWaist=0.5
    outParams=[2*lftWaist-lftShoulder lftShoulder rtShoulder max(tol,2*rtWaist-rtShoulder)];

elseif strcmp(outType,'gbellmf'),
    center=(rtShoulder+lftShoulder)/2;
    a=max(tol,center-lftWaist);
    b=2*a/(max(tol,lftShoulder-lftWaist));
    outParams=[a b center];

elseif strcmp(outType,'gaussmf'),
    center=(rtShoulder+lftShoulder)/2;
    sigma=max(tol,(rtWaist-center)/sqrt(-2*log(yWaist)));
    outParams=[sigma center];

elseif strcmp(outType,'gauss2mf'),
    lftSigma=max(tol,lftShoulder-lftWaist)/sqrt(-2*log(yWaist));
    rtSigma=max(tol,rtWaist-rtShoulder)/sqrt(-2*log(yWaist));
    outParams=[lftSigma lftShoulder rtSigma rtShoulder];

elseif strcmp(outType,'sigmf'),
    center=lftWaist;
    a=-1/max(tol,lftShoulder-center)*log(1/yShoulder-1);
    outParams=[a center];

elseif strcmp(outType,'dsigmf'),
    lftCenter=lftWaist;
    lftA=-1/max(tol,lftShoulder-lftCenter)*log(1/yShoulder-1);
    rtCenter=rtWaist;
    rtA=-1/max(tol,rtCenter-rtShoulder)*log(1/yShoulder-1);
    outParams=[lftA lftCenter rtA rtCenter];

elseif strcmp(outType,'psigmf'),
    lftCenter=lftWaist;
    lftA=-1/max(tol,lftShoulder-lftCenter)*log(1/yShoulder-1);
    rtCenter=rtWaist;
    rtA=1/max(tol,rtCenter-rtShoulder)*log(1/yShoulder-1);
    outParams=[lftA lftCenter rtA rtCenter];


elseif strcmp(outType,'smf'),
    % Assumes yWaist=0.5
    outParams=[2*lftWaist-lftShoulder lftShoulder];

elseif strcmp(outType,'zmf'),
    % Assumes yWaist=0.5
    outParams=[rtShoulder 2*rtWaist-rtShoulder];

else
    % Output MF type is unknown
    outParams=[];
    errorStr=['Cannot translate to output MF type ' outType];
    if nargout<2, error(errorStr); end
    return
end

outParams=eval(mat2str(outParams,4));

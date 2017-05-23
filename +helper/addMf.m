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
function out=addMf(fis,varType,varIndex,MFLabel,MFType,MFParams,MFid)
persistent nOfMF

out=fis;
if ~isempty(fis.input)
    if strcmp(varType,'input'),
        if MFid==1
            nOfMF=0;
            % Add Upper Membership function
            numMFs=size(fis.input(varIndex).mf);
            MFindex=numMFs(2)+1;
            out.input(varIndex).mf(1,MFindex).name=[MFLabel 'U'];
            out.input(varIndex).mf(1,MFindex).type=MFType;
            MFParams(end+1)=1;
            out.input(varIndex).mf(1,MFindex).params=MFParams;
            % Add Lower Membership function
        elseif MFid==2
            MFindex=nOfMF+1;
            nOfMF=MFindex;
            out.input(varIndex).mf(2,nOfMF).name=['mf' num2str(nOfMF) 'L'];
            out.input(varIndex).mf(2,nOfMF).type=MFType;
            MFParams(end+1)=0.5;
            out.input(varIndex).mf(2,nOfMF).params=MFParams;
        end
    elseif strcmp(varType,'output'),
        MFindex=length(fis.output(varIndex).mf)+1;
        out.output(varIndex).mf(MFindex).name=MFLabel;
        out.output(varIndex).mf(MFindex).type=MFType;
        out.output(varIndex).mf(MFindex).params(1,1)=MFParams;
        out.output(varIndex).mf(MFindex).params(1,2)=MFParams;
        
    end
else
    disp('No Input Variable yet');
end

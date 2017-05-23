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
function tf=compareMFs(t2fis,ParamsLower,ParamsUpper,currMF,VarType,varIndex)
if nargin==1
    cmd='add';
else
    cmd='check';
end

switch cmd
    case 'check'
        figNumber=gcf;
        mainAxes=findobj(figNumber,'Type','axes','Tag','mainaxes');
        lineHndl=findobj(mainAxes,'Type','line','UserData',currMF);
        x=get(lineHndl,'XData');
        if isequal(lower(VarType),'input')
            isLower=helper.isInt(currMF/2);
            if isLower, selectedMF = 'lower'; else selectedMF = 'upper';    end
            switch selectedMF
                case 'lower'
                    LowerType = t2fis.input(1,varIndex).mf(currMF).type;
                    UpperType = t2fis.input(1,varIndex).mf(currMF-1).type;
                    yLower = ParamsLower(end)*evalmf(x,ParamsLower(1:end-1),LowerType);
                    yUpper = ParamsUpper(end)*evalmf(x,ParamsUpper(1:end-1),UpperType);
                    if isempty(find(yUpper<yLower, 1))
                        tf=0; return
                    else
                        tf=1; return
                    end
                case 'upper'
                    LowerType = t2fis.input(1,varIndex).mf(currMF+1).type;
                    UpperType = t2fis.input(1,varIndex).mf(currMF).type;
                    yLower = ParamsLower(end)*evalmf(x,ParamsLower(1:end-1),LowerType);
                    yUpper = ParamsUpper(end)*evalmf(x,ParamsUpper(1:end-1),UpperType);
                    if isempty(find(yUpper<yLower, 1))
                        tf=0; return
                    else
                        tf=1; return
                    end
            end
            
            
        elseif isequal(lower(VarType),'output')
            mfType=t2fis.output(varIndex).mf(currMF).type;
            if strcmpi(mfType,'constant')
                if ParamsLower>ParamsUpper
                    tf=1; return
                else
                    tf=0;return
                end
            elseif strcmpi(mfType,'linear')
                tf=0;
            else
                tf=0;
            end
            
            
            
        end
    case 'add'
        %         % Get fig number
        %         figNumber=findall(0,'Tag','mfAddDlg');
        %         % Handle of type selection
        %         mfTypeHndlUpper=findobj(figNumber,'Tag','mftypeUpper');
        %         mfTypeHndlLower=findobj(figNumber,'Tag','mftypeLower');
        %         % Get Mf Type List
        %         mfTypeList=get(mfTypeHndlUpper,'String');
        %         % Get Value of type selection
        %         mfTypeValUpper=get(mfTypeHndlUpper,'Value');
        %         mfTypeValLower=get(mfTypeHndlLower,'Value');
        %         % Type of Membership Functions
        %         mfTypeUpper=deblank(mfTypeList(mfTypeValUpper,:));
        %         mfTypeUpper=strtrim(mfTypeUpper);
        %         mfTypeLower=deblank(mfTypeList(mfTypeValLower,:));
        %         mfTypeLower=strtrim(mfTypeLower);
        %
        %
        %         finiteMFs={};
        %         infiniteMFs={};
        %         % Warning message for impossible selecction
        %         if mfTypeUpper
        %         end
        
end
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
function obj = radio(~,~,obj)
thisradio=gcbo;
set(thisradio, 'Value', 1);
radioHndl=findobj(gcbf, 'Tag', 'radio');
for i=1:length(radioHndl)
    if thisradio~=radioHndl(i)
        set(radioHndl(i), 'Value', 0);
    end
end
oldfis=get(gcbf, 'Userdata');
fis=oldfis{1};
if isprop(fis, 'input')
    numInputs=length(fis.input);
else
    numInputs=0;
end
%     if isprop(fis, 'output')
%      numOutputs=length(fis.output);
%     else
%      numOutputs=0;
%     end
keyword=get(thisradio, 'String');
for i=2:numInputs
    keyHndl(i)=findobj(gcbf, 'Tag', ['ruleinkeyw' num2str(i)]);
    set(keyHndl(i), 'String', keyword);
end
%     for i=2:numOutputs
%      keyHndl(i)=findobj(gcbf, 'Tag', ['ruleoutkeyw' num2str(i)]);
%      set(keyHndl(i), 'String', keyword);
%     end

end
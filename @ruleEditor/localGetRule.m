function obj = localGetRule(obj, figNumber, index, fis)
if isprop(fis, 'input')
    numInputs=length(fis.input);
else
    numInputs=0;
end
if isprop(fis, 'output')
    numOutputs=length(fis.output);
else
    numOutputs=0;
end

if isprop(fis, 'rule')
    rulelist=fis.rule;
else
    rulelist=[];
end
if isempty(rulelist)
    return;
end
radioHndl=findobj(figNumber, 'Tag', 'radio');
weightHndl=findobj(figNumber, 'Tag', 'weight');
%   for i=2:numInputs
%    connectw(i-1)=findobj(figNumber, 'Tag', ['ruleinkeyw' num2str(i)]);
%   end
connect=fis.rule(index).connection;
weight=fis.rule(index).weight;
%   for i=1:0   %length(connectw)
%         if connect==1
%          set(connectw(i), 'String', 'and')
%         else
%          set(connectw(i), 'String', 'or')
%         end
%   end
if connect==1
    set(radioHndl(1), 'value', 0);
    set(radioHndl(2), 'value', 1);
else
    set(radioHndl(1), 'value', 1);
    set(radioHndl(2), 'value', 0);
end
set(weightHndl, 'String', num2str(weight));
for i=1:numInputs
    Hndl=findobj(figNumber, 'Tag', ['ruleinmake' num2str(i)]);
    rulevarindex=rulelist(index).antecedent(i);
    if rulevarindex==0
        numMFs=size(fis.input(i).mf);
        set(Hndl, 'Value', numMFs(2)+1);
    else
        notHndl=findobj(figNumber, 'Tag', ['ruleinradio' num2str(i)]);
        if rulevarindex<0
            set(notHndl, 'Value', 1);
            rulevarindex=-rulevarindex;
        else
            set(notHndl, 'Value', 0);
        end
        set(Hndl, 'Value', rulevarindex);
    end
end
for i=1:numOutputs
    Hndl=findobj(figNumber, 'Tag', ['ruleoutmake' num2str(i)]);
    rulevarindex=rulelist(index).consequent(i);
    if rulevarindex==0
        set(Hndl, 'Value', length(fis.output(i).mf)+1);
    else
        notHndl=findobj(figNumber, 'Tag', ['ruleoutradio' num2str(i)]);
        if rulevarindex<0
            set(notHndl, 'Value', 1);
            rulevarindex=-rulevarindex;
        else
            set(notHndl, 'Value', 0);
        end
        set(Hndl, 'Value', rulevarindex);
    end
    
end
end
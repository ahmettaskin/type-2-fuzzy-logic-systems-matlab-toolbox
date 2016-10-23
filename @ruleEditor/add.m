function obj = add(~,~,obj)
%ADD Summary of this function goes here
%   Detailed explanation goes here
thisact=get(gcbo, 'String');
fis=helper.getAppdata;

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

errflag=1;                  %assume errflag=true
sentence='if ';
radioHndl=findobj(gcbf, 'Tag', 'radio');
conn=2;
for i=1:length(radioHndl)
    if get(radioHndl(i),'Value')~=0
        connStr=get(radioHndl(i),'String');
        if strcmp(connStr, 'and')
            conn=1;
        end
        break;
    end
end
for i=1:numInputs
    nameHndl=findobj(gcbf, 'Tag', ['ruleinmake' num2str(i)]);
    notHndl=findobj(gcbf, 'Tag', ['ruleinradio' num2str(i)]);
    if get(notHndl, 'Value')==0
        notvalue=1;
    else
        notvalue=-1;
    end
    value=get(nameHndl, 'Value');
    if value>length(fis.input(i).mf) %| ~isempty(fis.input(i).mf)
        str(i)=0;
    else
        str(i)=value*notvalue;
        errflag=0;
    end
end
if errflag==0,
    errflag=1;
    for i=1:numOutputs
        nameHndl=findobj(gcbf, 'Tag', ['ruleoutmake' num2str(i)]);
        notHndl=findobj(gcbf, 'Tag', ['ruleoutradio' num2str(i)]);
        if get(notHndl, 'Value')==0
            notvalue= 1;
        else
            notvalue=-1;
        end
        value=get(nameHndl, 'Value');
        if value>length(fis.output(i).mf) %| ~isempty(fis.output(i).mf)
            str(numInputs+i) = 0;
        else
            str(numInputs+i)=value*notvalue;
            errflag=0;
        end
        
    end
end
if errflag==0;
    weightHndl=findobj(gcbf, 'tag', 'weight');
    weight=get(weightHndl, 'String');
    
    ruleHndl=findobj(gcbf, 'tag', 'rulewindow');
    if isempty(str2double(weight))
        wght=1;
    else
        wght=max(min(str2double(weight), 1), 0);
    end
    if strcmp(thisact, 'Add rule')
        index=length(fis.rule)+1;
        statusStr='added';
    else
        index=get(ruleHndl, 'Value');
        statusStr='changed';
    end
    fis.rule(index).antecedent=str(1:numInputs);
    fis.rule(index).consequent=str(numInputs+1:end);
    fis.rule(index).weight=wght;
    fis.rule(index).connection=conn;
    if length(fis.rule)~=0
        delHndl=findobj(gcbf, 'Tag', 'delete');
        set(delHndl, 'Enable', 'on');
    end
    helper.setAppdata(fis)
    formatHndl=findobj(gcbf,'Type','uimenu','Tag','rulefrmt', 'Checked','on');
    formatStr=lower(get(formatHndl,'Label'));
    formatStr=deblank(formatStr);
    formatStr=fliplr(deblank(fliplr(formatStr)));
    langHndl=findobj(gcbf,'Type','uimenu', 'Tag', 'lang', 'Checked','on');
    lang=lower(get(langHndl,'Label'));
    lang=deblank(lang);
    lang=fliplr(deblank(fliplr(lang)));
    thisrule=showRule(obj,fis,1:length(fis.rule), formatStr, lang);
    set(ruleHndl,'String', thisrule, 'value', index);
    statusHndl=findobj(gcbf, 'Tag', 'status');
    set(statusHndl, 'String', ['The rule is ' statusStr]);
else
    statusHndl=findobj(gcbf, 'Tag', 'status');
    set(statusHndl, 'String', 'The rule is incomplete');
end

end


function obj = dispRules(obj)
%DÝSPRULES Summary of this function goes here
%   Detailed explanation goes here
%====================================
                    figNumber=gcf;
                    menuHndl=findobj(figNumber,'Type','uimenu','Tag','rulefrmt', 'Checked','on');
                    dispStyle=lower(get(menuHndl,'Label'));
                    dispStyle=deblank(dispStyle);
                    dispStyle=fliplr(deblank(fliplr(dispStyle)));
                    fis=helper.getAppdata;
                    numRules=length(fis.rule);
                    if numRules==0,
                        msgStr=['There are no rules for this system.'];
                        statmsg(figNumber,msgStr);
                    else
                        msgStr=['Translating to ' dispStyle ' format'];
                        statmsg(figNumber,msgStr);
                        editHndl=findobj(figNumber,'Tag', 'rulewindow');
                        langHndl=findobj(figNumber,'Type','uimenu','Tag', 'lang', 'Checked','on');
                        lang=lower(get(langHndl,'Label'));
                        editStr=showrule2(fis,1:numRules,dispStyle,lang);
                        % editStr=char([32*ones(size(editStr,1),1) editStr]);
                        set(editHndl,'String',editStr);
                    end

end


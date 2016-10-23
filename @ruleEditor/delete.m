function obj = delete(~,~,obj)
%DELETE Summary of this function goes here
%   Detailed explanation goes here
   oldfis=get(gcbf, 'Userdata');
                    fis=oldfis{1};
                    if ~isprop(fis, 'rule') | length(fis.rule)==0
                        delHndl=findobj(gcbf, 'Tag', 'delete');
                        set(delHndl, 'Enable', 'off');
                        return;
                    end
                    ruleHndl=findobj(gcbf, 'tag', 'rulewindow');
                    thisrule=get(ruleHndl, 'String');
                    index=get(ruleHndl, 'Value');
                    thisrule(index, :)=[];
                    fis.rule(index)=[];
                    if length(fis.rule)==0
                        delHndl=findobj(gcbf, 'Tag', 'delete');
                        set(delHndl, 'Enable', 'off');
                    end
                    thisfis{1}=fis;
                    if index>size(thisrule,1)
                        set(ruleHndl, 'Value', max(1, index-1));
                    end
                    statusHndl=findobj(gcbf, 'Tag', 'status');
                    set(statusHndl, 'String', 'The rule is deleted');
                    
                    helper.setAppdata(fis);
                    formatHndl=findobj(gcbf,'Type','uimenu','Tag','rulefrmt', 'Checked','on');
                    formatStr=lower(get(formatHndl,'Label'));
                    formatStr=deblank(formatStr);
                    formatStr=fliplr(deblank(fliplr(formatStr)));
                    langHndl=findobj(gcbf,'Type','uimenu', 'Tag', 'lang', 'Checked','on');
                    lang=lower(get(langHndl,'Label'));
                    lang=deblank(lang);
                    lang=fliplr(deblank(fliplr(lang)));
                    thisrule=showRule(obj,fis,1:length(fis.rule), formatStr, lang);
                    set(ruleHndl,'String', thisrule, 'value', max(1, index-1));
   

end


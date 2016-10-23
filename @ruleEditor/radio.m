function obj = radio(~,~,obj)
%RADÝO Summary of this function goes here
%   Detailed explanation goes here
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


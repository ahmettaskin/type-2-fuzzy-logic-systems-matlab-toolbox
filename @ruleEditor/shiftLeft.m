function obj = shiftLeft(obj)
%SHÝFTLEFT Summary of this function goes here
%   Detailed explanation goes here
 oldfis=get(gcbf, 'Userdata');
                    fis=oldfis{1};
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
                    set(gcbf, 'Unit', 'normal');
                    lastone=numOutputs;
                    stop=0;
                    for i=lastone:-1:1
                        Hndl=findobj(gcbf, 'Tag', ['ruleoutmake' num2str(i)]);
                        radioHndl=findobj(gcbf, 'Tag', ['ruleoutradio', num2str(i)]);
                        labelHndl=findobj(gcbf, 'Tag', ['ruleoutlabel', num2str(i)]);
                        keyHndl=findobj(gcbf, 'Tag', ['ruleoutkeyw', num2str(i)]);
                        set(Hndl, 'Unit', 'normal');
                        set(radioHndl, 'Unit', 'normal');
                        set(labelHndl, 'Unit', 'normal');
                        set(keyHndl, 'Unit', 'normal');
                        pos=get(Hndl, 'Position');
                        poslabel=get(labelHndl, 'Position');
                        posradio=get(radioHndl, 'Position');
                        poskey=get(keyHndl, 'Position');
                        if i==lastone & pos(1)<=1-pos(3)-.01
                            stop=1;
                            break
                        end
                        pos=pos-[.05, 0, 0, 0];
                        posradio=posradio-[.05, 0, 0, 0];
                        poslabel=poslabel-[.05, 0, 0, 0];
                        poskey=poskey-[.05, 0, 0, 0];
                        set(Hndl, 'Position', pos);
                        set(radioHndl, 'Position', posradio);
                        set(labelHndl, 'Position', poslabel);
                        set(keyHndl, 'Position', poskey);
                    end
                    if stop==0
                        lastone=numInputs;
                        for i=1:lastone
                            Hndl=findobj(gcbf, 'Tag', ['ruleinmake' num2str(i)]);
                            radioHndl=findobj(gcbf, 'Tag', ['ruleinradio', num2str(i)]);
                            labelHndl=findobj(gcbf, 'Tag', ['ruleinlabel', num2str(i)]);
                            keyHndl=findobj(gcbf, 'Tag', ['ruleinkeyw', num2str(i)]);
                            set(Hndl, 'Unit', 'normal');
                            set(radioHndl, 'Unit', 'normal');
                            set(labelHndl, 'Unit', 'normal');
                            set(keyHndl, 'Unit', 'normal');
                            pos=get(Hndl, 'Position');
                            poslabel=get(labelHndl, 'Position');
                            posradio=get(radioHndl, 'Position');
                            poskey=get(keyHndl, 'Position');
                            pos=pos-[.05, 0, 0, 0];
                            set(Hndl, 'Position', pos);
                            posradio=posradio-[.05, 0, 0, 0];
                            poslabel=poslabel-[.05, 0, 0, 0];
                            poskey=poskey-[.05, 0, 0, 0];
                            set(radioHndl, 'Position', posradio);
                            set(labelHndl, 'Position', poslabel);
                            set(keyHndl, 'Position', poskey);
                        end
                    end

end


function obj = getRule(obj)
%GETRULE Summary of this function goes here
%   Detailed explanation goes here
                    index=get(gcbo, 'Value');
                    oldfis=get(gcbf, 'Userdata');
                    fis=oldfis{1};
                    figNumber=gcbf;
                    localGetRule(obj, figNumber, index, fis);
    

end


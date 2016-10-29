function obj = getRule(~,~,obj)

index=get(gcbo, 'Value');
oldfis=get(gcbf, 'Userdata');
fis=oldfis{1};
figNumber=gcbf;
localGetRule(obj, figNumber, index, fis);
end


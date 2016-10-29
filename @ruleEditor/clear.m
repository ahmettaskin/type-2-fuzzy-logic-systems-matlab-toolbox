function obj = clear(~,~,obj)
fis=helper.getAppdata;
fis.clearAllRules;
update(obj);

end


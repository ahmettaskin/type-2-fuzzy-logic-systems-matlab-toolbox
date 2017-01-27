function ranges = get_inputRanges( obj )
names=get_inputNames(obj);
for i=1:length(names)
    ranges{i}=obj.input(i).range;
end


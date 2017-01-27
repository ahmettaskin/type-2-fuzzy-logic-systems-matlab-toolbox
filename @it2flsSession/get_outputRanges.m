function ranges = get_outputRanges( obj )
names=get_outputNames(obj);
for i=1:length(names)
    ranges{i}=obj.output(i).range;
end

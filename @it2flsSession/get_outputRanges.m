function ranges = get_outputRanges( obj )
%GET_OUTPUTRANGES Summary of this function goes here
%   Detailed explanation goes here
names=get_outputNames(obj);
for i=1:length(names)
    ranges{i}=obj.output(i).range;
end

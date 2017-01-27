function names = get_outputNames( obj )
for i=1:length(obj.output)
     names{i}=obj.output(i).name;
end

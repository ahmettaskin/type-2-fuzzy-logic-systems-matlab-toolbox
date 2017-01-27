function names = get_inputNames( obj )
for i=1:length(obj.input)
    names{i}=obj.input(i).name;
end
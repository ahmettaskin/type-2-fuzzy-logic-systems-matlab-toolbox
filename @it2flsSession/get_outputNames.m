function names = get_outputNames( obj )
%GET_OUTPUTNAMES Summary of this function goes here
%   Detailed explanation goes here
for i=1:length(obj.output)
     names{i}=obj.output(i).name;
end

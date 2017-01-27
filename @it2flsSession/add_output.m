function obj = add_output( obj, name, range, nOfMfs , type)
if nargin<5
    type = 'sugeno';
end

if ~isprop(obj.output,name)
    obj.output.(name) = struct('name',[],...
            'range',[],...
            'mfs',[]);
end
obj.output.(name).name = name;
obj.output.(name).range = range;
length=range(2) - range(1);
step=length/nOfMfs-1;

for i=1:nOfMfs
    obj.output.(name).mfs.(['mf' num2str(i)]).range=range;
    obj.output.(name).mfs.(['mf' num2str(i)]).upper.type='constant';
    obj.output.(name).mfs.(['mf' num2str(i)]).upper.values=-1+(i-1)*step;
    
    obj.output.(name).mfs.(['mf' num2str(i)]).lower.type='constant';    
    obj.output.(name).mfs.(['mf' num2str(i)]).lower.values=-1+(i-1)*step;
    
    
end


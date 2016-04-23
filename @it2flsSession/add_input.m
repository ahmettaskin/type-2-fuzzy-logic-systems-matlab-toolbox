function obj = add_input( obj, name, range, nOfMfs)
%ADD_ÝNPUT Summary of this function goes here 
%   Detailed explanation goes here
if nargin==1
   nOfMfs=3;
   range=[-1 1];
   names=get_inputNames(obj);
   name=['input' num2str(numel(names)+1)];
   
end


if ~isprop(obj.input,name)
    obj.input.(name) = struct('name',[],...
            'range',[],...
            'mfs',[]);
end
obj.input.(name).name = name;
obj.input.(name).range = range;
length=range(2) - range(1);
step=length/nOfMfs-1;

for i=1:nOfMfs
    obj.input.(name).mfs.(['mf' num2str(i)]).range=range;
    obj.input.(name).mfs.(['mf' num2str(i)]).upper.type='trimf';
    obj.input.(name).mfs.(['mf' num2str(i)]).upper.values=[-1+(i-1)*step -0.5+(i-1)*step 0+(i-1)*step 1];
    
    obj.input.(name).mfs.(['mf' num2str(i)]).lower.type='trimf';    
    obj.input.(name).mfs.(['mf' num2str(i)]).lower.values=[-1+(i-1)*step -0.5+(i-1)*step 0+(i-1)*step 0.5];
end
helper.setAppdata(obj)



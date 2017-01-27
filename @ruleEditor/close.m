function obj = close(~,~,obj)
fig=  findall(0,'type','figure','Tag','ruleedit');
close(fig);
figure(findall(0,'type','figure','Tag','fuzzyt2'));
end
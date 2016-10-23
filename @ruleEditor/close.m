function obj = close(obj)
%CLOSE Summary of this function goes here
%   Detailed explanation goes here
fig=  findall(0,'type','figure','Tag','ruleedit');
close(fig);
figure(findall(0,'type','figure','Tag','fuzzyt2'));

end


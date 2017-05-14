function t2f_test()
%T2F_TEST 
%
% SYNTAX: 
%     t2f_test(...) 
%
% INPUTS: 
%    
% OUTPUTS:
%    
% EXAMPLE :
%    
% See also 

% Copyright (c) AVL Software and Functions GmbH 2014 
% $Revision: 1.10 $, $Date: 2014/02/19 10:20:06VET $ by $Author: Dalon Thierry RGB (DALONT) $ 

% Calls: 

for i=1:100
    input = 0 + (0+1)*rand(4,1);
    input=input';
    fis = readfis('Test4Input');
    out(i,1) = evalfis(input,fis);
    
    fist2 = readt2fis('Test4Input2.t2fis');
    out(i,2) = evalt2(input,fist2);
end

if out(:,1)==out(:,2)
    disp('passed')
else
    disp('failed')
end
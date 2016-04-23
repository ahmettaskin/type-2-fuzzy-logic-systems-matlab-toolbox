function t2f_closeruleedit()
%T2F_CLOSERULEEDIT 
%
% SYNTAX: 
%     t2f_closeruleedit(...) 
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
fig=  findall(0,'type','figure','Tag','ruleedit');
close(fig);
figure(findall(0,'type','figure','Tag','fuzzyt2'));
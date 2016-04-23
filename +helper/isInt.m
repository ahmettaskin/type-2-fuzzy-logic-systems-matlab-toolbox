function bout=isInt(x)
% ISINT - return true if x is an integer, false else
%
% SYNTAX: 
%    bout=isint(x)
%
% See also: isscalar, isindex, isinteger

% Copyright (c) AVL Software and Functions GmbH 2011 
% $Revision: 1.2 $, $Date: 2012/05/15 04:29:39VET $ by $Author: Dalon Thierry RGB (DALONT) $
bout=~( isempty(x) || ~isa(x,'double') || (round(x)~=x)  );
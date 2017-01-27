function bout=isInt(x)
bout=~( isempty(x) || ~isa(x,'double') || (round(x)~=x)  );
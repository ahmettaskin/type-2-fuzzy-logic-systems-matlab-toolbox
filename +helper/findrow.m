function rowNum=findrow(str,strMat)
% Remove leading and trailing blanks form STR
str = strtrim(str);

% Initialize boolean vector that picks matching rows
nrows = size(strMat,1);
IsMatching = zeros(1,nrows);

% Process each row
for ctrow=1:nrows,
   % Remove leading and trailing blanks
   s = strtrim(char(strMat(ctrow,:))); 
   IsMatching(ctrow) = strcmp(str,s);
end

rowNum = find(IsMatching);
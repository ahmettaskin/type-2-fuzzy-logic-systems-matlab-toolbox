function blkStruct = slblocks  
% SLBLOCKS Defines the block library for AVLib Blockset

% Copyright (c) 2013, AVL Software and Functions GmbH
% $Revision: 1.1 $, $Date: 2013/10/25 06:49:01VET $ by $Author: halatcii $


% The function that will be called when the user double-clicks on  
% the library's name. ;  
%blkStruct.OpenFcn = 'AVLib';  

% Define the Browser structure array, the first element contains the
% information for the Simulink block library and the second for the
% Simulink Extras block library.
Browser(1).Library = 'Fuzzy_Type2_Lib';
Browser(1).Name    = 'Interval Type-2 Fuzzy Logic Systems Toolbox';
Browser(1).IsFlat  = 0;% Is this library "flat" (i.e. no subsystems)?
blkStruct.Browser = Browser;
clear Browser;
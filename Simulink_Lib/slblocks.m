function blkStruct = slblocks  
% Define the Browser structure array, the first element contains the
% information for the Simulink block library and the second for the
% Simulink Extras block library.
Browser(1).Library = 'Fuzzy_Type2_Lib';
Browser(1).Name    = 'Interval Type-2 Fuzzy Logic Systems Toolbox';
Browser(1).IsFlat  = 0;% Is this library "flat" (i.e. no subsystems)?
blkStruct.Browser = Browser;
clear Browser;
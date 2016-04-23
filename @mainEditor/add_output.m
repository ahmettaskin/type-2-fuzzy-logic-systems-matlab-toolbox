function [ obj ] = add_output( evt,handle,obj )
%ADD_ÝNPUT Summary of this function goes here
%   Detailed explanation goes here

fis=helper.getAppdata;
% add_input(fis);

addVar(obj,'output');
plotFis(obj);
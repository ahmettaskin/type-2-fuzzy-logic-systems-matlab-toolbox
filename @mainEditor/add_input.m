function [ obj ] = add_input( evt,handle,obj )
%ADD_ÝNPUT Summary of this function goes here
%   Detailed explanation goes here

fis=helper.getAppdata;
% add_input(fis);

addVar(obj,'input');
plotFis(obj);
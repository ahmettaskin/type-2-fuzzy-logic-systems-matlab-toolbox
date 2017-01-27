function out=removeMfs(fis,varType,varIndex,mfIndex)
fis.(varType)(1,varIndex).mf=[];
out=fis;
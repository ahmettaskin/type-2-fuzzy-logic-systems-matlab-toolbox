%  IT2-FLS Toolbox is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
% 
%     IT2-FLS Toolbox is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
% 
%     You should have received a copy of the GNU General Public License
%     along with IT2-FLS Toolbox.  If not, see <http://www.gnu.org/licenses/>.
function [out,errorStr]=readt2fis(fileName,pathName)
out=it2flsSession;
out=[];
if nargin<1,
    [fileName,pathName]=uigetfile('*.t2fis','Read FIS');
    if isequal(fileName,0) || isequal(pathName,0)
        % If fileName is zero, "cancel" was hit, or there was an error.
        errorStr='No file was loaded';
        if nargout<2,
            error(errorStr);
        end
        return
    end
    fileName = fullfile(pathName, fileName);
else
    if ischar(fileName)
        [pathstr, name, ext] = fileparts(fileName);
        if nargin==2
            pathstr=pathName;
        end
        
        if ~strcmp(ext,'.t2fis')
            name = [name ext];
            ext = '.t2fis';
        end
        if isempty(name)
            errorStr = 'Empty file name: no file was loaded';
            if nargout<2,
                error(errorStr);
            end
            return
        end
        fileName = fullfile(pathstr,[name ext]);
    else
        error('File name must be specified as a string.')
    end
end

[fid,errorStr]=fopen(fileName,'r');
if fid<0,
    if nargout<2,
        error(errorStr);
    end
    return
end

% Structure
nextLineVar=' ';
topic='[System]';
while isempty(findstr(nextLineVar,topic)),
    nextLineVar=LocalNextline(fid);
end

% These are the system defaults in case the user has omitted them
Name='Untitled';
Type='mamdani';
AndMethod='min';
OrMethod='max';
ImpMethod='min';
AggMethod='max';
DefuzzMethod='centroid';
TypeRedMethod='Karnik-Mendel';

nextLineVar=' ';
% Here we are evaluating everything up till the first "[" bracket
% The lines we're eval-ing contain their own variable names, so
% a lot of variables, like "Name" and so on, are getting initialized
% invisibly
while isempty([findstr(nextLineVar,'[Input') findstr(nextLineVar,'[Output')
        findstr(nextLineVar,'[Rules')]),
    eval([nextLineVar ';']);
    nextLineVar=LocalNextline(fid);
end

if strcmp(Type,'sugeno')
    ImpMethod = 'prod';
    AggMethod = 'sum';
end
out.name=Name;
out.type=Type;
out.andMethod=AndMethod;
out.orMethod=OrMethod;
out.defuzzMethod=DefuzzMethod;
out.impMethod=ImpMethod;
out.aggMethod=AggMethod;
out.typeRedMethod=TypeRedMethod;

% I have to rewind here to catch the first input. This is because
% I don't know how long the [System] comments are going to be
frewind(fid)

%Initialize parameters

NumInputMFs=[];
NumOutputMFs=[];
InLabels=[];
OutLabels=[];
InRange=[];
OutRange=[];
InMFLabels=[];
OutMFLabels=[];
InMFTypes=[];
OutMFTypes=[];
InMFParams=[];
OutMFParams=[];
% Now begin with the inputs
for varIndex=1:NumInputs,
    nextLineVar=' ';
    topic='[Input';
    while isempty(findstr(nextLineVar,topic)),
        nextLineVar=LocalNextline(fid);
    end
    
    % Input variable name
    Name=0;
    eval([LocalNextline(fid) ';'])
    if ~Name,
        error(['Name missing or out of place for input variable ' ...
            num2str(varIndex)]);
    end
    
    out.input(varIndex).name=Name;
    % Input variable range
    Range=0;
    eval([LocalNextline(fid) ';'])
    if ~Range,
        error(['Range missing or out of place for input variable ' ...
            num2str(varIndex)]);
    end
    out.input(varIndex).range=Range;
    
    % Number of membership functions
    eval([LocalNextline(fid) ';']);
    
    for MFIndex=1:NumMFs*2,
        MFIndex2=round(MFIndex/2);
        if ~helper.isInt(MFIndex/2)
            MFIndex1=1;
        else
            MFIndex1=2;
        end
        MFStr=LocalNextline(fid);
        nameStart=findstr(MFStr,'=');
        nameEnd=findstr(MFStr,':');
        MFName=eval(MFStr((nameStart+1):(nameEnd-1)));
        typeStart=findstr(MFStr,':');
        typeEnd=findstr(MFStr,',');
        MFType=eval(MFStr((typeStart+1):(typeEnd-1)));
        MFParams=eval(MFStr((typeEnd+1):length(MFStr)));
        out.input(varIndex).mf(MFIndex1,MFIndex2).name=MFName;
        out.input(varIndex).mf(MFIndex1,MFIndex2).type=MFType;
        out.input(varIndex).mf(MFIndex1,MFIndex2).params=MFParams;
    end
end

% Now for the outputs
for varIndex=1:NumOutputs,
    nextLineVar=' ';
    topic='Output';
    while isempty(findstr(nextLineVar,topic)),
        nextLineVar=LocalNextline(fid);
    end
    
    % Output variable name
    varName=LocalNextline(fid);
    varName=strrep(varName,'Name','');
    varName=eval(strrep(varName,'=',''));
    out.output(varIndex).name=varName;
    
    % Output variable range
    rangeStr=LocalNextline(fid);
    if isempty(strfind(rangeStr,'CrispInterval'))
        rangeStr=strrep(rangeStr,'Range','');
        rangeStr=strrep(rangeStr,'=','');
        out.output(varIndex).range=eval(['[' rangeStr ']']);
    else
        crispStr=strrep(rangeStr,'CrispInterval','');
        crispStr=strrep(crispStr,'=','');
        out.output(varIndex).crisp=eval(['[' crispStr ']']);
        
        rangeStr=LocalNextline(fid);
        rangeStr=strrep(rangeStr,'Range','');
        rangeStr=strrep(rangeStr,'=','');
        out.output(varIndex).range=eval(['[' rangeStr ']']);  
    end    
    NumMFsStr=LocalNextline(fid);
    NumMFsStr=strrep(NumMFsStr,'NumMFs','');
    NumMFsStr=strrep(NumMFsStr,'=','');
    NumMFs=eval(NumMFsStr);
    
    for MFIndex=1:NumMFs,
        MFStr=LocalNextline(fid);
        nameStart=findstr(MFStr,'=');
        nameEnd=findstr(MFStr,':');
        MFName=eval(MFStr((nameStart+1):(nameEnd-1)));
        
        typeStart=findstr(MFStr,':');
        typeEnd=findstr(MFStr,',');
        MFType=eval(MFStr((typeStart+1):(typeEnd-1)));
        
        MFParams=eval(MFStr((typeEnd+1):length(MFStr)));
        
        out.output(varIndex).mf(MFIndex).name=MFName;
        out.output(varIndex).mf(MFIndex).type=MFType;
        out.output(varIndex).mf(MFIndex).params=MFParams;
    end
end

% Now assemble the whole FIS data matrix

% If NumInputs or NumOutputs is zero, we need a space holder for the MF indices
% Otherwise they'll just be the empty set
if isempty(NumInputMFs), NumInputMFs=0; end
if isempty(NumOutputMFs), NumOutputMFs=0; end



% Now for the rules
nextLineVar=' ';
topic='Rules';
while isempty(findstr(nextLineVar,topic)),
    nextLineVar=LocalNextline(fid);
end

ruleIndex=1;
txtRuleList=[];
out.rule=[];
while ~feof(fid)
    ruleStr=LocalNextline(fid);
    if ischar(ruleStr)
        txtRuleList(ruleIndex,1:length(ruleStr))=ruleStr;
        ruleIndex=ruleIndex+1;
    end
end

if ~isempty(txtRuleList)&& isfield(out, 'input') && isfield(out, 'output')
    %            & isprop(out.input, 'mf') & isprop(out.output, 'mf') ...
    %            & isprop(out.input.mf, 'name') & isprop(out.output.mf, 'name')
    out=helper.parsrule(out,txtRuleList,'indexed');
end

fclose(fid);



function outLine=LocalNextline(fid)
%LOCALNEXTLINE Return the next non-empty line of a file.
%	OUTLINE=LOCALNEXTLINE(FID) returns the next non-empty line in the
%	file whose file ID is FID. The file FID must already be open.
%	LOCALNEXTLINE skips all lines that consist only of a carriage
%	return and it returns a -1 when the end of the file has been
%	reached.
%
%	LOCALNEXTLINE ignores all lines that begin with the % comment
%	character (the % character must be in the first column)

%	Ned Gulley, 2-2-94

outLine=fgetl(fid);

stopFlag=0;
while (~stopFlag),
    if length(outLine)>0,
        if (~strcmp(outLine(1),'%') | (outLine ==-1)),
            % This line has real content or the end of the file; stop and return outLine
            stopFlag=1;
        else
            % This line must be a comment; keep going
            outLine=fgetl(fid);
        end
    else
        % This line is of length zero
        outLine=fgetl(fid);
    end
end;

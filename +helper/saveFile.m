function obj=saveFile(obj,cmd,~)
%% Ask user to save or not while closing toolbox
if nargin==3
    try
        cmd.EventName='save';
    end
end
tagList={'fuzzyt2',...
    'mfEditor',...
    'ruleedit',...
    'mfAddDlg'};
if isempty(cmd)
    cmd.EventName='close';
elseif  ~isstruct(cmd) && ~isobject(cmd)
    clear cmd;
    cmd.EventName='save';
end

if strcmpi(cmd.EventName,'close')
    answer=questdlg('Do you want to save your current design before close ?',...
        'Close Toolbox','Yes','No','Yes');
    if isequal(answer,'No')
        for i=1:numel(tagList)
            fig=findobj(0,'tag',tagList{i});
            if ~isempty(fig)
                delete(fig(ishghandle(fig)));
            end
        end
        return
    end
end

fisName = '';
errorStr = '';
% ni = nargin;
% no = nargout;
% ThrowError = (no<3);
% DLGStr='dialog';
fileName='';

figNumber=findobj(0,'Tag', 'fuzzyt2');
fis=helper.getAppdata;


% Launch dialog
% if strcmp(DLGStr,'dialog'),
% Open dialog to get file name
[fileName,pathName]=uiputfile('*.t2fis','Save T2FIS',fileName);
if isequal(fileName,0) || isequal(pathName,0)
    %     errorStr='No file name was specified';
    %     if ThrowError, error(errorStr); end
    return
end
fileName = fullfile(pathName, fileName);
[dummy, name] = fileparts(fileName);
fisName = name;


% Write data to file
fid=fopen(fileName,'w');
if fid==-1,
    errorStr=sprintf('Unable to write to file "%s"',fileName);
    if ThrowError, error(errorStr); end
    return
end
fprintf(fid,'[System]\n');

str=['Name=''' fisName '''\n'];
fprintf(fid,str);

% Structure

str=['Type=''' fis.type '''\n'];
fprintf(fid,str);
str='Version=2.0\n';
fprintf(fid,str);

str=['NumInputs=' num2str(length(fis.input)) '\n'];
fprintf(fid,str);

str=['NumOutputs=' num2str(length(fis.output)) '\n'];
fprintf(fid,str);


str=['NumRules=' num2str(length(fis.rule)) '\n'];
fprintf(fid,str);
str=['AndMethod=''' fis.andMethod '''\n'];
fprintf(fid,str);

str=['OrMethod=''' fis.orMethod '''\n'];
fprintf(fid,str);

str=['ImpMethod=''' fis.impMethod '''\n'];
fprintf(fid,str);

str=['AggMethod=''' fis.aggMethod '''\n'];
fprintf(fid,str);

str=['DefuzzMethod=''' fis.defuzzMethod '''\n'];
fprintf(fid,str);

str=['TypeRedMethod=''' fis.typeRedMethod '''\n'];
fprintf(fid,str);

for varIndex=1:length(fis.input),
    fprintf(fid,['\n[Input' num2str(varIndex) ']\n']);
    str=['Name=''' fis.input(varIndex).name '''\n'];
    fprintf(fid,str);
    str=['Range=' mat2str(fis.input(varIndex).range) '\n'];
    fprintf(fid,str);
    str=['NumMFs=' num2str(length(fis.input(varIndex).mf)) '\n'];
    fprintf(fid,str);
    
    for mfIndex=1:2*length(fis.input(varIndex).mf),
        if ~helper.isInt(mfIndex/2)
            str=['MF' num2str(round(mfIndex/2)) 'U' '=''' fis.input(varIndex).mf(mfIndex).name ''':'];
            fprintf(fid,str);
            str=['''' fis.input(varIndex).mf(mfIndex).type ''','];
            fprintf(fid,str);
            parstr = sprintf('%.15g ', fis.input(varIndex).mf(mfIndex).params);
            str = ['[' parstr(1:end-1) ']\n'];
            fprintf(fid,str);
        else
            str=['MF' num2str(round(mfIndex/2)) 'L' '=''' fis.input(varIndex).mf(mfIndex).name ''':'];
            fprintf(fid,str);
            str=['''' fis.input(varIndex).mf(mfIndex).type ''','];
            fprintf(fid,str);
            parstr = sprintf('%.15g ', fis.input(varIndex).mf(mfIndex).params);
            str = ['[' parstr(1:end-1) ']\n'];
            fprintf(fid,str);
        end
    end
end
for varIndex=1:length(fis.output),
    fprintf(fid,['\n[Output' num2str(varIndex) ']\n']);
    str=['Name=''' fis.output(varIndex).name '''\n'];
    fprintf(fid,str);
    str=['Range=' mat2str(fis.output(varIndex).range) '\n'];
    fprintf(fid,str);
    str=['NumMFs=' num2str(length(fis.output(varIndex).mf)) '\n'];
    fprintf(fid,str);
    
    for mfIndex=1:length(fis.output(varIndex).mf),
        str=['MF' num2str(mfIndex) '=''' fis.output(varIndex).mf(mfIndex).name ''':'];
        fprintf(fid,str);
        str=['''' fis.output(varIndex).mf(mfIndex).type ''','];
        fprintf(fid,str);
        parstr = sprintf('%.15g ', fis.output(varIndex).mf(mfIndex).params);
        str = ['[' parstr(1:end-1) ']\n'];
        fprintf(fid,str);
    end
end

str='\n[Rules]\n';
fprintf(fid,str);
for ruleIndex=1:length(fis.rule),
    antecedent=mat2str(fis.rule(ruleIndex).antecedent);
    if length(fis.input)>1
        antecedent=antecedent(2:end-1);
    end
    consequent=mat2str(fis.rule(ruleIndex).consequent);
    if length(fis.output)>1
        consequent=consequent(2:end-1);
    end
    str=[antecedent ', ' consequent ' ('...
        mat2str(fis.rule(ruleIndex).weight) ') : '...
        mat2str(fis.rule(ruleIndex).connection)...
        '\n'];
    fprintf(fid,str);
end

fclose(fid);
%% Close figures
if strcmpi(cmd,'close')
    for i=1:numel(tagList)
        fig=findobj(0,'tag',tagList{i});
        if ~isempty(fig)
            delete(fig(ishghandle(fig)));
        end
    end
end
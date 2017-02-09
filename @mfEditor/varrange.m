function [ obj ] = varrange( ~,~,obj )
figNumber=gcf;
fis=helper.getAppdata;
currVarAxes=findobj(figNumber,'Type','axes','XColor',selectColor);
varIndex=get(currVarAxes,'UserData');
varType=get(currVarAxes,'Tag');

% Get the range
oldRange=eval(['fis.' varType '(' num2str(varIndex) ').range']);

varRangeHndl=findobj(figNumber,'Type','uicontrol','Tag','varrange');
dispRangeHndl=findobj(figNumber,'Type','uicontrol','Tag','disprange');
newRangeStr=get(varRangeHndl,'String');

% We'll put the brackets in later; no point in dealing with the hassle
index=[find(newRangeStr=='[') find(newRangeStr==']')];
newRangeStr(index)=32*ones(size(index));
newRangeStr=['[' newRangeStr ']'];

% Use eval try-catch to prevent really weird stuff...
newRange=eval(newRangeStr,mat2str(oldRange,4));
if length(newRange)~=2,
    helper.statmsg(figNumber,'Range vector must have exactly two elements');
    newRange=oldRange;
end
if diff(newRange)<=0,
    helper.statmsg(figNumber,'Range vector must be of the form [lowLimit highLimit]');
    newRange=oldRange;
end

rangeStr=mat2str(newRange,4);
set(varRangeHndl,'String',[' ' rangeStr]);

% The next section changes the parameters of the MFs so they span the
% new range. This is appropriate for Mamdani systems, and for the inputs
% of Sugeno systems, but not for the output of Sugeno systems
if ~(strcmp(fis.type,'sugeno') & strcmp(varType,'output')),
    if ~all(newRange==oldRange),
        % Don't bother to do anything unless it's changed
        % Change all params here
        numMFs=eval(['length(fis.' varType '(' num2str(varIndex) ').mf)']);
        for count=1:numMFs*2,
            if ~helper.isInt(count/2)
                oldParams=eval(['fis.' varType '(' num2str(varIndex) ').mf(' num2str(count) ').params']);
                oldParams=oldParams(1:end-1);
                mfType=eval(['fis.' varType '(' num2str(varIndex)  ').mf(' num2str(count) ').type']);
                [newParams,errorStr]=strtchmf(oldParams,oldRange,newRange,mfType);
                newParams(end+1)=1;
                eval(['fis.' varType '(' num2str(varIndex) ').mf(' num2str(count) ').params=' mat2str(newParams) ';']);
            else
                oldParams=eval(['fis.' varType '(' num2str(varIndex) ').mf(' num2str(count) ').params']);
                oldParams=oldParams(1:end-1);
                mfType=eval(['fis.' varType '(' num2str(varIndex)  ').mf(' num2str(count) ').type']);
                [newParams,errorStr]=strtchmf(oldParams,oldRange,newRange,mfType);
                newParams(end+1)=0.5;
                eval(['fis.' varType '(' num2str(varIndex) ').mf(' num2str(count) ').params=' mat2str(newParams) ';']);
                
            end
        end
        eval(['fis.' varType '(' num2str(varIndex) ').range=' mat2str(newRange) ';']);
        
        helper.setAppdata(fis);
        
        % ... and plot
        set(dispRangeHndl,'String',[' ' rangeStr]);
        obj=plotmfs(obj);
    end
end
end


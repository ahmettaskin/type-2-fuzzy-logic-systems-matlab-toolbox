function [outStr,obj] = showRule(obj,fis,ruleIndex)
numInputs=length(fis.input);
numOutputs=length(fis.output);
for i=1:length(fis.input)
    numMFs = size(fis.input(i).mf);
    numInputMFs(i)=numMFs(2);
end
% totalInputMFs=sum(numInputMFs);
for i=1:length(fis.output)
    numMFs = size(fis.output(i).mf);
    numOutputMFs(i)=numMFs(2);
end
% totalOutputMFs=sum(numOutputMFs);
numRules=length(fis.rule);

if nargin<2,
    ruleIndex=1:numRules;
end

ruleFormat='verbose';


% Error checking
if any(ruleIndex<=0),
    error('Rule number must be positive');
end

if any(ruleIndex>numRules),
    error(['There are only ',num2str(numRules),' rules']);
end

if numRules<1,
    % If there are no rules, there is no output
    outStr=' ';
    return
end

if any(ruleIndex-floor(ruleIndex)),
    error('Illegal rule number');
end

if strcmp(ruleFormat,'verbose') || strcmp(ruleFormat,'symbolic'),
    inLabels=helper.getFis(fis,'inLabels');
    inMFLabels=helper.getFis(fis,'inMFLabels');
    outLabels=helper.getFis(fis,'outLabels');
    outMFLabels=helper.getFis(fis,'outMFLabels');
    
    lftParen='(';
    rtParen=')';
    if strcmp(ruleFormat,'verbose')
        ifStr='If ';
        andStr=' and ';
        orStr=' or ';
        thenStr='then ';
        equalStr=' is ';
        isStr=' is ';
        isnotEqualStr=' is not ';
    elseif strcmp(ruleFormat,'symbolic'),
        ifStr='';
        andStr=' & ';
        orStr=' | ';
        thenStr='=> ';
        equalStr='==';
        isStr='=';
        isnotEqualStr='~=';
    else
        % rule index version here (not complete yet)
        
    end
    
    ruleList=helper.getFis(fis,'ruleList');
    inputRules=ruleList(:,1:numInputs);
    
    for n=1:length(ruleIndex),
        rule=ruleList(ruleIndex(n),:);
        ruleWt=rule(numInputs+numOutputs+1);
        fuzzyOpCode=rule(numInputs+numOutputs+2);
        if fuzzyOpCode==1,
            opStr=andStr;
        elseif fuzzyOpCode==2,
            opStr=orStr;
        end
        wtStr=[lftParen num2str(ruleWt) rtParen];
        
        ruleStr1=ifStr;
        for inCount=1:numInputs,
            % Begin with the construction of the antecedent
            SignedMFIndex = rule(inCount);
            if SignedMFIndex~=0,
                MFIndex = sum(numInputMFs(1:(inCount-1)))+abs(SignedMFIndex);
                if SignedMFIndex>0,
                    % MF use is normal
                    ruleStr1=[ruleStr1, ...
                        lftParen,deblank(inLabels(inCount,:)),equalStr, ...
                        deblank(inMFLabels(MFIndex,:)),rtParen];
                else
                    % MF use requires a NOT operator
                    ruleStr1=[ruleStr1, ...
                        lftParen,deblank(inLabels(inCount,:)),isnotEqualStr, ...
                        deblank(inMFLabels(MFIndex,:)),rtParen];
                end
                % Apply the OPERATOR if appropriate
                % (the operator goes in only if there's more to the antecedent
                if any(ruleList(ruleIndex(n),(inCount+1):numInputs)),
                    ruleStr1=[ruleStr1 opStr];
                end
            end
        end
        
        % Now display the consequent
        opFlag=1;
        ruleStr2=thenStr;
        for outCount=1:numOutputs,
            % Begin the construction of the consequent
            SignedMFIndex = rule(outCount+numInputs);
            if SignedMFIndex~=0,
                MFIndex = sum(numOutputMFs(1:(outCount-1)))+abs(SignedMFIndex);
                if SignedMFIndex>0,
                    % MF use is normal
                    ruleStr2=[ruleStr2, ...
                        lftParen,deblank(outLabels(outCount,:)),isStr, ...
                        deblank(outMFLabels(MFIndex,:)),rtParen];
                else
                    % MF use requires a NOT operator
                    ruleStr2=[ruleStr2, ...
                        lftParen,deblank(outLabels(outCount,:)),isnotEqualStr, ...
                        deblank(outMFLabels(MFIndex,:)),rtParen];
                end
            end
        end
        
        if n==1,
            outStr=[num2str(ruleIndex(n)) '. ' ruleStr1 ' ' ruleStr2 ' ' wtStr];
        else
            outStr=str2mat(outStr,[num2str(ruleIndex(n)) '. ' ...
                ruleStr1 ' ' ruleStr2 ' ' wtStr]);
        end
        
    end    % for n=1:length(ruleIndex) ...
    
elseif strcmp(ruleFormat,'indexed'),
    ruleList=helper.getFis(fis,'ruleList');
    inputRules=ruleList(:,1:numInputs);
    outStr=[];
    for n=1:length(ruleIndex)
        rule=ruleIndex(n);
        
        ruleStr=[];
        for varIndex=1:numInputs,
            ruleStr=[ruleStr num2str(ruleList(rule,varIndex)) ' '];
        end
        % Remove the final space character
        ruleStr(length(ruleStr))=[];
        ruleStr=[ruleStr ', '];
        for varIndex=(1:numOutputs)+numInputs,
            ruleStr=[ruleStr num2str(ruleList(rule,varIndex)) ' '];
        end
        % Rule weights
        ruleStr=[ruleStr '(' num2str(ruleList(rule,numInputs+numOutputs+1)) ') '];
        % Fuzzy operator code
        ruleStr=[ruleStr ': ' num2str(ruleList(rule,numInputs+numOutputs+2)) ' '];
        
        if n==1,
            outStr=ruleStr;
        else
            outStr=str2mat(outStr,ruleStr);
        end
    end
else
    error([ruleFormat ' is an unknown rule format']);
end

end
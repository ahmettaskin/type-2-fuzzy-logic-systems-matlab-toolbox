function [it2fis]=rulet2(t2fis,inTxtRuleList)
numInputs=length(t2fis.input);
numOutputs=length(t2fis.output);

index=find(inTxtRuleList==0);
inTxtRuleList(index)=32*ones(size(index));
inTxtRuleList(all(inTxtRuleList'==32),:)=[];

inTxtRuleList2=inTxtRuleList;
index=[find(inTxtRuleList2==','),...
    find(inTxtRuleList2=='#'),...
    find(inTxtRuleList2==':'),...
    find(inTxtRuleList2=='('),...
    find(inTxtRuleList2==')'),...
    find(inTxtRuleList2<0)];
inTxtRuleList2(index)=32*ones(size(index));
inTxtRuleList2(all(inTxtRuleList2'==32),:)=[];
inTxtRuleList2=char(inTxtRuleList2);
numRules=size(inTxtRuleList2,1);
ruleList=zeros(numRules,numInputs+numOutputs+2);
for i=1:numRules
    str=['[' inTxtRuleList2(i,:) ']'];
    rule=eval(str,'[]');
    ruleList(i,:)=rule;
    t2fis.rule(i).antecedent=ruleList(i, 1:numInputs);
    t2fis.rule(i).consequent=ruleList(i, (numInputs+1):(numInputs+numOutputs));
    t2fis.rule(i).weight=ruleList(i, numInputs+numOutputs+1);
    t2fis.rule(i).connection=ruleList(i, numInputs+numOutputs+2);
end
it2fis=t2fis;
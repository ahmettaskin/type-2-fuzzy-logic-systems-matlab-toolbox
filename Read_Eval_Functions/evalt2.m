function y = evalt2 (input,t2fis,TRMethod)
if nargin==0
    prompt={'T2FIS file:','Inputs:'};
    name='EvalT2';
    numlines=1;
    t2fispath=cellstr(ls('*.t2fis'));
    if isempty(t2fispath)
        t2fispath='*.t2fis';
    else
        t2fispath=t2fispath{end,1};
    end
    defaultanswer={t2fispath,'[-0.3 0.6]'};
    answer=inputdlg(prompt,name,numlines,defaultanswer);
    drawnow;
    if isempty(answer)
        disp('User cancelled')
        return
    end
    inputUI=evalin('base',answer{2},'[]');
    for i=1:numel(inputUI)
        input(1,i)=inputUI(i);
    end
    [path,~]=fileparts(which(answer{1}));
    t2fis=readt2fis(answer{1},path);
    %     warning('function needs 2 input')
    %     return
end
if nargin == 3
    try
        t2fisstruct=evalin('base',t2fis);
    catch me
        if ~isempty(which(t2fis))
            [path,~]=fileparts(which(t2fis));
            t2fisstruct=readt2fis(t2fis,path);
        elseif ~isempty(which([t2fis '.t2fis']))
            [path,~]=fileparts(which([t2fis '.t2fis']));
            t2fisstruct=readt2fis([t2fis '.t2fis'],path);
        else
        end
    end
    input=input';
    if ischar(TRMethod)
        TRMethod=str2num(TRMethod);
    end
    t2fis=t2fisstruct;
    
    if TRMethod==0
        TRMethod='KM';
    elseif TRMethod==1
        t2fis.typeRedMethod='KM';
        TRMethod='KM';
    elseif TRMethod==2
        t2fis.typeRedMethod='EKM';
        TRMethod='EKM';
    elseif TRMethod==3
        t2fis.typeRedMethod='IASC';
        TRMethod='IASC';
    elseif TRMethod==4
        t2fis.typeRedMethod='EIASC';
        TRMethod='EIASC';
    elseif TRMethod==5
        t2fis.typeRedMethod='EODS';
        TRMethod='EODS';
    elseif TRMethod==6
        t2fis.typeRedMethod='WM';
        TRMethod='WM';
    elseif TRMethod==7
        t2fis.typeRedMethod='NT';
        TRMethod='NT';
    elseif TRMethod==8
        t2fis.typeRedMethod='BMM';
        TRMethod='BMM';
    elseif TRMethod==9
        t2fis.typeRedMethod='Custom';
    end
else
    TRMethod = t2fis.typeRedMethod;
end
% if ~isa(t2fis,'it2flsSession')
%     try
%         t2fis=readt2fis(t2fis);
%     catch
%     end
% end
% tic;

rules = cat(1,t2fis.rule.antecedent);

N = size(rules);
NofRule = N(1);
nInput = length(t2fis.input);
[inputN, ~] = size(input);
y = zeros(inputN,1);
% for i = 1:inputN
F = zeros(NofRule,2);
C = zeros(NofRule,1);
x = input(1,:);
%% ruleN = rule sayisi
for n=1:NofRule
    % Ateslemelerin hesaplanmasi
    f1U=1;
    f1L=1;
    for i=1:nInput
        % Calculate Lower firing
        if rules(n,i) > 0
            UpperParams = t2fis.input(i).mf(1,rules(n,i)).params;
            LowerParams = t2fis.input(i).mf(2,rules(n,i)).params;
            MemberUpper = UpperParams(end)*eval(['helper.' t2fis.input(i).mf(1,rules(n,i)).type '(x(i),UpperParams(1:end-1))']);
            MemberLower = LowerParams(end)*eval(['helper.' t2fis.input(i).mf(2,rules(n,i)).type '(x(i),LowerParams(1:end-1))']);
            f1U=f1U*MemberUpper;
            f1L=f1L*MemberLower;
        else
            UpperParams = t2fis.input(i).mf(1,abs(rules(n,i))).params;
            LowerParams = t2fis.input(i).mf(2,abs(rules(n,i))).params;
            MemberUpper = UpperParams(end)*eval(['helper.' t2fis.input(i).mf(1,abs(rules(n,i))).type '(x(i),UpperParams(1:end-1))']);
            MemberLower = LowerParams(end)*eval(['helper.' t2fis.input(i).mf(2,abs(rules(n,i))).type '(x(i),LowerParams(1:end-1))']);
            if MemberUpper==0
                MemberUpper=1;
            else
                MemberUpper=1/MemberUpper;
            end
            if MemberLower==0
                MemberLower=LowerParams(end);
            else
                MemberLower=LowerParams(end)/MemberLower;
            end
            f1U=f1U*MemberUpper;
            f1L=f1L*MemberLower;
        end
    end
    
    F(n,:) = [f1L,f1U];
    
    outputType = t2fis.output.mf(t2fis.rule(n).consequent).type;
    if strcmpi(outputType,'constant')
        outMFPar = t2fis.output.mf(t2fis.rule(n).consequent).params;
        %     C(n,:) = [x 1]*[outMFPar(1) outMFPar(1) outMFPar(1)]';
        C(n,:) = outMFPar(1);
        C(n,2) = outMFPar(2);
    elseif strcmpi(outputType,'linear')
        outMFPar = t2fis.output.mf(t2fis.rule(n).consequent).params;
        outMFParUpper =  outMFPar(1,1:nInput);
        C(n,:)=outMFParUpper*input'+outMFPar(1,nInput+1);
        
        outMFParLower =  outMFPar(1,end/2+1:end-1);
        C(n,2)=outMFParLower*input'+outMFPar(1,end);
        
    end
end

%% Read KM method from t2fis file

switch TRMethod
    case 'Karnik-Mendel'
        TRMethodfunc='t2f_TR_KM';
    case 'KM'
        TRMethodfunc='t2f_TR_KM';
    case 'EKM'
        TRMethodfunc='t2f_TR_EKM';
    case 'IASC'
        TRMethodfunc='t2f_TR_IASC';
    case 'EIASC'
        TRMethodfunc='t2f_TR_EIASC';
    case 'EODS'
        TRMethodfunc='t2f_TR_EODS';
    case 'WM'
        TRMethodfunc='t2f_TR_WM';
    case 'NT'
        TRMethodfunc='t2f_TR_NT';
    case 'BMM'
        TRMethodfunc='t2f_TR_BMM';
    otherwise
        TRMethodfunc=TRMethod;
end


%% Calculate Output
if strncmp(TRMethod,'BMM',3)
    alfa=str2num(TRMethod(5:regexp(TRMethod,',')-1));
    beta=str2num(TRMethod(regexp(TRMethod,',')+1:end-1));
    [yL,yR,L,R] = feval(TRMethodfunc,F,C);
else
    %       TRMethodfunc='t2f_TR_EIASC';
    [yL,yR,L,R] = feval(TRMethodfunc,F,C);
end
y=(yL+yR)/2;

% elapsedTime=toc;
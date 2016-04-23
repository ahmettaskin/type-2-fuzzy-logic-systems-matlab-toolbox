function obj = loadFromWs( ~,~,obj )
%LOADFROMWS Summary of this function goes here
%   Detailed explanation goes here

prompt={'Workspace file:'};
    name='T2FIS';
    numlines=1;
    defaultanswer={''};
    answer=inputdlg(prompt,name,numlines,defaultanswer);
    drawnow;
    if isempty(answer)
        return
    end
    newIt2fls=evalin('base',answer{1,1});
    hFuzzy=findall(0,'Tag','fuzzyt2');
    close(hFuzzy)
    command='new';
end


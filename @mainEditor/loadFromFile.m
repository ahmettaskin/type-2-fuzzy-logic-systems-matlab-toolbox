function obj = loadFromFile( ~,~, obj )
%LOADFROMFÝLE Summary of this function goes here
%   Detailed explanation goes here
    [loadfis,path]=uigetfile('*.t2fis','Select your t2fis file');
    if isequal(loadfis,0)
        return
    end
    newfis=readt2fis(loadfis,path);
    hFuzzy=findall(0,'Tag','fuzzyt2');
    close(hFuzzy)
    mainEditor(newfis);

end


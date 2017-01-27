function out = isNewGraphics()
verMatlab=ver('MATLAB');
if str2double(verMatlab.Version)>8.3
    out = true;
else
    out = false;
end
end
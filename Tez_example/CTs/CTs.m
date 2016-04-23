elapsedtime=[];
for i=1:30
    tic;
    helper.viewSurface;
    elapsedtime(i)=toc;
end
i
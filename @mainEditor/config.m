function [ obj ] = config( ~,~,obj )
%CONFÝG Summary of this function goes here
%   Detailed explanation goes here
        figNumber=gcf;
        
        fis=helper.getAppdata;
        
        TRmethods = get(findobj('tag','typeredMethod'),'String');
        TRmethodsval = get(findobj('tag','typeredMethod'),'Value');
        
        newTRmethod = deblank(TRmethods(TRmethodsval,:));
        if strcmp(newTRmethod,'BMM')
            prompt={'alpha','beta'};
            name='Enter alfa and beta';
            numlines=1;
            defaultanswer={'0.5','0.5'};
            answer=inputdlg(prompt,name,numlines,defaultanswer);
            drawnow;
            
            fis.typeRedMethod=[newTRmethod '(' answer{1} ',' answer{2} ')'];
        else
            fis.typeRedMethod=newTRmethod;
        end
        helper.setAppdata(fis);


end


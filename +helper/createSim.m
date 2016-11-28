function createSim(fileName,pathName)

% Open simulink
simulink;

% Specify the name of the model to create
 prompt={'Simulink file name:'};
    name='T2FIS';
    numlines=1;
    defaultanswer={'My_Interval_Type_2_Model'};
    answer=inputdlg(prompt,name,numlines,defaultanswer);
    drawnow;
fname = answer{1};

% Check if the file already exists and delete it if it does
if exist(fname,'file') == 4
    % If it does then check whether it's open
    if bdIsLoaded(fname)
        % If it is then close it (without saving!)
        close_system(fname,0)
    end
    % delete the file
    delete([fname,'.slx']);
end

%% Load t2fis
if nargin==0
    hFig = findall(0,'tag','fuzzyt2');
    t2fis=helper.getAppdata;
else
    t2fis=readt2fis(fileName,pathName);
end
assignin('base', 't2fisSim', t2fis)
% Create the system
new_system(fname);
save_system(fname);
open(fname);
% Get number of inputs
nInputs=numel(t2fis.input);

% % Add a subsystem
% add_block('simulink/Ports & Subsystems/Subsystem', [fname,'/Interval Type-2 Fuzzy Logic Controller'],...
%     'Position',[280 90 430 180]);
% delete_line([fname '/Interval Type-2 Fuzzy Logic Controller'],'In1/1','Out1/1')

% Add a mux
add_block('simulink/Signal Routing/Mux', [fname,'/Mux'],...
    'Position',[265 95 270 180],...
    'inputs',num2str(nInputs));

for i=1:nInputs
    % Add a Sine Wave, making the sample time continuous
    add_block('built-in/Constant', [fname,'/Input ' num2str(i)],...
        'Position', [140 15+70*i 170 45+70*i],...
        'SampleTime','-1');
%     if i>1
%         % Add Input to the Subsystem
%         add_block('simulink/Ports & Subsystems/In1', [fname,'/In' num2str(i)],...
%             'Position', [140 15+70*i 170 45+70*i],...
%             'SampleTime','0');
%     end
    % Connect the input to the mux
%      add_line(fname,['Input ' num2str(i) '/1'],['Interval Type-2 Fuzzy Logic Controller/' num2str(i)])
    add_line(fname,['Input ' num2str(i) '/1'],['Mux/' num2str(i)])
end


% add_block('Simulink/User-Defined Functions/Interpreted MATLAB Function', [gcs,'/t2fis'],...
%     'Position',[350 120 450 160],...
%     'MATLABFcn','evalt2(u,t2fisSim)');

add_block('Fuzzy_Type2_Lib/Interval Type-2 Fuzzy Logic Controller', [fname,'/t2fis'],...
    'Position',[350 120 450 160]);
set_param([fname,'/t2fis'],'t2fisSim','t2fisSim')
set_param([fname,'/t2fis'],'LinkStatus','inactive')
set_param([fname,'/t2fis/t2fis'],'OutputDimensions','1')

% Add a Display block
add_block('built-in/Display', [fname,'/Display'],...
    'Position',[550 120 610 160]);

% Connect the gain and the Display
add_line(fname,'Mux/1','t2fis/1')
add_line(fname,'t2fis/1','Display/1')
% add_line(fname,'Interval Type-2 Fuzzy Logic Controller/1','Display/1')
% Set a couple of model parameters to eliminate warning messages
set_param(fname,...
    'Solver','FixedStepDiscrete',...
    'FixedStep','0.1');
% Save the model
save_system(fname);
open(fname);